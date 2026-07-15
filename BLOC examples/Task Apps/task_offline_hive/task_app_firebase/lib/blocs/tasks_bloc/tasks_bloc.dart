import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import 'package:task_app_firebase/services/locator.dart';
import '../../models/task.dart';
import '../../respository/firestore_repository.dart';
import '../../respository/task_repository.dart';
import '../../services/sync_service.dart';
import '../bloc_exports.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  ConnectivityBloc connectivityBloc;
  final syncService = getIt.get<SyncService>();
  final TaskRepository repository;
  TasksBloc(this.connectivityBloc, this.repository)
    : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<GetAllTsak>(_onGetAllTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTask);
    on<SyncPendingTasks>(_onSyncPendingTasks);
  }

  TasksState _buildState(List<Task> tasks) {
    final pendingTasks = <Task>[];
    final completedTasks = <Task>[];
    final favoriteTasks = <Task>[];
    final removedTasks = <Task>[];

    for (final task in tasks) {
      if (task.isDeleted) {
        removedTasks.add(task);
        continue;
      }

      if (task.isDone) {
        completedTasks.add(task);
      } else {
        pendingTasks.add(task);
      }

      if (task.isFavorite) {
        favoriteTasks.add(task);
      }
    }
    debugPrint(
      "Pending=${pendingTasks.length} "
      "Completed=${completedTasks.length} "
      "Favorite=${favoriteTasks.length} "
      "Removed=${removedTasks.length}",
    );
    return TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: removedTasks,
    );
  }

  Future<void> _onSyncPendingTasks(
    SyncPendingTasks event,
    Emitter<TasksState> emit,
  ) async {
    try {
      // Always read the latest local data from Hive
      final localTasks = await repository.getAll();

      // Upload, download, merge
      final syncedTasks = await syncService.sync(localTasks);

      final pendingTasks = <Task>[];
      final completedTasks = <Task>[];
      final favoriteTasks = <Task>[];
      final removedTasks = <Task>[];
      _buildState(syncedTasks);

      for (final t in syncedTasks) {
        debugPrint("EMIT -> ${t.title} ${t.syncStatus} deleted=${t.isDeleted}");
      }
      emit(_buildState(syncedTasks));
    } catch (e) {
      debugPrint("Sync failed: $e");
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    final task = event.task.copyWith(syncStatus: SyncStatus.pendingCreate);

    await repository.create(task);

    emit(
      TasksState(
        pendingTasks: List<Task>.from(state.pendingTasks)..add(task),
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    // If online, start sync immediately
    if (connectivityBloc.state.status == ConnectionStatus.online) {
      add(SyncPendingTasks());
    }
    debugPrint(
      "ADD -> ${task.title}  ${task.syncStatus}  ${task.lastModified.toIso8601String()}",
    );
  }

  Future<void> _onGetAllTask(GetAllTsak event, Emitter<TasksState> emit) async {
    try {
      final allTasks = await repository.getAll();

      _buildState(allTasks);
      emit(_buildState(allTasks));
      debugPrint("===== ALL TASKS =====");

      for (final task in allTasks) {
        debugPrint(
          "${task.title} "
          "done=${task.isDone} "
          "favorite=${task.isFavorite} "
          "deleted=${task.isDeleted}",
        );
      }

      // Trigger background sync after local data is shown
      if (connectivityBloc.state.status == ConnectionStatus.online) {
        add(SyncPendingTasks());
      }
    } catch (e) {
      debugPrint("Failed to load tasks: $e");
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    final pendingTasks = List<Task>.from(state.pendingTasks);
    final completedTasks = List<Task>.from(state.completedTasks);

    final updatedTask = event.task.copyWith(
      isDone: !event.task.isDone,
      syncStatus: event.task.syncStatus == SyncStatus.pendingCreate
          ? SyncStatus.pendingCreate
          : SyncStatus.pendingUpdate,
      lastModified: DateTime.now().toUtc(),
    );

    if (!event.task.isDone) {
      pendingTasks.remove(event.task);
      completedTasks.insert(0, updatedTask);
    } else {
      completedTasks.remove(event.task);
      pendingTasks.insert(0, updatedTask);
    }

    await repository.update(updatedTask);

    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      add(SyncPendingTasks());
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    final removedTasks = List<Task>.from(state.removedTasks)
      ..removeWhere((task) => task.id == event.task.id);

    emit(
      TasksState(
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: removedTasks,
      ),
    );

    if (event.task.syncStatus == SyncStatus.pendingCreate) {
      // Task never reached Firebase.
      // Remove permanently from Hive.
      await repository.delete(event.task);
    } else {
      // Keep it in Hive until background sync deletes it from Firebase.
      await repository.update(
        event.task.copyWith(
          isDeleted: true,
          syncStatus: SyncStatus.pendingHardDelete,
        ),
      );
    }
  }

  Future<void> _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    final latestTask = [
      ...state.pendingTasks,
      ...state.completedTasks,
      ...state.favoriteTasks,
      ...state.removedTasks,
    ].firstWhere((t) => t.id == event.task.id);

    debugPrint(
      "EVENT  -> ${event.task.syncStatus}  deleted=${event.task.isDeleted}",
    );

    debugPrint(
      "STATE  -> ${latestTask.syncStatus}  deleted=${latestTask.isDeleted}",
    );
    final removedTask = latestTask.copyWith(
      isDeleted: true,
      lastModified: DateTime.now().toUtc(),
      syncStatus: latestTask.syncStatus == SyncStatus.pendingCreate
          ? SyncStatus.pendingCreate
          : SyncStatus.pendingUpdate,
    );

    final pendingTasks = List<Task>.from(state.pendingTasks)
      ..remove(event.task);

    final completedTasks = List<Task>.from(state.completedTasks)
      ..remove(event.task);

    final favoriteTasks = List<Task>.from(state.favoriteTasks)
      ..removeWhere((task) => task.id == event.task.id);

    final removedTasks = List<Task>.from(state.removedTasks)
      ..insert(0, removedTask);

    // Save locally
    await repository.update(removedTask);

    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: removedTasks,
      ),
    );

    // Sync immediately if online
    if (connectivityBloc.state.status == ConnectionStatus.online) {
      add(SyncPendingTasks());
    }
    debugPrint("REMOVE -> ${event.task.title} ${event.task.syncStatus}");
  }

  Future<void> _onMarkFavoriteOrUnfavoriteTask(
    MarkFavoriteOrUnfavoriteTask event,
    Emitter<TasksState> emit,
  ) async {
    final state = this.state;

    final pendingTasks = List<Task>.from(state.pendingTasks);
    final completedTasks = List<Task>.from(state.completedTasks);
    final favoriteTasks = List<Task>.from(state.favoriteTasks);

    final updatedTask = event.task.copyWith(
      isFavorite: !event.task.isFavorite,
      syncStatus: event.task.syncStatus == SyncStatus.pendingCreate
          ? SyncStatus.pendingCreate
          : SyncStatus.pendingUpdate,
      lastModified: DateTime.now().toUtc(),
    );

    // Update Pending / Completed list
    if (!event.task.isDone) {
      final index = pendingTasks.indexWhere((t) => t.id == event.task.id);

      if (index != -1) {
        pendingTasks[index] = updatedTask;
      }
    } else {
      final index = completedTasks.indexWhere((t) => t.id == event.task.id);

      if (index != -1) {
        completedTasks[index] = updatedTask;
      }
    }

    // Update Favorite list
    if (updatedTask.isFavorite) {
      if (!favoriteTasks.any((t) => t.id == updatedTask.id)) {
        favoriteTasks.insert(0, updatedTask);
      }
    } else {
      favoriteTasks.removeWhere((t) => t.id == updatedTask.id);
    }

    // Save locally
    await repository.update(updatedTask);

    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );
    debugPrint("===== FAVORITE EVENT =====");
    debugPrint(
      "EVENT -> "
      "done=${event.task.isDone} "
      "favorite=${event.task.isFavorite}",
    );

    final hiveTask = (await repository.getAll()).firstWhere(
      (t) => t.id == event.task.id,
    );

    debugPrint(
      "HIVE  -> "
      "done=${hiveTask.isDone} "
      "favorite=${hiveTask.isFavorite}",
    );
    if (connectivityBloc.state.status == ConnectionStatus.online) {
      add(SyncPendingTasks());
    }
  }

  Future<void> _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    final pendingTasks = List<Task>.from(state.pendingTasks);
    final completedTasks = List<Task>.from(state.completedTasks);
    final favoriteTasks = List<Task>.from(state.favoriteTasks);

    final updatedTask = event.newTask.copyWith(
      syncStatus: event.oldTask.syncStatus == SyncStatus.pendingCreate
          ? SyncStatus.pendingCreate
          : SyncStatus.pendingUpdate,
      lastModified: DateTime.now(),
    );

    // Update Pending list
    final pendingIndex = pendingTasks.indexWhere(
      (task) => task.id == event.oldTask.id,
    );
    if (pendingIndex != -1) {
      pendingTasks[pendingIndex] = updatedTask;
    }

    // Update Completed list
    final completedIndex = completedTasks.indexWhere(
      (task) => task.id == event.oldTask.id,
    );
    if (completedIndex != -1) {
      completedTasks[completedIndex] = updatedTask;
    }

    // Update Favorite list
    final favoriteIndex = favoriteTasks.indexWhere(
      (task) => task.id == event.oldTask.id,
    );
    if (favoriteIndex != -1) {
      favoriteTasks[favoriteIndex] = updatedTask;
    }

    // Save in Hive
    await repository.update(updatedTask);

    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );
    if (connectivityBloc.state.status == ConnectionStatus.online) {
      add(SyncPendingTasks());
    }
  }

  Future<void> _onRestoreTask(
    RestoreTask event,
    Emitter<TasksState> emit,
  ) async {
    final state = this.state;

    final restoredTask = event.task.copyWith(
      isDeleted: false,
      isDone: false,
      isFavorite: false,
      date: DateTime.now().toIso8601String(),
      syncStatus: event.task.syncStatus == SyncStatus.pendingCreate
          ? SyncStatus.pendingCreate
          : SyncStatus.pendingUpdate,
    );

    final removedTasks = List<Task>.from(state.removedTasks)
      ..removeWhere((task) => task.id == event.task.id);

    final pendingTasks = List<Task>.from(state.pendingTasks)
      ..insert(0, restoredTask);

    // Save locally
    await repository.update(restoredTask);

    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: removedTasks,
      ),
    );
    if (connectivityBloc.state.status == ConnectionStatus.online) {
      add(SyncPendingTasks());
    }
  }

  Future<void> _onDeleteAllTask(
    DeleteAllTasks event,
    Emitter<TasksState> emit,
  ) async {
    final state = this.state;

    final tasksToDelete = List<Task>.from(state.removedTasks);

    // Remove Bin from UI immediately
    emit(
      TasksState(
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: const [],
      ),
    );

    for (final task in tasksToDelete) {
      if (task.syncStatus == SyncStatus.pendingCreate) {
        // Never uploaded → delete locally
        await repository.delete(task);
      } else {
        // Already exists on server → mark for deletion
        await repository.update(
          task.copyWith(
            isDeleted: true,
            syncStatus: SyncStatus.pendingHardDelete,
          ),
        );
      }
    }
    if (connectivityBloc.state.status == ConnectionStatus.online) {
      add(SyncPendingTasks());
    }
  }
}

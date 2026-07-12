import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import 'package:task_app_firebase/services/locator.dart';
import '../../models/task.dart';
import '../../respository/firestore_repository.dart';
import '../../services/sync_service.dart';
import '../bloc_exports.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  ConnectivityBloc connectivityBloc;
  final syncService = getIt.get<SyncService>();

  TasksBloc(this.connectivityBloc) : super(const TasksState()) {
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
  

Future<void> _onSyncPendingTasks(
  SyncPendingTasks event,
  Emitter<TasksState> emit,
) async {

  final updatedPendingTasks =
      await syncService.syncPendingCreate(
        state.pendingTasks,
      );
  emit(
    TasksState(
      pendingTasks: updatedPendingTasks,
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
      removedTasks: state.removedTasks,
    ),
  );
}

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final state = this.state;

   // final updatedTasks = List<Task>.from(state.pendingTasks)..add(event.task);
  final task = connectivityBloc.state.status == ConnectionStatus.online
    ? event.task.copyWith(syncStatus: SyncStatus.synced)
    : event.task.copyWith(syncStatus: SyncStatus.pendingCreate);

  final updatedTasks = List<Task>.from(state.pendingTasks)..add(task);
    emit(
      TasksState(
        pendingTasks: updatedTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        final syncedTask = event.task.copyWith(syncStatus: SyncStatus.synced);

        await FirestoreRepository.create(task: syncedTask);

        final syncedPendingTasks = updatedTasks.map((task) {
          return task.id == syncedTask.id ? syncedTask : task;
        }).toList();

        emit(
          TasksState(
            pendingTasks: syncedPendingTasks,
            completedTasks: state.completedTasks,
            favoriteTasks: state.favoriteTasks,
            removedTasks: state.removedTasks,
          ),
        );

        debugPrint("Task synced");
      } catch (e) {
        debugPrint("Firebase error $e");
      }
    }
  }

  void _onGetAllTask(GetAllTsak event, Emitter<TasksState> emit) async {
    try {
      List<Task> remoteTasks = [];

      if (connectivityBloc.state.status == ConnectionStatus.online) {
        remoteTasks = await FirestoreRepository.get();
      }

      final localTasks = [
        ...state.pendingTasks,
        ...state.completedTasks,
        ...state.favoriteTasks,
        ...state.removedTasks,
      ];

      final localIds = localTasks.map((task) => task.id).toSet();

      final allTasks = [
        ...localTasks,
        ...remoteTasks.where((task) => !localIds.contains(task.id)),
      ];

      final pendingTasks = <Task>[];
      final completedTasks = <Task>[];
      final favoriteTasks = <Task>[];
      final removedTasks = <Task>[];

      for (final task in allTasks) {
        if (task.isDeleted!) {
          removedTasks.add(task);
        } else if (task.isFavorite!) {
          favoriteTasks.add(task);
        } else if (task.isDone!) {
          completedTasks.add(task);
        } else {
          pendingTasks.add(task);
        }
      }
      // for (final task in allTasks) {
      //   debugPrint("ALL: ${task.title} ${task.id}");
      // }
      debugPrint("Pending: ${state.pendingTasks.length}");
      debugPrint("Completed: ${state.completedTasks.length}");
      debugPrint("Favorite: ${state.favoriteTasks.length}");
      debugPrint("Removed: ${state.removedTasks.length}");
      debugPrint("========== LOCAL ==========");
      for (final task in localTasks) {
        debugPrint("${task.title} -> ${task.id}");
      }

      debugPrint("========== REMOTE ==========");
      for (final task in remoteTasks) {
        debugPrint("${task.title} -> ${task.id}");
      }
      emit(
        TasksState(
          pendingTasks: pendingTasks,
          completedTasks: completedTasks,
          favoriteTasks: favoriteTasks,
          removedTasks: removedTasks,
        ),
      );
    } catch (e) {
      debugPrint("Get task failed: $e");
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    final pendingTasks = List<Task>.from(state.pendingTasks);
    final completedTasks = List<Task>.from(state.completedTasks);

    final updatedTask = event.task.copyWith(isDone: !event.task.isDone!);

    if (!event.task.isDone!) {
      pendingTasks.remove(event.task);
      completedTasks.insert(0, updatedTask);
    } else {
      completedTasks.remove(event.task);
      pendingTasks.insert(0, updatedTask);
    }

    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.update(updatedTask);
      } catch (e) {
        debugPrint("Update task failed: $e");
      }
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    // Remove locally first
    final updatedRemovedTasks = List<Task>.from(state.removedTasks)
      ..remove(event.task);

    emit(
      TasksState(
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: updatedRemovedTasks,
      ),
    );
    debugPrint("Delete event received for ${event.task.id}");
    debugPrint("Connection Status: ${connectivityBloc.state.status}");
    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.delete(task: event.task);

        debugPrint("${event.task.title} deleted from Firebase");
      } catch (e) {
        debugPrint("Delete failed: $e");
      }
    }
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    final removedTask = event.task.copyWith(isDeleted: true);

    final updatedPendingTasks = List<Task>.from(state.pendingTasks)
      ..remove(event.task);

    final updatedRemovedTasks = List<Task>.from(state.removedTasks)
      ..add(removedTask);

    emit(
      TasksState(
        pendingTasks: updatedPendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: updatedRemovedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.update(removedTask);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void _onMarkFavoriteOrUnfavoriteTask(
    MarkFavoriteOrUnfavoriteTask event,
    Emitter<TasksState> emit,
  ) async {
    final state = this.state;

    final pendingTasks = List<Task>.from(state.pendingTasks);
    final completedTasks = List<Task>.from(state.completedTasks);
    final favoriteTasks = List<Task>.from(state.favoriteTasks);

    final updatedTask = event.task.copyWith(
      isFavorite: !event.task.isFavorite!,
    );

    // Update Pending or Completed list
    if (!event.task.isDone!) {
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
    if (updatedTask.isFavorite!) {
      // Prevent duplicate entries
      if (!favoriteTasks.any((t) => t.id == updatedTask.id)) {
        favoriteTasks.insert(0, updatedTask);
      }
    } else {
      favoriteTasks.removeWhere((t) => t.id == updatedTask.id);
    }
    debugPrint("-------- Favorites --------");
    for (final task in favoriteTasks) {
      debugPrint("${task.title} -> ${task.id}");
    }
    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.update(updatedTask);
      } catch (e) {
        debugPrint("Favorite sync failed: $e");
      }
    }
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    final pendingTasks = List<Task>.from(state.pendingTasks);

    final completedTasks = List<Task>.from(state.completedTasks);

    final favouriteTasks = List<Task>.from(state.favoriteTasks);

    if (pendingTasks.remove(event.oldTask)) {
      pendingTasks.insert(0, event.newTask);
    }

    if (completedTasks.remove(event.oldTask)) {
      completedTasks.insert(0, event.newTask);
    }

    if (favouriteTasks.remove(event.oldTask)) {
      favouriteTasks.insert(0, event.newTask);
    }

    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favouriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.update(event.newTask);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    Task restoreTask = event.task.copyWith(
      isDeleted: false,
      isDone: false,
      isFavorite: false,
      date: DateTime.now().toString(),
    );

    emit(
      TasksState(
        removedTasks: List.from(state.removedTasks)..remove(event.task),
        pendingTasks: List.from(state.pendingTasks)..insert(0, restoreTask),
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.update(restoreTask);
      } catch (e) {
        debugPrint("Restore failed: $e");
      }
    }
  }

  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) async {
    final state = this.state;
    final tasksToDelete = List<Task>.from(state.removedTasks);

    emit(
      TasksState(
        removedTasks: const [], // List.from(state.removedTasks)..clear(),
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.deleteAllRemovedTask(taskList: tasksToDelete);
      } catch (e) {
        debugPrint("Restore failed: $e");
      }
    }
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}

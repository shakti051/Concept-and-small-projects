import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import 'package:task_app_firebase/core/logger/logger.dart';
import 'package:task_app_firebase/extensions/emitter_extension.dart';
import 'package:task_app_firebase/services/locator.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/failures/failures.dart';
import '../../core/utils/logger.dart';
import '../../extensions/connectivity_bloc_extension.dart';
import '../../extensions/emitter_extension.dart';
import '../../extensions/sync_report_extension.dart';
import '../../extensions/task_list_extension.dart';
import '../../extensions/tasks_bloc_helpers.dart';
import '../../models/sync_report.dart';
import '../../models/task.dart';
import '../../respository/firestore_repository.dart';
import '../../respository/task_repository.dart';
import '../../services/sync_queue.dart';
import '../../services/sync_service.dart';
import '../bloc_exports.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  ConnectivityBloc connectivityBloc;
  final SyncQueue syncQueue; // ✅
  final syncService = getIt.get<SyncService>();
  final TaskRepository repository;
   LoggerService logger  = getIt<LoggerService>();
  TasksBloc(this.connectivityBloc, this.repository, this.syncQueue,this.logger)
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
    on<SyncPendingTasks>(_onSyncPendingTasks, transformer: droppable());
  }

  String _buildSyncMessage(SyncReport report) {
    final parts = <String>[];

    if (report.uploaded > 0) {
      parts.add("${report.uploaded} uploaded");
    }

    if (report.updated > 0) {
      parts.add("${report.updated} updated");
    }

    if (report.deleted > 0) {
      parts.add("${report.deleted} deleted");
    }

    if (parts.isEmpty) {
      parts.add("Everything is already up to date");
    }

    if (report.failed > 0) {
      parts.add("${report.failed} failed");
    }

    return parts.join(", ");
  }

  TasksState _buildState(
    List<Task> tasks, {
    SyncState syncState = SyncState.idle,
  }) {
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

    return TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: removedTasks,
      syncState: syncState,
    );
  }

  Future<void> _onSyncPendingTasks(
    SyncPendingTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(
      state.copyWith(syncState: SyncState.syncing, syncMessage: "Syncing..."),
    );

    try {
      final localTasks = await repository.getAll();

      final report = await syncService.sync(localTasks);

      emit(
        report.tasks
            .toTasksState(
              syncState: report.failed == 0
                  ? SyncState.synced
                  : SyncState.failed,
            )
            .copyWith(syncMessage: report.message),
      );
    } on AuthenticationException {
      emit(
        state.copyWith(
          syncState: SyncState.failed,
          syncMessage: "Session expired. Please login again.",
        ),
      );
    } on NetworkException {
      emit(
        state.copyWith(
          syncState: SyncState.failed,
          syncMessage: "No internet connection.",
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          syncState: SyncState.failed,
          syncMessage: "Sync failed. Will retry automatically.",
        ),
      );
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final task = event.task.copyWith(syncStatus: SyncStatus.pendingCreate);

    try {
      await repository.create(task);

      final allTasks = await repository.getAll();

      emit(allTasks.toTasksState().copyWith(syncState: SyncState.idle));
      syncIfOnline();
      logger.info(
        "ADD -> ${task.title} ${task.syncStatus} ${task.lastModified.toUtc()}",
      );
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(state);
    }
  }

  Future<void> _onGetAllTask(GetAllTsak event, Emitter<TasksState> emit) async {
    try {
      final allTasks = await repository.getAll();

      //emit(_buildState(allTasks));
      //allTasks.toTasksState(syncState: SyncState.synced);
      emitTasks(emit, allTasks, syncState: SyncState.synced);
      logAllTasks(allTasks);

      syncIfOnline();
    } on LocalDatabaseException {
      loadTasksFailure(emit, "Unable to load local tasks.");
    } catch (e, stack) {
      logUnknownError(e, stack);

      loadTasksFailure(emit, "Something went wrong while loading tasks.");
    }
  }
  
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    final updatedTask = event.task.copyWith(
      isDone: !event.task.isDone,
      syncStatus: event.task.syncStatus == SyncStatus.pendingCreate
          ? SyncStatus.pendingCreate
          : SyncStatus.pendingUpdate,
      lastModified: DateTime.now().toUtc(),
    );

    try {
      // Save locally
      await repository.update(updatedTask);

      // Reload latest tasks from Hive
      final allTasks = await repository.getAll();

      emit(allTasks.toTasksState());

      // Sync with Firebase if online
      syncIfOnline();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(state);
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    try {
      if (event.task.syncStatus == SyncStatus.pendingCreate) {
        // Never uploaded to Firebase
        await repository.delete(event.task);
      } else {
        // Mark for background deletion
        await repository.update(
          event.task.copyWith(
            isDeleted: true,
            syncStatus: SyncStatus.pendingHardDelete,
            lastModified: DateTime.now().toUtc(),
          ),
        );
      }

      final allTasks = await repository.getAll();

      emit(allTasks.toTasksState());

      logTask(action: "DELETE", task: event.task);

      syncIfOnline();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(state);
    }
  }

  Future<void> _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    final latestTask = [
      ...state.pendingTasks,
      ...state.completedTasks,
      ...state.favoriteTasks,
      ...state.removedTasks,
    ].firstWhere((t) => t.id == event.task.id);

    final removedTask = latestTask.copyWith(
      isDeleted: true,
      lastModified: DateTime.now().toUtc(),
      syncStatus: latestTask.syncStatus == SyncStatus.pendingCreate
          ? SyncStatus.pendingCreate
          : SyncStatus.pendingUpdate,
    );

    try {
      // Save locally
      await repository.update(removedTask);

      // Reload latest tasks from Hive
      final allTasks = await repository.getAll();

      emit(allTasks.toTasksState());

      logTask(action: "REMOVE", task: removedTask);

      syncIfOnline();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(
        state,
        message: "Couldn't remove task locally.",
      );
    } catch (e, stack) {
      emit.emitUnknownFailure(
        state,
        e,
        stack,
        message: "Something went wrong while removing the task.",
      );
    }
  }

  //work from here
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

    try {
      // Save locally
      await repository.update(updatedTask);

      emit(
        state.copyWith(
          pendingTasks: pendingTasks,
          completedTasks: completedTasks,
          favoriteTasks: favoriteTasks,
        ),
      );

      if (connectivityBloc.state.status == ConnectionStatus.online) {
        add(SyncPendingTasks());
      }

      debugPrint("===== FAVORITE EVENT =====");
      debugPrint(
        "EVENT -> done=${event.task.isDone} favorite=${event.task.isFavorite}",
      );

      final hiveTask = (await repository.getAll()).firstWhere(
        (t) => t.id == event.task.id,
      );

      debugPrint(
        "HIVE -> done=${hiveTask.isDone} favorite=${hiveTask.isFavorite}",
      );
    } on LocalDatabaseException {
      emit(
        state.copyWith(
          syncState: SyncState.failed,
          syncMessage: "Couldn't update task locally.",
        ),
      );
    } catch (e) {
      debugPrint(e.toString());

      emit(
        state.copyWith(
          syncState: SyncState.failed,
          syncMessage: "Something went wrong.",
        ),
      );
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
      lastModified: DateTime.now().toUtc(),
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

    try {
      // Save locally
      await repository.update(updatedTask);

      emit(
        state.copyWith(
          pendingTasks: pendingTasks,
          completedTasks: completedTasks,
          favoriteTasks: favoriteTasks,
          syncMessage: "Task updated.",
        ),
      );

      // Sync immediately if online
      if (connectivityBloc.state.status == ConnectionStatus.online) {
        add(SyncPendingTasks());
      }
    } on LocalDatabaseFailure catch (e) {
      emit(state.copyWith(syncState: SyncState.failed, syncMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          syncState: SyncState.failed,
          syncMessage: "Failed to update task.",
        ),
      );
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
      lastModified: DateTime.now().toUtc(),
      syncStatus: event.task.syncStatus == SyncStatus.pendingCreate
          ? SyncStatus.pendingCreate
          : SyncStatus.pendingUpdate,
    );

    final removedTasks = List<Task>.from(state.removedTasks)
      ..removeWhere((task) => task.id == event.task.id);

    final pendingTasks = List<Task>.from(state.pendingTasks)
      ..insert(0, restoredTask);

    try {
      // Save locally
      await repository.update(restoredTask);

      emit(
        state.copyWith(pendingTasks: pendingTasks, removedTasks: removedTasks),
      );

      // Sync immediately if online
      if (connectivityBloc.state.status == ConnectionStatus.online) {
        add(SyncPendingTasks());
      }
    } on LocalDatabaseFailure catch (e) {
      emit(state.copyWith(syncState: SyncState.failed, syncMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          syncState: SyncState.failed,
          syncMessage: "Failed to restore task.",
        ),
      );
    }
  }

  Future<void> _onDeleteAllTask(
    DeleteAllTasks event,
    Emitter<TasksState> emit,
  ) async {
    final state = this.state;

    final tasksToDelete = List<Task>.from(state.removedTasks);

    try {
      // Remove Bin immediately
      emit(state.copyWith(removedTasks: const []));

      for (final task in tasksToDelete) {
        if (task.syncStatus == SyncStatus.pendingCreate) {
          // Never uploaded -> remove permanently
          await repository.delete(task);
        } else {
          // Already uploaded -> mark for background delete
          await repository.update(
            task.copyWith(
              isDeleted: true,
              syncStatus: SyncStatus.pendingHardDelete,
              lastModified: DateTime.now().toUtc(),
            ),
          );
        }
      }

      if (connectivityBloc.state.status == ConnectionStatus.online) {
        add(SyncPendingTasks());
      }
    } on LocalDatabaseFailure catch (e) {
      emit(state.copyWith(syncState: SyncState.failed, syncMessage: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          syncState: SyncState.failed,
          syncMessage: "Failed to delete all tasks.",
        ),
      );
    }
  }
}

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import 'package:task_app_firebase/core/logger/logger.dart';
import 'package:task_app_firebase/extensions/emitter_extension.dart';
import 'package:task_app_firebase/extensions/task_sorting.dart';
import 'package:task_app_firebase/services/locator.dart';
import 'package:task_app_firebase/services/sync_schedular.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/failures/failures.dart';
import '../../core/utils/logger.dart';
import '../../extensions/connectivity_bloc_extension.dart';
import '../../extensions/emitter_extension.dart';
import '../../extensions/sync_report_extension.dart';
import '../../extensions/task_extension.dart';
import '../../extensions/task_list_extension.dart';
import '../../extensions/tasks_bloc_helpers.dart';
import '../../models/sync_report.dart';
import '../../models/task.dart';
import '../../respository/firestore_repository.dart';
import '../../respository/task_repository.dart';
import '../../services/retry_scheduler.dart';
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
  final LoggerService logger;
  final SyncScheduler syncScheduler;
  final RetryScheduler retryScheduler;
  TasksBloc(
    this.connectivityBloc,
    this.repository,
    this.syncQueue,
    this.logger,
    this.syncScheduler,
    this.retryScheduler,
  ) : super(const TasksState()) {
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

  @override
  Future<void> close() {
    syncScheduler.dispose();
    retryScheduler.dispose();
    return super.close();
  }


  Future<void> _onSyncPendingTasks(
    SyncPendingTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(
      state.copyWith(syncState: SyncState.syncing, syncMessage: "Syncing..."),
    );

    try {
      final report = await syncService.sync(await repository.getAll());

      // Sync succeeded -> reset retry attempts
      retryScheduler.reset();

      emitTasks(
        emit,
        report.tasks,
        syncState: report.failed == 0 ? SyncState.synced : SyncState.failed,
        syncMessage: report.message,
      );
    } on AuthenticationException {
      retryScheduler.reset();

      emit.emitAuthenticationFailure(state);
    } on NetworkException {
      emit.emitNetworkFailure(state);

      retryScheduler.schedule(() {
        if (connectivityBloc.isOnline) {
          add(const SyncPendingTasks());
        }
      });
    } catch (e, stack) {
      emit.emitUnknownFailure(
        state,
        e,
        stack,
        message: "Sync failed. Will retry automatically.",
      );

      retryScheduler.schedule(() {
        if (connectivityBloc.isOnline) {
          add(const SyncPendingTasks());
        }
      });
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final task = event.task.copyWith(syncStatus: SyncStatus.pendingCreate);

    try {
      await repository.create(task);

      emit((await repository.getAll()).toTasksState());

      scheduleSync();

      logger.info(
        "ADD -> ${task.title} "
        "${task.syncStatus} "
        "${task.lastModified.toUtc()}",
      );
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(state);
    }
  }

  Future<void> _onGetAllTask(GetAllTsak event, Emitter<TasksState> emit) async {
    try {
      final allTasks = await repository.getAll();

      emitTasks(emit, allTasks, syncState: SyncState.synced);

      logAllTasks(allTasks);

      // Sync only if there is something pending
      if (allTasks.any((task) => task.syncStatus != SyncStatus.synced)) {
        scheduleSync();
      }
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
      syncStatus: event.task.nextSyncStatus,
      lastModified: DateTime.now().toUtc(),
    );

    try {
      await repository.update(updatedTask);

      await emitLatestTasks(emit);

      scheduleSync();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(state);
    } catch (e, stack) {
      emit.emitUnknownFailure(
        state,
        e,
        stack,
        message: "Couldn't update task.",
      );
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    try {
      if (event.task.syncStatus == SyncStatus.pendingCreate) {
        await repository.delete(event.task);
      } else {
        await repository.update(event.task.markForHardDelete);
      }

      await emitLatestTasks(emit);

      logTask(action: "DELETE", task: event.task);

      scheduleSync();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(state);
    } catch (e, stack) {
      emit.emitUnknownFailure(
        state,
        e,
        stack,
        message: "Couldn't delete task.",
      );
    }
  }

  Future<void> _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    Task latestTask(String id) {
      return [
        ...state.pendingTasks,
        ...state.completedTasks,
        ...state.favoriteTasks,
        ...state.removedTasks,
      ].firstWhere((t) => t.id == id);
    }

    final removedTask = latestTask(event.task.id).markAsRemoved;

    try {
      await repository.update(removedTask);

      await emitLatestTasks(emit);

      logTask(action: "REMOVE", task: removedTask);

      scheduleSync();
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
    final updatedTask = event.task.toggleFavorite();

    try {
      await repository.update(updatedTask);

      await emitLatestTasks(emit);

      logTask(action: "FAVORITE", task: updatedTask);

      scheduleSync();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(
        state,
        message: "Couldn't update task locally.",
      );
    } catch (e, stack) {
      emit.emitUnknownFailure(
        state,
        e,
        stack,
        message: "Something went wrong while updating the task.",
      );
    }
  }

  Future<void> _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    final updatedTask = event.newTask.copyWith(
      syncStatus: event.oldTask.nextSyncStatus,
      lastModified: DateTime.now().toUtc(),
    );

    try {
      await repository.update(updatedTask);

      await emitLatestTasks(emit);

      logTask(action: "EDIT", task: updatedTask);

      scheduleSync();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(
        state,
        message: "Couldn't edit task locally.",
      );
    } catch (e, stack) {
      emit.emitUnknownFailure(state, e, stack, message: "Failed to edit task.");
    }
  }

  Future<void> _onRestoreTask(
    RestoreTask event,
    Emitter<TasksState> emit,
  ) async {
    final restoredTask = event.task.restored;

    try {
      await repository.update(restoredTask);

      await emitLatestTasks(emit);

      logTask(action: "RESTORE", task: restoredTask);

      scheduleSync();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(
        state,
        message: "Couldn't restore task locally.",
      );
    } catch (e, stack) {
      emit.emitUnknownFailure(
        state,
        e,
        stack,
        message: "Failed to restore task.",
      );
    }
  }

  Future<void> _onDeleteAllTask(
    DeleteAllTasks event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final tasks = List<Task>.from(state.removedTasks);

      for (final task in tasks) {
        if (task.syncStatus == SyncStatus.pendingCreate) {
          await repository.delete(task);
        } else {
          await repository.update(task.markForHardDelete);
        }
      }

      await emitLatestTasks(emit);

      logger.info("DELETE ALL -> ${tasks.length} tasks");

      scheduleSync();
    } on LocalDatabaseException {
      emit.emitLocalDatabaseFailure(
        state,
        message: "Couldn't delete all tasks locally.",
      );
    } catch (e, stack) {
      emit.emitUnknownFailure(
        state,
        e,
        stack,
        message: "Failed to delete all tasks.",
      );
    }
  }
}

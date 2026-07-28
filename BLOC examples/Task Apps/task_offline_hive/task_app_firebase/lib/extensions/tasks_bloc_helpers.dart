import 'package:flutter/foundation.dart';
import 'package:task_app_firebase/services/sync_queue.dart';
import '../blocs/bloc_exports.dart';
import '../blocs/tasks_bloc/tasks_bloc.dart';
import '../models/task.dart';
import 'connectivity_bloc_extension.dart';
import 'task_list_extension.dart';

extension TaskBlocHelpers on TasksBloc {
  void syncIfOnline() {
    syncQueue.enqueue(() {
      if (connectivityBloc.isOnline) {
        add(SyncPendingTasks());
      }
    });
  }

  void emitTasks(
    Emitter<TasksState> emit,
    List<Task> tasks, {
    SyncState syncState = SyncState.idle,
  }) {
    emit(tasks.toTasksState(syncState: syncState));
  }

  void logAllTasks(List<Task> tasks) {
    debugPrint("===== ALL TASKS =====");

    for (final task in tasks) {
      debugPrint(
        "${task.title} "
        "done=${task.isDone} "
        "favorite=${task.isFavorite} "
        "deleted=${task.isDeleted}",
      );
    }
  }

  void loadTasksFailure(Emitter<TasksState> emit, String message) {
    emit(state.copyWith(syncState: SyncState.failed, syncMessage: message));
  }

  void logUnknownError(Object error, StackTrace stack) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stack);
  }
}

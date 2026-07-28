import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app_firebase/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:flutter/foundation.dart';

extension TasksEmitterExtension on Emitter<TasksState> {
  void emitFailure(TasksState state, String message) {
    call(state.copyWith(syncState: SyncState.failed, syncMessage: message));
  }

  void emitLocalDatabaseFailure(TasksState state) {
    emitFailure(state, "Unable to load local data.");
  }

  void emitNetworkFailure(TasksState state) {
    emitFailure(state, "No internet connection.");
  }

  void emitAuthenticationFailure(TasksState state) {
    emitFailure(state, "Session expired. Please login again.");
  }

  void emitSyncFailure(TasksState state) {
    emitFailure(state, "Sync failed. Will retry automatically.");
  }

  void emitUnknownFailure(
    TasksState state,
    Object error,
    StackTrace stack, {
    String message = "Something went wrong.",
  }) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stack);
    emitFailure(state, message);
  }
}

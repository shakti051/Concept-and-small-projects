import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/tasks_bloc/tasks_bloc.dart';

extension TasksEmitterExtension on Emitter<TasksState> {
  void emitFailure(TasksState state, String message) {
    call(state.copyWith(syncState: SyncState.failed, syncMessage: message));
  }

  void emitLocalDatabaseFailure(
    TasksState state, {
    String message = "Unable to perform local operation.",
  }) {
    emitFailure(state, message);
  }

  void emitNetworkFailure(
    TasksState state, {
    String message = "No internet connection.",
  }) {
    emitFailure(state, message);
  }

  void emitAuthenticationFailure(
    TasksState state, {
    String message = "Session expired. Please login again.",
  }) {
    emitFailure(state, message);
  }

  void emitSyncFailure(
    TasksState state, {
    String message = "Sync failed. Will retry automatically.",
  }) {
    emitFailure(state, message);
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

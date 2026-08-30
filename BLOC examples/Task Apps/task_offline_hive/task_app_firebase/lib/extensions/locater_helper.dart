
import 'package:flutter/material.dart';
import 'package:task_app_firebase/respository/task_repository.dart';

import '../blocs/bloc_exports.dart';
import '../blocs/connectivity/connectivity_bloc.dart';
import '../blocs/tasks_bloc/tasks_bloc.dart';
import '../core/logger/logger.dart';
import '../services/locator.dart';
import '../services/retry_scheduler.dart';
import '../services/sync_queue.dart';
import '../services/sync_schedular.dart';
import '../services/sync_service.dart';

TasksBloc createTasksBloc(BuildContext context) {
  return TasksBloc(
    context.read<ConnectivityBloc>(),
    getIt<TaskRepository>(),
    getIt<SyncQueue>(),
    getIt<LoggerService>(),
    getIt<SyncScheduler>(),
    getIt<RetryScheduler>(),
    getIt<SyncService>(),
  );
}
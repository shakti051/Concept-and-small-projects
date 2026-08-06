import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:uuid/uuid.dart';

import '../constants/hive_boxes.dart';
import '../core/logger/logger.dart';
import '../data/local/hive_task_datasource.dart';
import '../respository/task_repository.dart';
import 'retry_scheduler.dart';
import 'sync_queue.dart';
import 'sync_schedular.dart';
import 'sync_service.dart';

final getIt = GetIt.instance;

Future<void> setupUserLocator(String email) async {
  final normalizedEmail = email.trim().toLowerCase();

  final boxName = HiveBoxes.tasks(normalizedEmail);

  // Open user's Hive box
  if (!Hive.isBoxOpen(boxName)) {
    await Hive.openBox<Task>(boxName);
  }

  // ------------------------------------------------------------
  // Remove previous user-specific dependencies
  // ------------------------------------------------------------

  if (getIt.isRegistered<SyncService>()) {
    await getIt.unregister<SyncService>();
  }

  if (getIt.isRegistered<TaskRepository>()) {
    await getIt.unregister<TaskRepository>();
  }

  if (getIt.isRegistered<HiveTaskDataSource>()) {
    await getIt.unregister<HiveTaskDataSource>();
  }

  // ------------------------------------------------------------
  // Common services required by TasksBloc
  // ------------------------------------------------------------

  if (!getIt.isRegistered<Uuid>()) {
    getIt.registerLazySingleton<Uuid>(
      () => const Uuid(),
    );
  }

  if (!getIt.isRegistered<SyncQueue>()) {
    getIt.registerLazySingleton<SyncQueue>(
      () => SyncQueue(),
    );
  }

  if (!getIt.isRegistered<LoggerService>()) {
    getIt.registerLazySingleton<LoggerService>(
      () => LoggerService(),
    );
  }

  if (!getIt.isRegistered<RetryScheduler>()) {
    getIt.registerLazySingleton<RetryScheduler>(
      () => RetryScheduler(),
    );
  }

  if (!getIt.isRegistered<SyncScheduler>()) {
    getIt.registerLazySingleton<SyncScheduler>(
      () => SyncScheduler(),
    );
  }

  // ------------------------------------------------------------
  // User-specific Hive datasource
  // ------------------------------------------------------------

  final hiveDataSource = HiveTaskDataSource(normalizedEmail);

  getIt.registerSingleton<HiveTaskDataSource>(
    hiveDataSource,
  );

  // ------------------------------------------------------------
  // User-specific repository
  // ------------------------------------------------------------

  final repository = TaskRepository(
    hiveDataSource,
  );

  getIt.registerSingleton<TaskRepository>(
    repository,
  );

  // ------------------------------------------------------------
  // User-specific sync service
  // ------------------------------------------------------------

  getIt.registerSingleton<SyncService>(
    SyncService(repository),
  );
}
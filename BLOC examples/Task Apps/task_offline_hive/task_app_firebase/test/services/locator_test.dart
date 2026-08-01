import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:task_app_firebase/data/local/hive_task_datasource.dart';
import 'package:task_app_firebase/respository/task_repository.dart';
import 'package:task_app_firebase/services/locator.dart';
import 'package:task_app_firebase/services/retry_scheduler.dart';
import 'package:task_app_firebase/services/sync_queue.dart';
import 'package:task_app_firebase/services/sync_schedular.dart';
import 'package:task_app_firebase/services/sync_service.dart';
import 'package:task_app_firebase/core/logger/logger.dart';
import 'package:uuid/uuid.dart';

void main() {
  final locator = GetIt.instance;

  setUp(() async {
    await locator.reset();
  });

  tearDown(() async {
    await locator.reset();
  });

  group('setupLocator', () {
    test('should register all dependencies', () async {
      await setupLocator();

      expect(locator.isRegistered<HiveTaskDataSource>(), true);
      expect(locator.isRegistered<TaskRepository>(), true);
      expect(locator.isRegistered<SyncService>(), true);
      expect(locator.isRegistered<Uuid>(), true);
      expect(locator.isRegistered<SyncQueue>(), true);
      expect(locator.isRegistered<LoggerService>(), true);
      expect(locator.isRegistered<SyncScheduler>(), true);
      expect(locator.isRegistered<RetryScheduler>(), true);
    });

    test('should resolve TaskRepository', () async {
      await setupLocator();

      final repository = locator<TaskRepository>();

      expect(repository, isA<TaskRepository>());
    });

    test('should resolve SyncService', () async {
      await setupLocator();

      final syncService = locator<SyncService>();

      expect(syncService, isA<SyncService>());
    });

    test('should resolve Uuid', () async {
      await setupLocator();

      final uuid = locator<Uuid>();

      expect(uuid, isA<Uuid>());
    });

    test('should register SyncQueue as singleton', () async {
      await setupLocator();

      final queue1 = locator<SyncQueue>();
      final queue2 = locator<SyncQueue>();

      expect(identical(queue1, queue2), true);
    });

    test('should register LoggerService as singleton', () async {
      await setupLocator();

      final logger1 = locator<LoggerService>();
      final logger2 = locator<LoggerService>();

      expect(identical(logger1, logger2), true);
    });

    test('should register RetryScheduler as singleton', () async {
      await setupLocator();

      final scheduler1 = locator<RetryScheduler>();
      final scheduler2 = locator<RetryScheduler>();

      expect(identical(scheduler1, scheduler2), true);
    });

    test('should register SyncScheduler as factory', () async {
      await setupLocator();

      final scheduler1 = locator<SyncScheduler>();
      final scheduler2 = locator<SyncScheduler>();

      expect(identical(scheduler1, scheduler2), false);
    });

    test('should register HiveTaskDataSource as singleton', () async {
      await setupLocator();

      final hive1 = locator<HiveTaskDataSource>();
      final hive2 = locator<HiveTaskDataSource>();

      expect(identical(hive1, hive2), true);
    });

    test('should register TaskRepository as singleton', () async {
      await setupLocator();

      final repository1 = locator<TaskRepository>();
      final repository2 = locator<TaskRepository>();

      expect(identical(repository1, repository2), true);
    });

    test('should register SyncService as singleton', () async {
      await setupLocator();

      final service1 = locator<SyncService>();
      final service2 = locator<SyncService>();

      expect(identical(service1, service2), true);
    });
  });
}

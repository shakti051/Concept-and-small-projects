import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/data/local/hive_task_datasource.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/respository/task_repository.dart';
import 'package:task_app_firebase/services/locator.dart';
import 'package:task_app_firebase/services/sync_service.dart';

void main() {
  final locator = GetIt.instance;

  late Directory testDirectory;

  const testEmail = '[test@example.com](mailto:test@example.com)';

  setUpAll(() async {
    // ------------------------------------------------------------
    // Create isolated Hive directory for tests
    // ------------------------------------------------------------

    testDirectory = await Directory.systemTemp.createTemp(
      'task_app_locator_test_',
    );

    Hive.init(testDirectory.path);

    // ------------------------------------------------------------
    // Register Hive adapters
    // ------------------------------------------------------------

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SyncStatusAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }
  });

  setUp(() async {
    // ------------------------------------------------------------
    // Clear GetIt before every test
    // ------------------------------------------------------------

    await locator.reset();

    // ------------------------------------------------------------
    // Close user Hive box if it is already open
    // ------------------------------------------------------------

    final boxName = HiveBoxes.tasks(testEmail);

    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<Task>(boxName).close();
    }
  });

  tearDown(() async {
    // ------------------------------------------------------------
    // Reset GetIt
    // ------------------------------------------------------------

    await locator.reset();

    // ------------------------------------------------------------
    // Close user Hive box
    // ------------------------------------------------------------

    final boxName = HiveBoxes.tasks(testEmail);

    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<Task>(boxName).close();
    }
  });

  tearDownAll(() async {
    // ------------------------------------------------------------
    // Delete temporary Hive directory
    // ------------------------------------------------------------

    if (testDirectory.existsSync()) {
      await testDirectory.delete(recursive: true);
    }
  });

  // ============================================================
  // setupUserLocator()
  // ============================================================

  group('setupUserLocator()', () {
    test('should register user-specific dependencies', () async {
      await setupUserLocator(testEmail);

      expect(locator.isRegistered<HiveTaskDataSource>(), isTrue);

      expect(locator.isRegistered<TaskRepository>(), isTrue);

      expect(locator.isRegistered<SyncService>(), isTrue);
    });

    test('should resolve HiveTaskDataSource', () async {
      await setupUserLocator(testEmail);

      final dataSource = locator<HiveTaskDataSource>();

      expect(dataSource, isA<HiveTaskDataSource>());
    });

    test('should resolve TaskRepository', () async {
      await setupUserLocator(testEmail);

      final repository = locator<TaskRepository>();

      expect(repository, isA<TaskRepository>());
    });

    test('should resolve SyncService', () async {
      await setupUserLocator(testEmail);

      final syncService = locator<SyncService>();

      expect(syncService, isA<SyncService>());
    });

    test('should register HiveTaskDataSource as singleton', () async {
      await setupUserLocator(testEmail);

      final dataSource1 = locator<HiveTaskDataSource>();
      final dataSource2 = locator<HiveTaskDataSource>();

      expect(identical(dataSource1, dataSource2), isTrue);
    });

    test('should register TaskRepository as singleton', () async {
      await setupUserLocator(testEmail);

      final repository1 = locator<TaskRepository>();
      final repository2 = locator<TaskRepository>();

      expect(identical(repository1, repository2), isTrue);
    });

    test('should register SyncService as singleton', () async {
      await setupUserLocator(testEmail);

      final service1 = locator<SyncService>();
      final service2 = locator<SyncService>();

      expect(identical(service1, service2), isTrue);
    });

    test('should create Hive box for the logged-in user', () async {
      await setupUserLocator(testEmail);

      final boxName = HiveBoxes.tasks(testEmail.toLowerCase());

      expect(Hive.isBoxOpen(boxName), isTrue);
    });

    test('should normalize email before creating dependencies', () async {
      const email = '  TEST@EXAMPLE.COM  ';

      await setupUserLocator(email);

      final normalizedBoxName = HiveBoxes.tasks('test@example.com');

      expect(Hive.isBoxOpen(normalizedBoxName), isTrue);
    });

    test(
      'should replace old user dependencies when another user logs in',
      () async {
        const firstEmail = 'first@example.com';
        const secondEmail = 'second@example.com';

        await setupUserLocator(firstEmail);

        final firstRepository = locator<TaskRepository>();
        final firstDataSource = locator<HiveTaskDataSource>();

        await setupUserLocator(secondEmail);

        final secondRepository = locator<TaskRepository>();
        final secondDataSource = locator<HiveTaskDataSource>();

        expect(identical(firstRepository, secondRepository), isFalse);

        expect(identical(firstDataSource, secondDataSource), isFalse);

        expect(locator.isRegistered<TaskRepository>(), isTrue);

        expect(locator.isRegistered<HiveTaskDataSource>(), isTrue);

        expect(locator.isRegistered<SyncService>(), isTrue);
      },
    );
  });
}

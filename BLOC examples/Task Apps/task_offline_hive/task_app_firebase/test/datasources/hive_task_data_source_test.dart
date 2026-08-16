import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/data/local/hive_task_datasource.dart';
import 'package:task_app_firebase/models/task.dart';

late Directory testDirectory;

void main() {
  late HiveTaskDataSource dataSource;
  late Box<Task> box;

  const testEmail = 'test@example.com';

  final boxName = HiveBoxes.tasks(testEmail);

  // ============================================================
  // Hive initialization
  // ============================================================

  setUpAll(() async {
    testDirectory = await Directory.systemTemp.createTemp(
      'task_app_hive_test_',
    );

    Hive.init(testDirectory.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SyncStatusAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Task>(boxName);
    }

    box = Hive.box<Task>(boxName);
  });

  // ============================================================
  // Test Task factory
  // ============================================================

  Task createTask({
    required String id,
    required String title,
    String ownerId = 'test-owner-1',
    DateTime? lastModified,
    SyncStatus syncStatus = SyncStatus.synced,
  }) {
    return Task(
      id: id,
      title: title,
      ownerId: ownerId,
      description: 'Description $id',
      date: '2026-07-30',
      isDone: false,
      isDeleted: false,
      isFavorite: false,
      syncStatus: syncStatus,
      lastModified: lastModified ?? DateTime.now().toUtc(),
    );
  }

  // ============================================================
  // Setup / teardown
  // ============================================================

  setUp(() async {
    await box.clear();

    dataSource = HiveTaskDataSource(testEmail);
  });

  tearDown(() async {
    await box.clear();
  });

  tearDownAll(() async {
    if (box.isOpen) {
      await box.close();
    }

    if (testDirectory.existsSync()) {
      await testDirectory.delete(recursive: true);
    }
  });

  // ============================================================
  // Tests
  // ============================================================

  group('HiveTaskDataSource', () {
    test('addTask should save task to Hive', () async {
      final task = createTask(
        id: '1',
        title: 'Test Task',
      );

      await dataSource.addTask(task);

      expect(box.containsKey('1'), isTrue);
      expect(box.get('1'), equals(task));
    });

    test('updateTask should replace existing task', () async {
      final oldTask = createTask(
        id: '1',
        title: 'Old Title',
      );

      final updatedTask = createTask(
        id: '1',
        title: 'Updated Title',
      );

      await dataSource.addTask(oldTask);
      await dataSource.updateTask(updatedTask);

      expect(box.length, 1);
      expect(box.get('1'), equals(updatedTask));
    });

    test('deleteTask should remove task from Hive', () async {
      final task = createTask(
        id: '1',
        title: 'Delete Me',
      );

      await dataSource.addTask(task);

      expect(box.containsKey('1'), isTrue);

      await dataSource.deleteTask('1');

      expect(box.containsKey('1'), isFalse);
      expect(box.get('1'), isNull);
    });

    test('getAllTasks should return all tasks', () async {
      final task1 = createTask(
        id: '1',
        title: 'Task 1',
      );

      final task2 = createTask(
        id: '2',
        title: 'Task 2',
      );

      await dataSource.addTask(task1);
      await dataSource.addTask(task2);

      final result = dataSource.getAllTasks();

      expect(result, hasLength(2));
      expect(result, contains(task1));
      expect(result, contains(task2));
    });

    test('getAllTasks should return empty list when Hive is empty', () {
      final result = dataSource.getAllTasks();

      expect(result, isEmpty);
    });

    test('getAllTasks should sort tasks by lastModified', () async {
      final olderTask = createTask(
        id: '1',
        title: 'Older',
        lastModified: DateTime.utc(2026, 7, 28),
      );

      final newerTask = createTask(
        id: '2',
        title: 'Newer',
        lastModified: DateTime.utc(2026, 7, 30),
      );

      final middleTask = createTask(
        id: '3',
        title: 'Middle',
        lastModified: DateTime.utc(2026, 7, 29),
      );

      await dataSource.addTask(olderTask);
      await dataSource.addTask(newerTask);
      await dataSource.addTask(middleTask);

      final result = dataSource.getAllTasks();

      expect(result, hasLength(3));

      expect(result[0].id, '2');
      expect(result[1].id, '3');
      expect(result[2].id, '1');
    });

    test('upsertAll should insert multiple tasks', () async {
      final tasks = [
        createTask(id: '1', title: 'Task 1'),
        createTask(id: '2', title: 'Task 2'),
        createTask(id: '3', title: 'Task 3'),
      ];

      await dataSource.upsertAll(tasks);

      expect(box.length, 3);
      expect(box.get('1'), equals(tasks[0]));
      expect(box.get('2'), equals(tasks[1]));
      expect(box.get('3'), equals(tasks[2]));
    });

    test(
      'upsertAll should update existing tasks and insert new tasks',
      () async {
        final oldTask = createTask(
          id: '1',
          title: 'Old Task',
        );

        await dataSource.addTask(oldTask);

        final updatedTask = createTask(
          id: '1',
          title: 'Updated Task',
        );

        final newTask = createTask(
          id: '2',
          title: 'New Task',
        );

        await dataSource.upsertAll([
          updatedTask,
          newTask,
        ]);

        expect(box.length, 2);
        expect(box.get('1'), equals(updatedTask));
        expect(box.get('2'), equals(newTask));
      },
    );

    test('createAll should insert all tasks', () async {
      final tasks = [
        createTask(id: '1', title: 'Task 1'),
        createTask(id: '2', title: 'Task 2'),
      ];

      await dataSource.createAll(tasks);

      expect(box.length, 2);
      expect(box.get('1'), equals(tasks[0]));
      expect(box.get('2'), equals(tasks[1]));
    });

    test('updateAll should update all tasks', () async {
      final originalTasks = [
        createTask(id: '1', title: 'Task 1'),
        createTask(id: '2', title: 'Task 2'),
      ];

      await dataSource.createAll(originalTasks);

      final updatedTasks = [
        createTask(id: '1', title: 'Updated Task 1'),
        createTask(id: '2', title: 'Updated Task 2'),
      ];

      await dataSource.updateAll(updatedTasks);

      expect(box.length, 2);
      expect(box.get('1'), equals(updatedTasks[0]));
      expect(box.get('2'), equals(updatedTasks[1]));
    });

    test('deleteAll should delete all specified tasks', () async {
      final tasks = [
        createTask(id: '1', title: 'Task 1'),
        createTask(id: '2', title: 'Task 2'),
        createTask(id: '3', title: 'Task 3'),
      ];

      await dataSource.createAll(tasks);

      await dataSource.deleteAll([
        tasks[0],
        tasks[2],
      ]);

      expect(box.length, 1);
      expect(box.containsKey('1'), isFalse);
      expect(box.containsKey('2'), isTrue);
      expect(box.containsKey('3'), isFalse);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app_firebase/data/local/hive_task_datasource.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/respository/task_repository.dart';

class MockHiveTaskDataSource extends Mock implements HiveTaskDataSource {}


void main() {
  late MockHiveTaskDataSource mockHive;
  late TaskRepository repository;

  late Task task;
  late Task task2;

  setUp(() {
    mockHive = MockHiveTaskDataSource();
    repository = TaskRepository(mockHive);

    task = Task(
      title: 'Test Task',
      description: 'Test Description',
      id: '1',
      date: '2026-07-30',
      isDone: false,
      isDeleted: false,
      isFavorite: false,
      syncStatus: SyncStatus.synced,
      lastModified: DateTime(2026, 7, 30),
    );

    task2 = Task(
      title: 'Second Task',
      description: 'Second Description',
      id: '2',
      date: '2026-07-30',
      isDone: true,
      isDeleted: false,
      isFavorite: true,
      syncStatus: SyncStatus.synced,
      lastModified: DateTime(2026, 7, 30),
    );
  });

  group('TaskRepository', () {
    // ------------------------------------------------------------
    // CREATE
    // ------------------------------------------------------------

    test('create() should call hive.addTask()', () async {
      when(() => mockHive.addTask(task)).thenAnswer((_) async {});

      await repository.create(task);

      verify(() => mockHive.addTask(task)).called(1);
    });

    // ------------------------------------------------------------
    // UPDATE
    // ------------------------------------------------------------

    test('update() should call hive.updateTask()', () async {
      when(() => mockHive.updateTask(task)).thenAnswer((_) async {});

      await repository.update(task);

      verify(() => mockHive.updateTask(task)).called(1);
    });

    // ------------------------------------------------------------
    // DELETE
    // ------------------------------------------------------------

    test('delete() should call hive.deleteTask() with task id', () async {
      when(() => mockHive.deleteTask(task.id)).thenAnswer((_) async {});

      await repository.delete(task);

      verify(() => mockHive.deleteTask(task.id)).called(1);
    });

    // ------------------------------------------------------------
    // GET ALL
    // ------------------------------------------------------------

    test('getAll() should return tasks from hive', () async {
      final tasks = [task, task2];

      when(() => mockHive.getAllTasks()).thenReturn(tasks);

      final result = await repository.getAll();

      expect(result, tasks);

      verify(() => mockHive.getAllTasks()).called(1);
    });

    test('getAll() should return empty list when hive is empty', () async {
      when(() => mockHive.getAllTasks()).thenReturn([]);

      final result = await repository.getAll();

      expect(result, isEmpty);

      verify(() => mockHive.getAllTasks()).called(1);
    });

    // ------------------------------------------------------------
    // UPSERT ALL
    // ------------------------------------------------------------

    test('upsertAll() should call hive.upsertAll()', () async {
      final tasks = [task, task2];

      when(() => mockHive.upsertAll(tasks)).thenAnswer((_) async {});

      await repository.upsertAll(tasks);

      verify(() => mockHive.upsertAll(tasks)).called(1);
    });

    test('upsertAll() should work with empty list', () async {
      final tasks = <Task>[];

      when(() => mockHive.upsertAll(tasks)).thenAnswer((_) async {});

      await repository.upsertAll(tasks);

      verify(() => mockHive.upsertAll(tasks)).called(1);
    });

    // ------------------------------------------------------------
    // CREATE ALL
    // ------------------------------------------------------------

    test('createAll() should call hive.createAll()', () async {
      final tasks = [task, task2];

      when(() => mockHive.createAll(tasks)).thenAnswer((_) async {});

      await repository.createAll(tasks);

      verify(() => mockHive.createAll(tasks)).called(1);
    });

    test('createAll() should work with empty list', () async {
      final tasks = <Task>[];

      when(() => mockHive.createAll(tasks)).thenAnswer((_) async {});

      await repository.createAll(tasks);

      verify(() => mockHive.createAll(tasks)).called(1);
    });

    // ------------------------------------------------------------
    // UPDATE ALL
    // ------------------------------------------------------------

    test('updateAll() should call hive.updateAll()', () async {
      final tasks = [task, task2];

      when(() => mockHive.updateAll(tasks)).thenAnswer((_) async {});

      await repository.updateAll(tasks);

      verify(() => mockHive.updateAll(tasks)).called(1);
    });

    test('updateAll() should work with empty list', () async {
      final tasks = <Task>[];

      when(() => mockHive.updateAll(tasks)).thenAnswer((_) async {});

      await repository.updateAll(tasks);

      verify(() => mockHive.updateAll(tasks)).called(1);
    });

    // ------------------------------------------------------------
    // DELETE ALL
    // ------------------------------------------------------------

    test('deleteAll() should call hive.deleteAll()', () async {
      final tasks = [task, task2];

      when(() => mockHive.deleteAll(tasks)).thenAnswer((_) async {});

      await repository.deleteAll(tasks);

      verify(() => mockHive.deleteAll(tasks)).called(1);
    });

    test('deleteAll() should work with empty list', () async {
      final tasks = <Task>[];

      when(() => mockHive.deleteAll(tasks)).thenAnswer((_) async {});

      await repository.deleteAll(tasks);

      verify(() => mockHive.deleteAll(tasks)).called(1);
    });

    // ------------------------------------------------------------
    // ERROR PROPAGATION
    // ------------------------------------------------------------

    test('create() should propagate hive exception', () async {
      final exception = Exception('Database error');

      when(() => mockHive.addTask(task)).thenThrow(exception);

      expect(
        () => repository.create(task),
        throwsA(exception),
      );

      verify(() => mockHive.addTask(task)).called(1);
    });

    test('update() should propagate hive exception', () async {
      final exception = Exception('Database error');

      when(() => mockHive.updateTask(task)).thenThrow(exception);

      expect(
        () => repository.update(task),
        throwsA(exception),
      );

      verify(() => mockHive.updateTask(task)).called(1);
    });

    test('delete() should propagate hive exception', () async {
      final exception = Exception('Database error');

      when(() => mockHive.deleteTask(task.id)).thenThrow(exception);

      expect(
        () => repository.delete(task),
        throwsA(exception),
      );

      verify(() => mockHive.deleteTask(task.id)).called(1);
    });

    test('upsertAll() should propagate hive exception', () async {
      final tasks = [task, task2];
      final exception = Exception('Database error');

      when(() => mockHive.upsertAll(tasks)).thenThrow(exception);

      expect(
        () => repository.upsertAll(tasks),
        throwsA(exception),
      );

      verify(() => mockHive.upsertAll(tasks)).called(1);
    });

    test('createAll() should propagate hive exception', () async {
      final tasks = [task, task2];
      final exception = Exception('Database error');

      when(() => mockHive.createAll(tasks)).thenThrow(exception);

      expect(
        () => repository.createAll(tasks),
        throwsA(exception),
      );

      verify(() => mockHive.createAll(tasks)).called(1);
    });

    test('updateAll() should propagate hive exception', () async {
      final tasks = [task, task2];
      final exception = Exception('Database error');

      when(() => mockHive.updateAll(tasks)).thenThrow(exception);

      expect(
        () => repository.updateAll(tasks),
        throwsA(exception),
      );

      verify(() => mockHive.updateAll(tasks)).called(1);
    });

    test('deleteAll() should propagate hive exception', () async {
      final tasks = [task, task2];
      final exception = Exception('Database error');

      when(() => mockHive.deleteAll(tasks)).thenThrow(exception);

      expect(
        () => repository.deleteAll(tasks),
        throwsA(exception),
      );

      verify(() => mockHive.deleteAll(tasks)).called(1);
    });
  });
}
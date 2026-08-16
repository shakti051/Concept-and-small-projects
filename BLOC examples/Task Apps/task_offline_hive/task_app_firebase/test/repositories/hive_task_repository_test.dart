import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/respository/task_repository.dart';
import 'package:task_app_firebase/data/local/hive_task_datasource.dart';
import 'package:task_app_firebase/core/exceptions/app_exceptions.dart';

class MockHiveTaskDataSource extends Mock implements HiveTaskDataSource {}

class FakeTask extends Fake implements Task {}

void main() {
  late MockHiveTaskDataSource hive;
  late TaskRepository repository;

  late Task task1;
  late Task task2;
  late List<Task> tasks;

  Task createTask({
    String id = 'task-1',
    String title = 'Task 1',
    bool isDone = false,
    bool isDeleted = false,
    bool isFavorite = false,
    SyncStatus syncStatus = SyncStatus.synced,
    DateTime? lastModified,
  }) {
    return Task(
      id: id,
      title: title,
      description: 'Test Description',
      date: '2026-07-30',
      isDone: isDone,
      isDeleted: isDeleted,
      isFavorite: isFavorite,
      syncStatus: syncStatus,
      lastModified: lastModified ?? DateTime(2026, 7, 30, 10, 0),
      ownerId: 'test-owner-1',
    );
  }

  setUpAll(() {
    registerFallbackValue(FakeTask());
  });

  setUp(() {
    hive = MockHiveTaskDataSource();
    repository = TaskRepository(hive);

    task1 = createTask(id: 'task-1', title: 'Task 1');

    task2 = createTask(
      id: 'task-2',
      title: 'Task 2',
      lastModified: DateTime(2026, 7, 30, 11, 0),
    );

    tasks = [task1, task2];
  });

  // ============================================================
  // CREATE
  // ============================================================

  test('create delegates to hive.addTask', () async {
    when(() => hive.addTask(any())).thenAnswer((_) async {});

    await repository.create(task1);

    verify(() => hive.addTask(task1)).called(1);
  });

  // ============================================================
  // CREATE - EXCEPTION
  // ============================================================

  test('create propagates LocalDatabaseException', () async {
    when(() => hive.addTask(any())).thenThrow(const LocalDatabaseException());

    expect(
      () => repository.create(task1),
      throwsA(isA<LocalDatabaseException>()),
    );

    verify(() => hive.addTask(task1)).called(1);
  });

  // ============================================================
  // UPDATE
  // ============================================================

  test('update delegates to hive.updateTask', () async {
    when(() => hive.updateTask(any())).thenAnswer((_) async {});

    await repository.update(task1);

    verify(() => hive.updateTask(task1)).called(1);
  });

  // ============================================================
  // UPDATE - EXCEPTION
  // ============================================================

  test('update propagates LocalDatabaseException', () async {
    when(
      () => hive.updateTask(any()),
    ).thenThrow(const LocalDatabaseException());

    expect(
      () => repository.update(task1),
      throwsA(isA<LocalDatabaseException>()),
    );

    verify(() => hive.updateTask(task1)).called(1);
  });

  // ============================================================
  // DELETE
  // ============================================================

  test('delete delegates to hive.deleteTask with task id', () async {
    when(() => hive.deleteTask(any())).thenAnswer((_) async {});

    await repository.delete(task1);

    verify(() => hive.deleteTask(task1.id)).called(1);
  });

  // ============================================================
  // DELETE - EXCEPTION
  // ============================================================

  test('delete propagates LocalDatabaseException', () async {
    when(
      () => hive.deleteTask(any()),
    ).thenThrow(const LocalDatabaseException());

    expect(
      () => repository.delete(task1),
      throwsA(isA<LocalDatabaseException>()),
    );

    verify(() => hive.deleteTask(task1.id)).called(1);
  });

  // ============================================================
  // GET ALL
  // ============================================================

  test('getAll delegates to hive.getAllTasks', () async {
    when(() => hive.getAllTasks()).thenReturn(tasks);

    final result = await repository.getAll();

    expect(result, tasks);

    verify(() => hive.getAllTasks()).called(1);
  });

  // ============================================================
  // GET ALL - EMPTY
  // ============================================================

  test('getAll returns empty list when hive is empty', () async {
    when(() => hive.getAllTasks()).thenReturn([]);

    final result = await repository.getAll();

    expect(result, isEmpty);

    verify(() => hive.getAllTasks()).called(1);
  });

  // ============================================================
  // UPSERT ALL
  // ============================================================

  test('upsertAll delegates to hive.upsertAll', () async {
    when(() => hive.upsertAll(any())).thenAnswer((_) async {});

    await repository.upsertAll(tasks);

    verify(() => hive.upsertAll(tasks)).called(1);
  });

  // ============================================================
  // UPSERT ALL - EMPTY
  // ============================================================

  test('upsertAll accepts empty list', () async {
    when(() => hive.upsertAll(any())).thenAnswer((_) async {});

    await repository.upsertAll([]);

    verify(() => hive.upsertAll([])).called(1);
  });

  // ============================================================
  // CREATE ALL
  // ============================================================

  test('createAll delegates to hive.createAll', () async {
    when(() => hive.createAll(any())).thenAnswer((_) async {});

    await repository.createAll(tasks);

    verify(() => hive.createAll(tasks)).called(1);
  });

  // ============================================================
  // CREATE ALL - EMPTY
  // ============================================================

  test('createAll accepts empty list', () async {
    when(() => hive.createAll(any())).thenAnswer((_) async {});

    await repository.createAll([]);

    verify(() => hive.createAll([])).called(1);
  });

  // ============================================================
  // UPDATE ALL
  // ============================================================

  test('updateAll delegates to hive.updateAll', () async {
    when(() => hive.updateAll(any())).thenAnswer((_) async {});

    await repository.updateAll(tasks);

    verify(() => hive.updateAll(tasks)).called(1);
  });

  // ============================================================
  // UPDATE ALL - EMPTY
  // ============================================================

  test('updateAll accepts empty list', () async {
    when(() => hive.updateAll(any())).thenAnswer((_) async {});

    await repository.updateAll([]);

    verify(() => hive.updateAll([])).called(1);
  });

  // ============================================================
  // DELETE ALL
  // ============================================================

  test('deleteAll delegates to hive.deleteAll', () async {
    when(() => hive.deleteAll(any())).thenAnswer((_) async {});

    await repository.deleteAll(tasks);

    verify(() => hive.deleteAll(tasks)).called(1);
  });

  // ============================================================
  // DELETE ALL - EMPTY
  // ============================================================

  test('deleteAll accepts empty list', () async {
    when(() => hive.deleteAll(any())).thenAnswer((_) async {});

    await repository.deleteAll([]);

    verify(() => hive.deleteAll([])).called(1);
  });
}

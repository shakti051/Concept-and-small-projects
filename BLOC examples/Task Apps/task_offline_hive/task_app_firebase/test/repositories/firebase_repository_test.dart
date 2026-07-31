import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/respository/firestore_repository.dart';


void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();

    // Inject fake Firestore.
    FirestoreRepository.firestore = fakeFirestore;

    // Avoid GetStorage completely during unit tests.
    FirestoreRepository.testUserEmail = 'test@example.com';
  });

  tearDown(() {
    FirestoreRepository.testUserEmail = null;
  });

  Task createTask({String id = 'task-1', String title = 'Test Task'}) {
    return Task(
      id: id,
      title: title,
      description: 'Test Description',
      date: '2026-07-30',
      isDone: false,
      isDeleted: false,
      isFavorite: false,
      syncStatus: SyncStatus.synced,
      lastModified: DateTime.now().toUtc(),
    );
  }

  // ============================================================
  // CREATE
  // ============================================================

  test('create() should create task in Firestore', () async {
    final task = createTask();

    await FirestoreRepository.create(task: task);

    final doc = await fakeFirestore
        .collection('test@example.com')
        .doc(task.id)
        .get();

    expect(doc.exists, isTrue);
    expect(doc.data()?['title'], 'Test Task');
    expect(doc.data()?['description'], 'Test Description');
    expect(doc.data()?['id'], 'task-1');
    expect(doc.data()?['isDone'], false);
    expect(doc.data()?['isDeleted'], false);
    expect(doc.data()?['isFavorite'], false);
  });

  // ============================================================
  // GET
  // ============================================================

  test('get() should return all tasks', () async {
    final task1 = createTask(id: 'task-1', title: 'Task 1');

    final task2 = createTask(id: 'task-2', title: 'Task 2');

    await FirestoreRepository.create(task: task1);
    await FirestoreRepository.create(task: task2);

    final tasks = await FirestoreRepository.get();

    expect(tasks.length, 2);

    expect(tasks.any((task) => task.id == 'task-1'), isTrue);

    expect(tasks.any((task) => task.id == 'task-2'), isTrue);
  });

  test('get() should return empty list when collection is empty', () async {
    final tasks = await FirestoreRepository.get();

    expect(tasks, isEmpty);
  });

  // ============================================================
  // UPDATE
  // ============================================================

  test('update() should update existing task', () async {
    final task = createTask();

    await FirestoreRepository.create(task: task);

    final updatedTask = task.copyWith(
      title: 'Updated Task',
      isDone: true,
      isFavorite: true,
      lastModified: DateTime.now().toUtc(),
    );

    await FirestoreRepository.update(updatedTask);

    final doc = await fakeFirestore
        .collection('test@example.com')
        .doc(task.id)
        .get();

    expect(doc.exists, isTrue);
    expect(doc.data()?['title'], 'Updated Task');
    expect(doc.data()?['isDone'], true);
    expect(doc.data()?['isFavorite'], true);
  });

  // ============================================================
  // DELETE
  // ============================================================

  test('delete() should delete task', () async {
    final task = createTask();

    await FirestoreRepository.create(task: task);

    var doc = await fakeFirestore
        .collection('test@example.com')
        .doc(task.id)
        .get();

    expect(doc.exists, isTrue);

    await FirestoreRepository.delete(task: task);

    doc = await fakeFirestore.collection('test@example.com').doc(task.id).get();

    expect(doc.exists, isFalse);
  });

  // ============================================================
  // DELETE ALL
  // ============================================================

  test('deleteAllRemovedTask() should delete all supplied tasks', () async {
    final task1 = createTask(id: 'task-1');
    final task2 = createTask(id: 'task-2');
    final task3 = createTask(id: 'task-3');

    await FirestoreRepository.create(task: task1);
    await FirestoreRepository.create(task: task2);
    await FirestoreRepository.create(task: task3);

    var snapshot = await fakeFirestore.collection('test@example.com').get();

    expect(snapshot.docs.length, 3);

    await FirestoreRepository.deleteAllRemovedTask(
      taskList: [task1, task2, task3],
    );

    snapshot = await fakeFirestore.collection('test@example.com').get();

    expect(snapshot.docs, isEmpty);
  });

  test(
    'deleteAllRemovedTask() should do nothing for empty task list',
    () async {
      final task = createTask();

      await FirestoreRepository.create(task: task);

      await FirestoreRepository.deleteAllRemovedTask(taskList: []);

      final snapshot = await fakeFirestore.collection('test@example.com').get();

      expect(snapshot.docs.length, 1);
    },
  );

  test('deleteAllRemovedTask() should not delete tasks not supplied', () async {
    final task1 = createTask(id: 'task-1');
    final task2 = createTask(id: 'task-2');
    final task3 = createTask(id: 'task-3');

    await FirestoreRepository.create(task: task1);
    await FirestoreRepository.create(task: task2);
    await FirestoreRepository.create(task: task3);

    await FirestoreRepository.deleteAllRemovedTask(taskList: [task1]);

    final snapshot = await fakeFirestore.collection('test@example.com').get();

    expect(snapshot.docs.length, 2);

    expect(snapshot.docs.any((doc) => doc.id == 'task-2'), isTrue);

    expect(snapshot.docs.any((doc) => doc.id == 'task-3'), isTrue);
  });

  // ============================================================
  // TASK MODEL / FIRESTORE MAPPING
  // ============================================================

  test('toFirestoreMap() should not contain syncStatus', () {
    final task = createTask();

    final map = task.toFirestoreMap();

    expect(map.containsKey('syncStatus'), isFalse);
    expect(map['title'], task.title);
    expect(map['description'], task.description);
    expect(map['id'], task.id);
    expect(map['isDone'], task.isDone);
    expect(map['isDeleted'], task.isDeleted);
    expect(map['isFavorite'], task.isFavorite);
    expect(map['lastModified'], isNotNull);
  });

  test('Task.fromMap() should restore Firestore data', () {
    final task = createTask();

    final restored = Task.fromMap(task.toFirestoreMap());

    expect(restored.id, task.id);
    expect(restored.title, task.title);
    expect(restored.description, task.description);
    expect(restored.date, task.date);
    expect(restored.isDone, task.isDone);
    expect(restored.isDeleted, task.isDeleted);
    expect(restored.isFavorite, task.isFavorite);
    expect(restored.syncStatus, SyncStatus.synced);
  });

  // ============================================================
  // NO LOGGED-IN USER
  // ============================================================

  test('create() should throw when user email is not available', () async {
    FirestoreRepository.testUserEmail = null;

    final task = createTask();

    expect(() => FirestoreRepository.create(task: task), throwsException);
  });

  test('get() should throw when user email is not available', () async {
    FirestoreRepository.testUserEmail = null;

    expect(() => FirestoreRepository.get(), throwsException);
  });

  test('update() should throw when user email is not available', () async {
    FirestoreRepository.testUserEmail = null;

    final task = createTask();

    expect(() => FirestoreRepository.update(task), throwsException);
  });

  test('delete() should throw when user email is not available', () async {
    FirestoreRepository.testUserEmail = null;

    final task = createTask();

    expect(() => FirestoreRepository.delete(task: task), throwsException);
  });
}

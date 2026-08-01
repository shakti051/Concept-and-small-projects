import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_app_firebase/core/exceptions/app_exceptions.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/respository/firestore_repository.dart';

void main() {
late FakeFirebaseFirestore fakeFirestore;

late Task task1;
late Task task2;

setUp(() async {
fakeFirestore = FakeFirebaseFirestore();


// Replace the real Firestore instance with fake Firestore.
FirestoreRepository.firestore = fakeFirestore;

// Avoid depending on real GetStorage during tests.
FirestoreRepository.testUserEmail = 'test@example.com';

task1 = Task(
  id: 'task-1',
  title: 'Task 1',
  description: 'Description 1',
  date: '2026-07-30',
  isDone: false,
  isDeleted: false,
  isFavorite: false,
  syncStatus: SyncStatus.synced,
  lastModified: DateTime(2026, 7, 30, 10, 0),
);

task2 = Task(
  id: 'task-2',
  title: 'Task 2',
  description: 'Description 2',
  date: '2026-07-30',
  isDone: true,
  isDeleted: false,
  isFavorite: true,
  syncStatus: SyncStatus.synced,
  lastModified: DateTime(2026, 7, 30, 11, 0),
);


});

tearDown(() {
FirestoreRepository.testUserEmail = null;
});

// ============================================================
// CREATE
// ============================================================

group('create()', () {
test('creates task in Firestore', () async {
await FirestoreRepository.create(task: task1);


  final document = await fakeFirestore
      .collection('test@example.com')
      .doc('task-1')
      .get();

  expect(document.exists, true);
});

test('stores correct task data', () async {
  await FirestoreRepository.create(task: task1);

  final document = await fakeFirestore
      .collection('test@example.com')
      .doc('task-1')
      .get();

  final data = document.data();

  expect(data, isNotNull);
  expect(data!['id'], 'task-1');
  expect(data['title'], 'Task 1');
  expect(data['description'], 'Description 1');
  expect(data['isDone'], false);
  expect(data['isDeleted'], false);
  expect(data['isFavorite'], false);
});


});

// ============================================================
// GET
// ============================================================

group('get()', () {
test('returns all tasks from Firestore', () async {
await FirestoreRepository.create(task: task1);
await FirestoreRepository.create(task: task2);


  final result = await FirestoreRepository.get();

  expect(result.length, 2);

  expect(
    result.any((task) => task.id == 'task-1'),
    true,
  );

  expect(
    result.any((task) => task.id == 'task-2'),
    true,
  );
});

test('returns empty list when collection is empty', () async {
  final result = await FirestoreRepository.get();

  expect(result, isEmpty);
});

test('returns correct task properties', () async {
  await FirestoreRepository.create(task: task1);

  final result = await FirestoreRepository.get();

  expect(result.length, 1);

  final task = result.first;

  expect(task.id, 'task-1');
  expect(task.title, 'Task 1');
  expect(task.description, 'Description 1');
  expect(task.isDone, false);
  expect(task.isDeleted, false);
  expect(task.isFavorite, false);
});


});

// ============================================================
// UPDATE
// ============================================================

group('update()', () {
test('updates existing task', () async {
await FirestoreRepository.create(task: task1);


  final updatedTask = task1.copyWith(
    title: 'Updated Task',
    description: 'Updated Description',
    isDone: true,
  );

  await FirestoreRepository.update(updatedTask);

  final document = await fakeFirestore
      .collection('test@example.com')
      .doc('task-1')
      .get();

  final data = document.data();

  expect(data!['title'], 'Updated Task');
  expect(data['description'], 'Updated Description');
  expect(data['isDone'], true);
});

test('does not create a second document when updating', () async {
  await FirestoreRepository.create(task: task1);

  final updatedTask = task1.copyWith(
    title: 'Updated Task',
  );

  await FirestoreRepository.update(updatedTask);

  final snapshot = await fakeFirestore
      .collection('test@example.com')
      .get();

  expect(snapshot.docs.length, 1);
});


});

// ============================================================
// DELETE
// ============================================================

group('delete()', () {
test('deletes task from Firestore', () async {
await FirestoreRepository.create(task: task1);


  await FirestoreRepository.delete(task: task1);

  final document = await fakeFirestore
      .collection('test@example.com')
      .doc('task-1')
      .get();

  expect(document.exists, false);
});

test('deleting one task does not delete another task', () async {
  await FirestoreRepository.create(task: task1);
  await FirestoreRepository.create(task: task2);

  await FirestoreRepository.delete(task: task1);

  final remaining = await fakeFirestore
      .collection('test@example.com')
      .get();

  expect(remaining.docs.length, 1);
  expect(remaining.docs.first.id, 'task-2');
});


});

// ============================================================
// DELETE ALL REMOVED TASKS
// ============================================================

group('deleteAllRemovedTask()', () {
test('deletes all supplied tasks using batch', () async {
await FirestoreRepository.create(task: task1);
await FirestoreRepository.create(task: task2);


  await FirestoreRepository.deleteAllRemovedTask(
    taskList: [task1, task2],
  );

  final snapshot = await fakeFirestore
      .collection('test@example.com')
      .get();

  expect(snapshot.docs, isEmpty);
});

test('deletes only supplied tasks', () async {
  final task3 = task1.copyWith(
    id: 'task-3',
    title: 'Task 3',
  );

  await FirestoreRepository.create(task: task1);
  await FirestoreRepository.create(task: task2);
  await FirestoreRepository.create(task: task3);

  await FirestoreRepository.deleteAllRemovedTask(
    taskList: [task1, task3],
  );

  final snapshot = await fakeFirestore
      .collection('test@example.com')
      .get();

  expect(snapshot.docs.length, 1);
  expect(snapshot.docs.first.id, 'task-2');
});

test('does nothing when task list is empty', () async {
  await FirestoreRepository.create(task: task1);

  await FirestoreRepository.deleteAllRemovedTask(
    taskList: [],
  );

  final snapshot = await fakeFirestore
      .collection('test@example.com')
      .get();

  expect(snapshot.docs.length, 1);
});

test('does nothing when task list is null', () async {
  await FirestoreRepository.create(task: task1);

  await FirestoreRepository.deleteAllRemovedTask();

  final snapshot = await fakeFirestore
      .collection('test@example.com')
      .get();

  expect(snapshot.docs.length, 1);
});


});

// ============================================================
// USER COLLECTION
// ============================================================

group('user collection', () {
test('uses testUserEmail when provided', () async {
FirestoreRepository.testUserEmail = '[another@example.com](mailto:another@example.com)';


  await FirestoreRepository.create(task: task1);

  final document = await fakeFirestore
      .collection('another@example.com')
      .doc('task-1')
      .get();

  expect(document.exists, true);
});

test('throws when no logged in user exists', () async {
  FirestoreRepository.testUserEmail = null;

  expect(
    () => FirestoreRepository.get(),
    throwsA(
      isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('No logged in user'),
      ),
    ),
  );
});


});
}

import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/extensions/task_sorting.dart';
import 'package:task_app_firebase/models/task.dart';

void main() {
  Task createTask({
    required String id,
    required String title,
    required DateTime lastModified,
  }) {
    return Task(
      id: id,
      title: title,
      description: 'Description',
      date: '2026-07-30',
      isDone: false,
      isDeleted: false,
      isFavorite: false,
      syncStatus: SyncStatus.synced,
      lastModified: lastModified,
    );
  }

  group('TaskSorting.sortByLastModified', () {
    test('should sort tasks by lastModified descending', () {
      final oldTask = createTask(
        id: '1',
        title: 'Old',
        lastModified: DateTime(2026, 7, 30, 10),
      );

      final newTask = createTask(
        id: '2',
        title: 'New',
        lastModified: DateTime(2026, 7, 30, 12),
      );

      final middleTask = createTask(
        id: '3',
        title: 'Middle',
        lastModified: DateTime(2026, 7, 30, 11),
      );

      final tasks = [
        oldTask,
        newTask,
        middleTask,
      ];

      tasks.sortByLastModified();

      expect(
        tasks.map((task) => task.id).toList(),
        ['2', '3', '1'],
      );
    });

    test('should keep already sorted tasks in descending order', () {
      final tasks = [
        createTask(
          id: '1',
          title: 'New',
          lastModified: DateTime(2026, 7, 30, 12),
        ),
        createTask(
          id: '2',
          title: 'Middle',
          lastModified: DateTime(2026, 7, 30, 11),
        ),
        createTask(
          id: '3',
          title: 'Old',
          lastModified: DateTime(2026, 7, 30, 10),
        ),
      ];

      tasks.sortByLastModified();

      expect(
        tasks.map((task) => task.id).toList(),
        ['1', '2', '3'],
      );
    });

    test('should handle a single task', () {
      final tasks = [
        createTask(
          id: '1',
          title: 'Task',
          lastModified: DateTime(2026, 7, 30, 10),
        ),
      ];

      tasks.sortByLastModified();

      expect(tasks.length, 1);
      expect(tasks.first.id, '1');
    });

    test('should handle an empty list', () {
      final tasks = <Task>[];

      tasks.sortByLastModified();

      expect(tasks, isEmpty);
    });

    test('should handle tasks with equal lastModified values', () {
      final date = DateTime(2026, 7, 30, 10);

      final tasks = [
        createTask(
          id: '1',
          title: 'Task 1',
          lastModified: date,
        ),
        createTask(
          id: '2',
          title: 'Task 2',
          lastModified: date,
        ),
      ];

      tasks.sortByLastModified();

      expect(tasks.length, 2);
      expect(
        tasks.map((task) => task.id).toList(),
        ['1', '2'],
      );
    });

    test('should modify the original list', () {
      final task1 = createTask(
        id: '1',
        title: 'Old',
        lastModified: DateTime(2026, 7, 30, 10),
      );

      final task2 = createTask(
        id: '2',
        title: 'New',
        lastModified: DateTime(2026, 7, 30, 12),
      );

      final tasks = [task1, task2];

      tasks.sortByLastModified();

      expect(tasks.first, task2);
      expect(tasks.last, task1);
    });
  });
}
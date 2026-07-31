import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/models/task.dart';

void main() {
  
  group('SyncStatus', () {
    test('should contain all expected sync statuses', () {
      expect(SyncStatus.values, [
        SyncStatus.synced,
        SyncStatus.pendingCreate,
        SyncStatus.pendingUpdate,
        SyncStatus.pendingHardDelete,
      ]);
    });
  });

  group('Task', () {
    final lastModified = DateTime.utc(2026, 7, 30, 10, 30);

    Task createTask() {
      return Task(
        title: 'Test Task',
        description: 'Test Description',
        id: 'task-1',
        date: '2026-07-30',
        isDone: false,
        isDeleted: false,
        isFavorite: false,
        syncStatus: SyncStatus.synced,
        lastModified: lastModified,
      );
    }

    test('should create Task with required values', () {
      final task = createTask();

      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.id, 'task-1');
      expect(task.date, '2026-07-30');
      expect(task.isDone, false);
      expect(task.isDeleted, false);
      expect(task.isFavorite, false);
      expect(task.syncStatus, SyncStatus.synced);
      expect(task.lastModified, lastModified);
    });

    test('should use default values when optional values are omitted', () {
      final task = Task(
        title: 'Test Task',
        description: 'Description',
        id: '1',
        date: '2026-07-30',
        lastModified: lastModified,
      );

      expect(task.isDone, false);
      expect(task.isDeleted, false);
      expect(task.isFavorite, false);
      expect(task.syncStatus, SyncStatus.synced);
    });

    group('copyWith', () {
      test('should copy task without changing values', () {
        final original = createTask();

        final copied = original.copyWith();

        expect(copied, equals(original));
      });

      test('should update title', () {
        final original = createTask();

        final copied = original.copyWith(title: 'Updated Title');

        expect(copied.title, 'Updated Title');
        expect(copied.description, original.description);
        expect(copied.id, original.id);
      });

      test('should update description', () {
        final original = createTask();

        final copied = original.copyWith(description: 'Updated Description');

        expect(copied.description, 'Updated Description');
        expect(copied.title, original.title);
      });

      test('should update id', () {
        final original = createTask();

        final copied = original.copyWith(id: 'task-2');

        expect(copied.id, 'task-2');
      });

      test('should update date', () {
        final original = createTask();

        final copied = original.copyWith(date: '2026-08-01');

        expect(copied.date, '2026-08-01');
      });

      test('should update isDone', () {
        final original = createTask();

        final copied = original.copyWith(isDone: true);

        expect(copied.isDone, true);
        expect(copied.isDeleted, original.isDeleted);
        expect(copied.isFavorite, original.isFavorite);
      });

      test('should update isDeleted', () {
        final original = createTask();

        final copied = original.copyWith(isDeleted: true);

        expect(copied.isDeleted, true);
      });

      test('should update isFavorite', () {
        final original = createTask();

        final copied = original.copyWith(isFavorite: true);

        expect(copied.isFavorite, true);
      });

      test('should update syncStatus', () {
        final original = createTask();

        final copied = original.copyWith(syncStatus: SyncStatus.pendingCreate);

        expect(copied.syncStatus, SyncStatus.pendingCreate);
      });

      test('should update lastModified', () {
        final original = createTask();
        final newDate = DateTime.utc(2026, 8, 1, 12);

        final copied = original.copyWith(lastModified: newDate);

        expect(copied.lastModified, newDate);
      });

      test('should update multiple fields together', () {
        final original = createTask();

        final copied = original.copyWith(
          title: 'New Title',
          description: 'New Description',
          isDone: true,
          isFavorite: true,
          syncStatus: SyncStatus.pendingUpdate,
        );

        expect(copied.title, 'New Title');
        expect(copied.description, 'New Description');
        expect(copied.isDone, true);
        expect(copied.isFavorite, true);
        expect(copied.syncStatus, SyncStatus.pendingUpdate);

        // Unchanged fields
        expect(copied.id, original.id);
        expect(copied.date, original.date);
        expect(copied.isDeleted, original.isDeleted);
        expect(copied.lastModified, original.lastModified);
      });
    });

    group('toMap', () {
      test('should convert Task to local storage map', () {
        final task = createTask();

        final map = task.toMap();

        expect(map['title'], 'Test Task');
        expect(map['description'], 'Test Description');
        expect(map['id'], 'task-1');
        expect(map['date'], '2026-07-30');
        expect(map['isDone'], false);
        expect(map['isDeleted'], false);
        expect(map['isFavorite'], false);
        expect(map['syncStatus'], 'synced');
        expect(map['lastModified'], lastModified.toUtc().toIso8601String());
      });

      test('should store pendingCreate sync status correctly', () {
        final task = createTask().copyWith(
          syncStatus: SyncStatus.pendingCreate,
        );

        final map = task.toMap();

        expect(map['syncStatus'], 'pendingCreate');
      });

      test('should store pendingUpdate sync status correctly', () {
        final task = createTask().copyWith(
          syncStatus: SyncStatus.pendingUpdate,
        );

        final map = task.toMap();

        expect(map['syncStatus'], 'pendingUpdate');
      });

      test('should store pendingHardDelete sync status correctly', () {
        final task = createTask().copyWith(
          syncStatus: SyncStatus.pendingHardDelete,
        );

        final map = task.toMap();

        expect(map['syncStatus'], 'pendingHardDelete');
      });
    });

    group('toFirestoreMap', () {
      test('should convert Task to Firestore map', () {
        final task = createTask();

        final map = task.toFirestoreMap();

        expect(map['title'], 'Test Task');
        expect(map['description'], 'Test Description');
        expect(map['id'], 'task-1');
        expect(map['date'], '2026-07-30');
        expect(map['isDone'], false);
        expect(map['isDeleted'], false);
        expect(map['isFavorite'], false);
        expect(map['lastModified'], lastModified.toUtc().toIso8601String());
      });

      test('should not include syncStatus in Firestore map', () {
        final task = createTask().copyWith(
          syncStatus: SyncStatus.pendingCreate,
        );

        final map = task.toFirestoreMap();

        expect(map.containsKey('syncStatus'), false);
      });
    });

    group('fromMap', () {
      test('should create Task from complete map', () {
        final map = {
          'title': 'Test Task',
          'description': 'Test Description',
          'id': 'task-1',
          'date': '2026-07-30',
          'isDone': true,
          'isDeleted': false,
          'isFavorite': true,
          'syncStatus': 'pendingUpdate',
          'lastModified': lastModified.toIso8601String(),
        };

        final task = Task.fromMap(map);

        expect(task.title, 'Test Task');
        expect(task.description, 'Test Description');
        expect(task.id, 'task-1');
        expect(task.date, '2026-07-30');
        expect(task.isDone, true);
        expect(task.isDeleted, false);
        expect(task.isFavorite, true);
        expect(task.syncStatus, SyncStatus.pendingUpdate);
        expect(task.lastModified, lastModified);
      });

      test('should use empty strings for missing string values', () {
        final task = Task.fromMap({});

        expect(task.title, '');
        expect(task.description, '');
        expect(task.id, '');
        expect(task.date, '');
      });

      test('should use false for missing boolean values', () {
        final task = Task.fromMap({});

        expect(task.isDone, false);
        expect(task.isDeleted, false);
        expect(task.isFavorite, false);
      });

      test('should use synced when syncStatus is missing', () {
        final task = Task.fromMap({});

        expect(task.syncStatus, SyncStatus.synced);
      });

      test('should use synced when syncStatus is invalid', () {
        final task = Task.fromMap({'syncStatus': 'invalidStatus'});

        expect(task.syncStatus, SyncStatus.synced);
      });

      test('should correctly parse pendingCreate', () {
        final task = Task.fromMap({'syncStatus': 'pendingCreate'});

        expect(task.syncStatus, SyncStatus.pendingCreate);
      });

      test('should correctly parse pendingUpdate', () {
        final task = Task.fromMap({'syncStatus': 'pendingUpdate'});

        expect(task.syncStatus, SyncStatus.pendingUpdate);
      });

      test('should correctly parse pendingHardDelete', () {
        final task = Task.fromMap({'syncStatus': 'pendingHardDelete'});

        expect(task.syncStatus, SyncStatus.pendingHardDelete);
      });

      test('should use current UTC time when lastModified is missing', () {
        final before = DateTime.now().toUtc();

        final task = Task.fromMap({});

        final after = DateTime.now().toUtc();

        expect(
          task.lastModified.isAfter(before) ||
              task.lastModified.isAtSameMomentAs(before),
          true,
        );

        expect(
          task.lastModified.isBefore(after) ||
              task.lastModified.isAtSameMomentAs(after),
          true,
        );

        expect(task.lastModified.isUtc, true);
      });
    });

    group('Equatable', () {
      test('two tasks with the same values should be equal', () {
        final task1 = createTask();
        final task2 = createTask();

        expect(task1, equals(task2));
      });

      test('tasks with different titles should not be equal', () {
        final task1 = createTask();

        final task2 = task1.copyWith(title: 'Different Title');

        expect(task1, isNot(equals(task2)));
      });

      test('tasks with different ids should not be equal', () {
        final task1 = createTask();

        final task2 = task1.copyWith(id: 'task-2');

        expect(task1, isNot(equals(task2)));
      });

      test('tasks with different sync status should not be equal', () {
        final task1 = createTask();

        final task2 = task1.copyWith(syncStatus: SyncStatus.pendingUpdate);

        expect(task1, isNot(equals(task2)));
      });

      test('tasks with different lastModified should not be equal', () {
        final task1 = createTask();

        final task2 = task1.copyWith(lastModified: DateTime.utc(2026, 8, 1));

        expect(task1, isNot(equals(task2)));
      });
    });
  });
}

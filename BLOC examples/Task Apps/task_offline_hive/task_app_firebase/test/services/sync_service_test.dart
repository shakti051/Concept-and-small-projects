import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app_firebase/core/exceptions/app_exceptions.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/models/sync_report.dart';
import 'package:task_app_firebase/respository/task_repository.dart';
import 'package:task_app_firebase/services/sync_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class FakeTask extends Fake implements Task {}

void main() {
  late MockTaskRepository repository;
  late SyncService syncService;

  final baseDate = DateTime.utc(2026, 7, 30, 10);

  // ------------------------------------------------------------
  // TASK FACTORY
  // ------------------------------------------------------------

  Task createTask({
    String id = 'task-1',
    String title = 'Test Task',
    SyncStatus syncStatus = SyncStatus.synced,
    bool isDone = false,
    bool isDeleted = false,
    bool isFavorite = false,
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
      lastModified: lastModified ?? baseDate,
    );
  }

  // ------------------------------------------------------------
  // MOCKTAIL FALLBACKS
  // ------------------------------------------------------------

  setUpAll(() {
    registerFallbackValue(FakeTask());

    // Required when using any<List<Task>>() / captureAny()
    // with mocktail in sound null-safety mode.
    registerFallbackValue(<Task>[]);
  });

  // ------------------------------------------------------------
  // SETUP
  // ------------------------------------------------------------

  setUp(() {
    repository = MockTaskRepository();
    syncService = SyncService(repository);
  });

  // ============================================================
  // CREATE
  // ============================================================

  group('SyncService - CREATE', () {
    test('should upload pendingCreate task and mark it as synced', () async {
      final task = createTask(syncStatus: SyncStatus.pendingCreate);

      when(() => repository.createRemote(task)).thenAnswer((_) async {});

      when(() => repository.update(any<Task>())).thenAnswer((_) async {});

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([task]);

      expect(report.uploaded, 1);
      expect(report.failed, 0);
      expect(report.tasks.length, 1);
      expect(report.tasks.first.syncStatus, SyncStatus.synced);

      verify(() => repository.createRemote(task)).called(1);

      verify(
        () => repository.update(
          any<Task>(
            that: isA<Task>().having(
              (t) => t.syncStatus,
              'syncStatus',
              SyncStatus.synced,
            ),
          ),
        ),
      ).called(1);

      verify(() => repository.upsertAll(any<List<Task>>())).called(1);
    });

    test('should skip pendingCreate task when already deleted', () async {
      final task = createTask(
        syncStatus: SyncStatus.pendingCreate,
        isDeleted: true,
      );

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([task]);

      expect(report.uploaded, 0);
      expect(report.failed, 0);
      expect(report.tasks.length, 1);
      expect(report.tasks.first.id, task.id);

      verifyNever(() => repository.createRemote(any<Task>()));

      verifyNever(() => repository.update(any<Task>()));
    });

    test(
      'should increment failed when create throws NetworkException',
      () async {
        final task = createTask(syncStatus: SyncStatus.pendingCreate);

        when(
          () => repository.createRemote(task),
        ).thenThrow(const NetworkException());

        when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

        when(
          () => repository.upsertAll(any<List<Task>>()),
        ).thenAnswer((_) async {});

        final report = await syncService.sync([task]);

        expect(report.uploaded, 0);
        expect(report.failed, 1);
        expect(report.tasks.first.syncStatus, SyncStatus.pendingCreate);
      },
    );

    test(
      'should increment failed when create throws FirestoreWriteException',
      () async {
        final task = createTask(syncStatus: SyncStatus.pendingCreate);

        when(
          () => repository.createRemote(task),
        ).thenThrow(const FirestoreWriteException());

        when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

        when(
          () => repository.upsertAll(any<List<Task>>()),
        ).thenAnswer((_) async {});

        final report = await syncService.sync([task]);

        expect(report.uploaded, 0);
        expect(report.failed, 1);
        expect(report.tasks.first.syncStatus, SyncStatus.pendingCreate);
      },
    );

    test('should rethrow AuthenticationException during create', () async {
      final task = createTask(syncStatus: SyncStatus.pendingCreate);

      when(
        () => repository.createRemote(task),
      ).thenThrow(const AuthenticationException());

      expect(
        () => syncService.sync([task]),
        throwsA(isA<AuthenticationException>()),
      );
    });
  });

  // ============================================================
  // UPDATE
  // ============================================================

  group('SyncService - UPDATE', () {
    test('should update pendingUpdate task and mark it as synced', () async {
      final task = createTask(syncStatus: SyncStatus.pendingUpdate);

      when(() => repository.updateRemote(task)).thenAnswer((_) async {});

      when(() => repository.update(any<Task>())).thenAnswer((_) async {});

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([task]);

      expect(report.updated, 1);
      expect(report.failed, 0);
      expect(report.tasks.length, 1);
      expect(report.tasks.first.syncStatus, SyncStatus.synced);

      verify(() => repository.updateRemote(task)).called(1);

      verify(
        () => repository.update(
          any<Task>(
            that: isA<Task>().having(
              (t) => t.syncStatus,
              'syncStatus',
              SyncStatus.synced,
            ),
          ),
        ),
      ).called(1);
    });

    test(
      'should increment failed when update throws NetworkException',
      () async {
        final task = createTask(syncStatus: SyncStatus.pendingUpdate);

        when(
          () => repository.updateRemote(task),
        ).thenThrow(const NetworkException());

        when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

        when(
          () => repository.upsertAll(any<List<Task>>()),
        ).thenAnswer((_) async {});

        final report = await syncService.sync([task]);

        expect(report.updated, 0);
        expect(report.failed, 1);
        expect(report.tasks.first.syncStatus, SyncStatus.pendingUpdate);
      },
    );

    test(
      'should increment failed when update throws FirestoreWriteException',
      () async {
        final task = createTask(syncStatus: SyncStatus.pendingUpdate);

        when(
          () => repository.updateRemote(task),
        ).thenThrow(const FirestoreWriteException());

        when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

        when(
          () => repository.upsertAll(any<List<Task>>()),
        ).thenAnswer((_) async {});

        final report = await syncService.sync([task]);

        expect(report.updated, 0);
        expect(report.failed, 1);
      },
    );

    test('should rethrow AuthenticationException during update', () async {
      final task = createTask(syncStatus: SyncStatus.pendingUpdate);

      when(
        () => repository.updateRemote(task),
      ).thenThrow(const AuthenticationException());

      expect(
        () => syncService.sync([task]),
        throwsA(isA<AuthenticationException>()),
      );
    });
  });

  // ============================================================
  // HARD DELETE
  // ============================================================

  group('SyncService - HARD DELETE', () {
    test('should delete pendingHardDelete task remotely and locally', () async {
      final task = createTask(
        syncStatus: SyncStatus.pendingHardDelete,
        isDeleted: true,
      );

      when(() => repository.deleteRemote(task)).thenAnswer((_) async {});

      when(() => repository.delete(task)).thenAnswer((_) async {});

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([task]);

      expect(report.deleted, 1);
      expect(report.failed, 0);
      expect(report.tasks, isEmpty);

      verify(() => repository.deleteRemote(task)).called(1);

      verify(() => repository.delete(task)).called(1);
    });

    test('should keep task locally when remote delete fails', () async {
      final task = createTask(
        syncStatus: SyncStatus.pendingHardDelete,
        isDeleted: true,
      );

      when(
        () => repository.deleteRemote(task),
      ).thenThrow(const NetworkException());

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([task]);

      expect(report.deleted, 0);
      expect(report.failed, 1);
      expect(report.tasks.length, 1);
      expect(report.tasks.first.id, task.id);

      verifyNever(() => repository.delete(any<Task>()));
    });

    test(
      'should increment failed when delete throws FirestoreWriteException',
      () async {
        final task = createTask(
          syncStatus: SyncStatus.pendingHardDelete,
          isDeleted: true,
        );

        when(
          () => repository.deleteRemote(task),
        ).thenThrow(const FirestoreWriteException());

        when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

        when(
          () => repository.upsertAll(any<List<Task>>()),
        ).thenAnswer((_) async {});

        final report = await syncService.sync([task]);

        expect(report.deleted, 0);
        expect(report.failed, 1);
        expect(report.tasks.length, 1);
      },
    );

    test('should rethrow AuthenticationException during delete', () async {
      final task = createTask(
        syncStatus: SyncStatus.pendingHardDelete,
        isDeleted: true,
      );

      when(
        () => repository.deleteRemote(task),
      ).thenThrow(const AuthenticationException());

      expect(
        () => syncService.sync([task]),
        throwsA(isA<AuthenticationException>()),
      );
    });
  });

  // ============================================================
  // MERGE
  // ============================================================

  group('SyncService - MERGE', () {
    test('should keep remote-only tasks', () async {
      final remoteTask = createTask(id: 'remote-1', title: 'Remote Task');

      when(
        () => repository.getRemoteAll(),
      ).thenAnswer((_) async => [remoteTask]);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([]);

      expect(report.tasks.length, 1);
      expect(report.tasks.first.id, 'remote-1');
      expect(report.tasks.first.title, 'Remote Task');
    });

    test('should keep local-only tasks', () async {
      final localTask = createTask(id: 'local-1', title: 'Local Task');

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([localTask]);

      expect(report.tasks.length, 1);
      expect(report.tasks.first.id, 'local-1');
      expect(report.tasks.first.title, 'Local Task');
    });

    test('should keep newer local synced task', () async {
      final localTask = createTask(
        id: 'task-1',
        title: 'Local Newer',
        syncStatus: SyncStatus.synced,
        lastModified: baseDate.add(const Duration(minutes: 10)),
      );

      final remoteTask = createTask(
        id: 'task-1',
        title: 'Remote Older',
        syncStatus: SyncStatus.synced,
        lastModified: baseDate,
      );

      when(
        () => repository.getRemoteAll(),
      ).thenAnswer((_) async => [remoteTask]);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([localTask]);

      expect(report.tasks.length, 1);
      expect(report.tasks.first.title, 'Local Newer');
      expect(report.tasks.first.lastModified, localTask.lastModified);
    });

    test('should keep newer remote synced task', () async {
      final localTask = createTask(
        id: 'task-1',
        title: 'Local Older',
        syncStatus: SyncStatus.synced,
        lastModified: baseDate,
      );

      final remoteTask = createTask(
        id: 'task-1',
        title: 'Remote Newer',
        syncStatus: SyncStatus.synced,
        lastModified: baseDate.add(const Duration(minutes: 10)),
      );

      when(
        () => repository.getRemoteAll(),
      ).thenAnswer((_) async => [remoteTask]);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([localTask]);

      expect(report.tasks.length, 1);
      expect(report.tasks.first.title, 'Remote Newer');
      expect(report.tasks.first.lastModified, remoteTask.lastModified);
    });

    test('should keep newer pending local task', () async {
      final localTask = createTask(
        id: 'task-1',
        title: 'Local Pending',
        syncStatus: SyncStatus.pendingUpdate,
        lastModified: baseDate.add(const Duration(minutes: 10)),
      );

      final remoteTask = createTask(
        id: 'task-1',
        title: 'Remote Older',
        syncStatus: SyncStatus.synced,
        lastModified: baseDate,
      );

      when(() => repository.updateRemote(localTask)).thenAnswer((_) async {});

      when(() => repository.update(any<Task>())).thenAnswer((_) async {});

      when(
        () => repository.getRemoteAll(),
      ).thenAnswer((_) async => [remoteTask]);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([localTask]);

      expect(report.updated, 1);
      expect(report.tasks.first.title, 'Local Pending');
      expect(report.tasks.first.syncStatus, SyncStatus.synced);
    });

    test(
      'should keep newer remote task when pending local task is older',
      () async {
        final localTask = createTask(
          id: 'task-1',
          title: 'Local Older',
          syncStatus: SyncStatus.pendingUpdate,
          lastModified: baseDate,
        );

        final remoteTask = createTask(
          id: 'task-1',
          title: 'Remote Newer',
          syncStatus: SyncStatus.synced,
          lastModified: baseDate.add(const Duration(minutes: 10)),
        );

        when(() => repository.updateRemote(localTask)).thenAnswer((_) async {});

        when(() => repository.update(any<Task>())).thenAnswer((_) async {});

        // Correct remote response.
        when(
          () => repository.getRemoteAll(),
        ).thenAnswer((_) async => [remoteTask]);

        when(
          () => repository.upsertAll(any<List<Task>>()),
        ).thenAnswer((_) async {});

        final report = await syncService.sync([localTask]);

        expect(report.updated, 1);
        expect(report.tasks.length, 1);
        expect(report.tasks.first.title, 'Remote Newer');
      },
    );

    test('should sort merged tasks by lastModified descending', () async {
      final oldTask = createTask(
        id: 'old',
        title: 'Old',
        lastModified: baseDate,
      );

      final middleTask = createTask(
        id: 'middle',
        title: 'Middle',
        lastModified: baseDate.add(const Duration(minutes: 10)),
      );

      final newTask = createTask(
        id: 'new',
        title: 'New',
        lastModified: baseDate.add(const Duration(minutes: 20)),
      );

      when(
        () => repository.getRemoteAll(),
      ).thenAnswer((_) async => [oldTask, newTask, middleTask]);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([]);

      expect(report.tasks.map((t) => t.id).toList(), ['new', 'middle', 'old']);
    });
  });

  // ============================================================
  // COMPLETE SYNC
  // ============================================================

  group('SyncService - COMPLETE SYNC', () {
    test('should perform create, update, delete and merge', () async {
      final createTaskItem = createTask(
        id: 'create-1',
        title: 'Create',
        syncStatus: SyncStatus.pendingCreate,
        lastModified: baseDate.add(const Duration(minutes: 1)),
      );

      final updateTaskItem = createTask(
        id: 'update-1',
        title: 'Update',
        syncStatus: SyncStatus.pendingUpdate,
        lastModified: baseDate.add(const Duration(minutes: 2)),
      );

      final deleteTaskItem = createTask(
        id: 'delete-1',
        title: 'Delete',
        syncStatus: SyncStatus.pendingHardDelete,
        isDeleted: true,
        lastModified: baseDate.add(const Duration(minutes: 3)),
      );

      final remoteTask = createTask(
        id: 'remote-1',
        title: 'Remote',
        syncStatus: SyncStatus.synced,
        lastModified: baseDate.add(const Duration(minutes: 4)),
      );

      when(
        () => repository.createRemote(createTaskItem),
      ).thenAnswer((_) async {});

      when(
        () => repository.updateRemote(updateTaskItem),
      ).thenAnswer((_) async {});

      when(
        () => repository.deleteRemote(deleteTaskItem),
      ).thenAnswer((_) async {});

      when(() => repository.update(any<Task>())).thenAnswer((_) async {});

      when(() => repository.delete(deleteTaskItem)).thenAnswer((_) async {});

      when(
        () => repository.getRemoteAll(),
      ).thenAnswer((_) async => [remoteTask]);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([
        createTaskItem,
        updateTaskItem,
        deleteTaskItem,
      ]);

      expect(report.uploaded, 1);
      expect(report.updated, 1);
      expect(report.deleted, 1);
      expect(report.failed, 0);

      expect(report.total, 3);
      expect(report.hasFailures, false);

      expect(report.tasks.length, 3);

      expect(report.tasks.any((task) => task.id == 'create-1'), true);

      expect(report.tasks.any((task) => task.id == 'update-1'), true);

      expect(report.tasks.any((task) => task.id == 'remote-1'), true);

      expect(report.tasks.any((task) => task.id == 'delete-1'), false);

      verify(() => repository.createRemote(createTaskItem)).called(1);

      verify(() => repository.updateRemote(updateTaskItem)).called(1);

      verify(() => repository.deleteRemote(deleteTaskItem)).called(1);

      verify(() => repository.delete(deleteTaskItem)).called(1);

      verify(() => repository.upsertAll(any<List<Task>>())).called(1);
    });

    test('should return failed report when one operation fails', () async {
      final task = createTask(
        id: 'create-1',
        syncStatus: SyncStatus.pendingCreate,
      );

      when(
        () => repository.createRemote(task),
      ).thenThrow(const NetworkException());

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([task]);

      expect(report.uploaded, 0);
      expect(report.updated, 0);
      expect(report.deleted, 0);
      expect(report.failed, 1);
      expect(report.total, 0);
      expect(report.hasFailures, true);
    });
  });

  // ============================================================
  // FINAL REPORT
  // ============================================================

  group('SyncService - FINAL REPORT', () {
    test('should return correct SyncReport totals', () async {
      final createTaskItem = createTask(
        id: 'create',
        syncStatus: SyncStatus.pendingCreate,
      );

      final updateTaskItem = createTask(
        id: 'update',
        syncStatus: SyncStatus.pendingUpdate,
      );

      final deleteTaskItem = createTask(
        id: 'delete',
        syncStatus: SyncStatus.pendingHardDelete,
        isDeleted: true,
      );

      when(
        () => repository.createRemote(createTaskItem),
      ).thenAnswer((_) async {});

      when(
        () => repository.updateRemote(updateTaskItem),
      ).thenAnswer((_) async {});

      when(
        () => repository.deleteRemote(deleteTaskItem),
      ).thenAnswer((_) async {});

      when(() => repository.update(any<Task>())).thenAnswer((_) async {});

      when(() => repository.delete(deleteTaskItem)).thenAnswer((_) async {});

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final SyncReport report = await syncService.sync([
        createTaskItem,
        updateTaskItem,
        deleteTaskItem,
      ]);

      expect(report.uploaded, 1);
      expect(report.updated, 1);
      expect(report.deleted, 1);
      expect(report.failed, 0);

      expect(report.total, 3);
      expect(report.hasFailures, false);
    });

    test('should mark report as failed when operation fails', () async {
      final task = createTask(syncStatus: SyncStatus.pendingCreate);

      when(
        () => repository.createRemote(task),
      ).thenThrow(const FirestoreWriteException());

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([task]);

      expect(report.failed, 1);
      expect(report.hasFailures, true);
      expect(report.total, 0);
    });
  });

  // ============================================================
  // UPSERT
  // ============================================================

  group('SyncService - LOCAL MERGE SAVE', () {
    test('should save final merged tasks using upsertAll', () async {
      final task = createTask();

      when(() => repository.getRemoteAll()).thenAnswer((_) async => []);

      when(
        () => repository.upsertAll(any<List<Task>>()),
      ).thenAnswer((_) async {});

      final report = await syncService.sync([task]);

      expect(report.tasks.length, 1);

      final captured = verify(
        () => repository.upsertAll(captureAny<List<Task>>()),
      ).captured.single;

      final savedTasks = captured as List<Task>;

      expect(savedTasks.length, 1);
      expect(savedTasks.first.id, task.id);
    });
  });
}

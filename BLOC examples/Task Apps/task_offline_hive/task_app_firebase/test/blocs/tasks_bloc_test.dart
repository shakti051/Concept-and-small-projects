import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import 'package:task_app_firebase/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:task_app_firebase/core/exceptions/app_exceptions.dart';
import 'package:task_app_firebase/core/logger/logger.dart';
import 'package:task_app_firebase/models/sync_report.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/respository/task_repository.dart';
import 'package:task_app_firebase/services/retry_scheduler.dart';
import 'package:task_app_firebase/services/sync_queue.dart';
import 'package:task_app_firebase/services/sync_schedular.dart';
import 'package:task_app_firebase/services/sync_service.dart';

// ============================================================
// MOCKS
// ============================================================

class MockTaskRepository extends Mock implements TaskRepository {}

class MockConnectivityBloc extends Mock implements ConnectivityBloc {}

class MockSyncQueue extends Mock implements SyncQueue {}

class MockSyncService extends Mock implements SyncService {}

class MockLoggerService extends Mock implements LoggerService {}

class MockSyncScheduler extends Mock implements SyncScheduler {}

class MockRetryScheduler extends Mock implements RetryScheduler {}

// ============================================================
// FAKE
// ============================================================

class FakeTask extends Fake implements Task {}

// ============================================================
// TEST
// ============================================================

void main() {
  late MockTaskRepository repository;
  late MockConnectivityBloc connectivityBloc;
  late MockSyncQueue syncQueue;
  late MockSyncService syncService;
  late MockLoggerService logger;
  late MockSyncScheduler syncScheduler;
  late MockRetryScheduler retryScheduler;

  late Task task1;
  late Task task2;
  late Task newTask;
  late Task completedTask;
  late Task favoriteTask;
  late Task removedTask;

  // ==========================================================
  // HELPER
  // ==========================================================

  Task createTask({
    String id = 'task-1',
    String title = 'Task 1',
    String ownerId = 'test-owner-1',
    bool isDone = false,
    bool isDeleted = false,
    bool isFavorite = false,
    SyncStatus syncStatus = SyncStatus.synced,
    DateTime? lastModified,
  }) {
    return Task(
      id: id,
      title: title,
      ownerId: ownerId,
      description: 'Test Description',
      date: '2026-07-30',
      isDone: isDone,
      isDeleted: isDeleted,
      isFavorite: isFavorite,
      syncStatus: syncStatus,
      lastModified: lastModified ?? DateTime(2026, 7, 30, 10, 0),
      
    );
  }

  // ==========================================================
  // BUILD BLOC
  // ==========================================================

  TasksBloc buildBloc() {
    return TasksBloc(
      connectivityBloc,
      repository,
      syncQueue,
      logger,
      syncScheduler,
      retryScheduler,
      syncService,
    );
  }

  // ==========================================================
  // MOCKTAIL FALLBACK
  // ==========================================================

  setUpAll(() {
    registerFallbackValue(FakeTask());
  });

  // ==========================================================
  // SETUP
  // ==========================================================

  setUp(() {
    // --------------------------------------------------------
    // Create mocks
    // --------------------------------------------------------

    repository = MockTaskRepository();
    connectivityBloc = MockConnectivityBloc();
    syncQueue = MockSyncQueue();
    syncService = MockSyncService();
    logger = MockLoggerService();
    syncScheduler = MockSyncScheduler();
    retryScheduler = MockRetryScheduler();

    // --------------------------------------------------------
    // Connectivity
    // --------------------------------------------------------

    when(
      () => connectivityBloc.state,
    ).thenReturn(ConnectivityState(status: ConnectionStatus.online));

    // --------------------------------------------------------
    // Sync Scheduler
    // --------------------------------------------------------

    when(() => syncScheduler.schedule(any())).thenAnswer((_) {});

    when(() => syncScheduler.dispose()).thenReturn(null);

    // --------------------------------------------------------
    // Retry Scheduler
    // --------------------------------------------------------

    when(() => retryScheduler.schedule(any())).thenAnswer((_) {});

    when(() => retryScheduler.reset()).thenReturn(null);

    when(() => retryScheduler.dispose()).thenReturn(null);

    // --------------------------------------------------------
    // Sync Queue
    // --------------------------------------------------------

    when(() => syncQueue.enqueue(any())).thenAnswer((_) {});

    // --------------------------------------------------------
    // Repository defaults
    // --------------------------------------------------------

    when(() => repository.getAll()).thenAnswer((_) async => []);

    when(() => repository.create(any())).thenAnswer((_) async {});

    when(() => repository.update(any())).thenAnswer((_) async {});

    when(() => repository.delete(any())).thenAnswer((_) async {});

    when(() => repository.upsertAll(any())).thenAnswer((_) async {});

    // --------------------------------------------------------
    // Test Tasks
    // --------------------------------------------------------

    task1 = createTask(
      id: 'task-1',
      title: 'Task 1',
      lastModified: DateTime(2026, 7, 30, 10, 0),
    );

    task2 = createTask(
      id: 'task-2',
      title: 'Task 2',
      lastModified: DateTime(2026, 7, 30, 11, 0),
    );

    completedTask = createTask(
      id: 'task-3',
      title: 'Completed Task',
      isDone: true,
      lastModified: DateTime(2026, 7, 30, 12, 0),
    );

    favoriteTask = createTask(
      id: 'task-4',
      title: 'Favorite Task',
      isFavorite: true,
      lastModified: DateTime(2026, 7, 30, 13, 0),
    );

    removedTask = createTask(
      id: 'task-5',
      title: 'Removed Task',
      isDeleted: true,
      lastModified: DateTime(2026, 7, 30, 14, 0),
    );

    newTask = task1.copyWith(
      title: 'Edited Task',
      description: 'Updated Description',
    );
  });

  // ==========================================================
  // INITIAL STATE
  // ==========================================================

  test('initial state should be empty', () async {
    final bloc = buildBloc();

    expect(bloc.state.pendingTasks, isEmpty);
    expect(bloc.state.completedTasks, isEmpty);
    expect(bloc.state.favoriteTasks, isEmpty);
    expect(bloc.state.removedTasks, isEmpty);
    expect(bloc.state.syncState, SyncState.idle);

    await bloc.close();
  });

  // ==========================================================
  // GET ALL TASKS
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'GetAllTsak loads and categorizes tasks',
    build: () {
      when(() => repository.getAll()).thenAnswer(
        (_) async => [task1, task2, completedTask, favoriteTask, removedTask],
      );

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(GetAllTsak());
    },
    expect: () => [
      isA<TasksState>()
          .having((s) => s.pendingTasks.length, 'pending task count', 3)
          .having((s) => s.completedTasks.length, 'completed task count', 1)
          .having((s) => s.favoriteTasks.length, 'favorite task count', 1)
          .having((s) => s.removedTasks.length, 'removed task count', 1)
          .having((s) => s.syncState, 'sync state', SyncState.synced),
    ],
  );

  // ==========================================================
  // ADD TASK
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'AddTask creates task locally as pendingCreate',
    build: () {
      when(() => repository.create(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer(
        (_) async => [task1.copyWith(syncStatus: SyncStatus.pendingCreate)],
      );
      return buildBloc();
    },
    act: (bloc) {
      bloc.add(AddTask(task: task1));
    },
    verify: (_) {
      final captured =
          verify(() => repository.create(captureAny())).captured.single as Task;

      expect(captured.syncStatus, SyncStatus.pendingCreate);
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.pendingTasks.length,
        'pending tasks',
        1,
      ),
    ],
  );

  // ==========================================================
  // ADD TASK - LOCAL DATABASE FAILURE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'AddTask emits failed state on LocalDatabaseException',
    build: () {
      when(
        () => repository.create(any()),
      ).thenThrow(const LocalDatabaseException());

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(AddTask(task: task1));
    },
    expect: () => [
      isA<TasksState>()
          .having((s) => s.syncState, 'sync state', SyncState.failed)
          .having(
            (s) => s.syncMessage,
            'message',
            'Unable to perform local operation.',
          ),
    ],
  );

  // ==========================================================
  // UPDATE TASK
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'UpdateTask toggles isDone and updates repository',
    build: () {
      when(() => repository.update(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer(
        (_) async => [
          task1.copyWith(isDone: true, syncStatus: SyncStatus.pendingUpdate),
        ],
      );

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(UpdateTask(task: task1));
    },
    verify: (_) {
      final captured =
          verify(() => repository.update(captureAny())).captured.single as Task;

      expect(captured.isDone, true);
      expect(captured.syncStatus, SyncStatus.pendingUpdate);
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.completedTasks.length,
        'completed tasks',
        1,
      ),
    ],
  );


// ==========================================================
// UPDATE PENDING CREATE TASK
// ==========================================================

blocTest<TasksBloc, TasksState>(
  'UpdateTask keeps pendingCreate status for unsynced task',
  build: () {
    final pendingTask = task1.copyWith(
      syncStatus: SyncStatus.pendingCreate,
      isDone: false,
    );

    // After UpdateTask, the BLoC should toggle isDone
    // from false -> true while preserving pendingCreate.
    final updatedTask = pendingTask.copyWith(
      isDone: true,
    );

    when(
      () => repository.update(any()),
    ).thenAnswer((_) async {});

    when(
      () => repository.getAll(),
    ).thenAnswer((_) async => [updatedTask]);

    return buildBloc();
  },
  seed: () => TasksState(
    pendingTasks: [
      task1.copyWith(
        syncStatus: SyncStatus.pendingCreate,
        isDone: false,
      ),
    ],
  ),
  act: (bloc) {
    // IMPORTANT:
    // Pass the ORIGINAL pending task.
    // UpdateTask itself performs the toggle.
    final pendingTask = task1.copyWith(
      syncStatus: SyncStatus.pendingCreate,
      isDone: false,
    );

    bloc.add(
      UpdateTask(
        task: pendingTask,
      ),
    );
  },
  verify: (_) {
    final captured =
        verify(
          () => repository.update(captureAny()),
        ).captured.single as Task;

    expect(captured.isDone, true);

    // The task has not yet been uploaded,
    // so updating it must NOT change pendingCreate
    // into pendingUpdate.
    expect(
      captured.syncStatus,
      SyncStatus.pendingCreate,
    );
  },
  expect: () => [
    isA<TasksState>().having(
      (s) => s.completedTasks.length,
      'completed tasks',
      1,
    ),
  ],
);

  // ==========================================================
  // UPDATE - LOCAL DATABASE FAILURE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'UpdateTask emits failed state on local database failure',
    build: () {
      when(
        () => repository.update(any()),
      ).thenThrow(const LocalDatabaseException());

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(UpdateTask(task: task1));
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.syncState,
        'sync state',
        SyncState.failed,
      ),
    ],
  );

  // ==========================================================
  // REMOVE TASK
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'RemoveTask marks task as deleted',
    build: () {
      when(() => repository.update(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer(
        (_) async => [
          task1.copyWith(isDeleted: true, syncStatus: SyncStatus.pendingUpdate),
        ],
      );

      return buildBloc();
    },
    seed: () => TasksState(pendingTasks: [task1]),
    act: (bloc) {
      bloc.add(RemoveTask(task: task1));
    },
    verify: (_) {
      final captured =
          verify(() => repository.update(captureAny())).captured.single as Task;

      expect(captured.isDeleted, true);
      expect(captured.syncStatus, SyncStatus.pendingUpdate);
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.removedTasks.length,
        'removed tasks',
        1,
      ),
    ],
  );

  // ==========================================================
  // REMOVE TASK - LOCAL FAILURE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'RemoveTask emits failure on LocalDatabaseException',
    build: () {
      when(
        () => repository.update(any()),
      ).thenThrow(const LocalDatabaseException());

      return buildBloc();
    },
    seed: () => TasksState(pendingTasks: [task1]),
    act: (bloc) {
      bloc.add(RemoveTask(task: task1));
    },
    expect: () => [
      isA<TasksState>()
          .having((s) => s.syncState, 'sync state', SyncState.failed)
          .having(
            (s) => s.syncMessage,
            'message',
            "Couldn't remove task locally.",
          ),
    ],
  );

  // ==========================================================
  // DELETE PENDING CREATE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'DeleteTask permanently deletes pendingCreate task locally',
    build: () {
      when(() => repository.delete(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer((_) async => []);

      return buildBloc();
    },
    seed: () => TasksState(
      pendingTasks: [task1.copyWith(syncStatus: SyncStatus.pendingCreate)],
    ),
    act: (bloc) {
      bloc.add(
        DeleteTask(task: task1.copyWith(syncStatus: SyncStatus.pendingCreate)),
      );
    },
    verify: (_) {
      verify(() => repository.delete(any())).called(1);

      verifyNever(() => repository.update(any()));
    },
  );

  // ==========================================================
  // DELETE SYNCED TASK
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'DeleteTask marks synced task for hard delete',
    build: () {
      when(() => repository.update(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer(
        (_) async => [
          task1.copyWith(
            isDeleted: true,
            syncStatus: SyncStatus.pendingHardDelete,
          ),
        ],
      );

      return buildBloc();
    },
    seed: () => TasksState(removedTasks: [task1]),
    act: (bloc) {
      bloc.add(DeleteTask(task: task1));
    },
    verify: (_) {
      final captured =
          verify(() => repository.update(captureAny())).captured.single as Task;

      expect(captured.isDeleted, true);
      expect(captured.syncStatus, SyncStatus.pendingHardDelete);
    },
  );

  // ==========================================================
  // FAVORITE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'MarkFavoriteOrUnfavoriteTask toggles favorite',
    build: () {
      when(() => repository.update(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer(
        (_) async => [
          task1.copyWith(
            isFavorite: true,
            syncStatus: SyncStatus.pendingUpdate,
          ),
        ],
      );

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(MarkFavoriteOrUnfavoriteTask(task: task1));
    },
    verify: (_) {
      final captured =
          verify(() => repository.update(captureAny())).captured.single as Task;

      expect(captured.isFavorite, true);
      expect(captured.syncStatus, SyncStatus.pendingUpdate);
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.favoriteTasks.length,
        'favorite tasks',
        1,
      ),
    ],
  );

  // ==========================================================
  // UNFAVORITE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'MarkFavoriteOrUnfavoriteTask removes favorite flag',
    build: () {
      when(() => repository.update(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer(
        (_) async => [
          favoriteTask.copyWith(
            isFavorite: false,
            syncStatus: SyncStatus.pendingUpdate,
          ),
        ],
      );

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(MarkFavoriteOrUnfavoriteTask(task: favoriteTask));
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.favoriteTasks,
        'favorite tasks',
        isEmpty,
      ),
    ],
  );

  // ==========================================================
  // EDIT TASK
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'EditTask updates task and marks pendingUpdate',
    build: () {
      final editedTask = task1.copyWith(title: 'Edited Task');

      when(() => repository.update(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer(
        (_) async => [
          editedTask.copyWith(syncStatus: SyncStatus.pendingUpdate),
        ],
      );

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(EditTask(oldTask: task1, newTask: newTask));
    },
    verify: (_) {
      final captured =
          verify(() => repository.update(captureAny())).captured.single as Task;

      expect(captured.title, 'Edited Task');

      expect(captured.syncStatus, SyncStatus.pendingUpdate);
    },
  );

  // ==========================================================
  // RESTORE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'RestoreTask restores deleted task',
    build: () {
      when(() => repository.update(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer(
        (_) async => [
          removedTask.copyWith(
            isDeleted: false,
            isDone: false,
            isFavorite: false,
            syncStatus: SyncStatus.pendingUpdate,
          ),
        ],
      );

      return buildBloc();
    },
    seed: () => TasksState(removedTasks: [removedTask]),
    act: (bloc) {
      bloc.add(RestoreTask(task: removedTask));
    },
    verify: (_) {
      final captured =
          verify(() => repository.update(captureAny())).captured.single as Task;

      expect(captured.isDeleted, false);
      expect(captured.isDone, false);
      expect(captured.isFavorite, false);
      expect(captured.syncStatus, SyncStatus.pendingUpdate);
    },
    expect: () => [
      isA<TasksState>().having((s) => s.removedTasks, 'removed tasks', isEmpty),
    ],
  );

  // ==========================================================
  // DELETE ALL
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'DeleteAllTasks hard deletes synced removed tasks',
    build: () {
      when(() => repository.update(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer((_) async => []);

      return buildBloc();
    },
    seed: () => TasksState(
      removedTasks: [
        removedTask,
        createTask(id: 'task-6', title: 'Removed 2', isDeleted: true),
      ],
    ),
    act: (bloc) {
      bloc.add(DeleteAllTasks());
    },
    verify: (_) {
      verify(() => repository.update(any())).called(2);
    },
  );

  // ==========================================================
  // DELETE ALL - PENDING CREATE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'DeleteAllTasks directly deletes pendingCreate tasks',
    build: () {
      when(() => repository.delete(any())).thenAnswer((_) async {});

      when(() => repository.getAll()).thenAnswer((_) async => []);

      return buildBloc();
    },
    seed: () => TasksState(
      removedTasks: [
        removedTask.copyWith(syncStatus: SyncStatus.pendingCreate),
      ],
    ),
    act: (bloc) {
      bloc.add(DeleteAllTasks());
    },
    verify: (_) {
      verify(() => repository.delete(any())).called(1);

      verifyNever(() => repository.update(any()));
    },
  );

  // ==========================================================
  // SYNC - SUCCESS
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'SyncPendingTasks emits syncing then synced',
    build: () {
      final syncedTask = task1.copyWith(syncStatus: SyncStatus.synced);

      when(() => repository.getAll()).thenAnswer((_) async => [task1]);

      when(
        () => syncService.sync(any()),
      ).thenAnswer((_) async => SyncReport(tasks: [syncedTask], uploaded: 1));

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const SyncPendingTasks());
    },
    expect: () => [
      isA<TasksState>()
          .having((s) => s.syncState, 'sync state', SyncState.syncing)
          .having((s) => s.syncMessage, 'sync message', 'Syncing...'),
      isA<TasksState>()
          .having((s) => s.syncState, 'sync state', SyncState.synced)
          .having((s) => s.syncMessage, 'sync message', '1 uploaded'),
    ],
  );

  // ==========================================================
  // SYNC - FAILED REPORT
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'SyncPendingTasks emits failed when report contains failures',
    build: () {
      when(() => repository.getAll()).thenAnswer((_) async => [task1]);

      when(() => syncService.sync(any())).thenAnswer(
        (_) async => SyncReport(tasks: [task1], uploaded: 1, failed: 1),
      );

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const SyncPendingTasks());
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.syncState,
        'sync state',
        SyncState.syncing,
      ),
      isA<TasksState>()
          .having((s) => s.syncState, 'sync state', SyncState.failed)
          .having((s) => s.syncMessage, 'sync message', '1 uploaded, 1 failed'),
    ],
  );

  // ==========================================================
  // SYNC - NETWORK FAILURE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'SyncPendingTasks handles NetworkException',
    build: () {
      when(() => repository.getAll()).thenAnswer((_) async => [task1]);

      when(() => syncService.sync(any())).thenThrow(const NetworkException());

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const SyncPendingTasks());
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.syncState,
        'sync state',
        SyncState.syncing,
      ),
      isA<TasksState>()
          .having((s) => s.syncState, 'sync state', SyncState.failed)
          .having(
            (s) => s.syncMessage,
            'sync message',
            'No internet connection.',
          ),
    ],
    verify: (_) {
      verify(() => retryScheduler.schedule(any())).called(1);
    },
  );

  // ==========================================================
  // SYNC - AUTHENTICATION FAILURE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'SyncPendingTasks handles AuthenticationException without retry',
    build: () {
      when(() => repository.getAll()).thenAnswer((_) async => [task1]);

      when(
        () => syncService.sync(any()),
      ).thenThrow(const AuthenticationException());

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const SyncPendingTasks());
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.syncState,
        'sync state',
        SyncState.syncing,
      ),
      isA<TasksState>()
          .having((s) => s.syncState, 'sync state', SyncState.failed)
          .having(
            (s) => s.syncMessage,
            'sync message',
            'Session expired. Please login again.',
          ),
    ],
    verify: (_) {
      verify(() => retryScheduler.reset()).called(1);

      verifyNever(() => retryScheduler.schedule(any()));
    },
  );

  // ==========================================================
  // SYNC - UNKNOWN FAILURE
  // ==========================================================

  blocTest<TasksBloc, TasksState>(
    'SyncPendingTasks handles unknown exception and schedules retry',
    build: () {
      when(() => repository.getAll()).thenAnswer((_) async => [task1]);

      when(
        () => syncService.sync(any()),
      ).thenThrow(Exception('Unexpected error'));

      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const SyncPendingTasks());
    },
    expect: () => [
      isA<TasksState>().having(
        (s) => s.syncState,
        'sync state',
        SyncState.syncing,
      ),
      isA<TasksState>()
          .having((s) => s.syncState, 'sync state', SyncState.failed)
          .having(
            (s) => s.syncMessage,
            'sync message',
            'Sync failed. Will retry automatically.',
          ),
    ],
    verify: (_) {
      verify(() => retryScheduler.schedule(any())).called(1);
    },
  );

  // ==========================================================
  // CLOSE
  // ==========================================================

  test('close() disposes schedulers', () async {
    final bloc = buildBloc();

    await bloc.close();

    verify(() => syncScheduler.dispose()).called(1);

    verify(() => retryScheduler.dispose()).called(1);
  });
}

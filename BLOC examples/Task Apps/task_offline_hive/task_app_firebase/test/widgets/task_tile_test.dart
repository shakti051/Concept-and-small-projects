import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app_firebase/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/widgets/task_tile.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

class FakeTasksEvent extends Fake implements TasksEvent {}

void main() {
  late MockTasksBloc mockBloc;

  late Task task;

  setUpAll(() {
    registerFallbackValue(FakeTasksEvent());
  });

  Task createTask({
    String id = 'task-1',
    String title = 'Test Task',
    String ownerId = 'test-owner-1',
    String description = 'Test Description',
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
      description: description,
      date: '2026-07-30',
      isDone: isDone,
      isDeleted: isDeleted,
      isFavorite: isFavorite,
      syncStatus: syncStatus,
      lastModified: lastModified ?? DateTime(2026, 7, 30),
    );
  }

  Widget buildTestWidget({
    required Task task,
    TasksState state = const TasksState(),
  }) {
    when(() => mockBloc.state).thenReturn(state);

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TasksBloc>.value(
          value: mockBloc,
          child: TaskTile(task: task),
        ),
      ),
    );
  }

  setUp(() {
  mockBloc = MockTasksBloc();

  task = createTask();

  when(() => mockBloc.state).thenReturn(const TasksState());

  when(
    () => mockBloc.stream,
  ).thenAnswer(
    (_) => const Stream<TasksState>.empty(),
  );
});

  // ============================================================
  // BASIC UI
  // ============================================================

  group('TaskTile - BASIC UI', () {

    testWidgets('should display task title', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(task: task),
      );

      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('should display task date', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(task: task),
      );

      // DateFormat().add_yMMMd().add_Hms()
      expect(
        find.textContaining('Jul 30, 2026'),
        findsOneWidget,
      );
    });

    testWidgets('should display favorite icon when task is favorite', (
      tester,
    ) async {
      final favoriteTask = task.copyWith(
        isFavorite: true,
      );

      await tester.pumpWidget(
        buildTestWidget(task: favoriteTask),
      );

      expect(
        find.byIcon(Icons.star),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.star_outline),
        findsNothing,
      );
    });

    testWidgets('should display star outline when task is not favorite', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(task: task),
      );

      expect(
        find.byIcon(Icons.star_outline),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.star),
        findsNothing,
      );
    });
  });

  // ============================================================
  // COMPLETED TASK
  // ============================================================

  group('TaskTile - COMPLETED', () {
    testWidgets('should show line-through when task is completed', (
      tester,
    ) async {
      final completedTask = task.copyWith(
        isDone: true,
      );

      await tester.pumpWidget(
        buildTestWidget(task: completedTask),
      );

      final titleFinder = find.text('Test Task');

      final textWidget = tester.widget<Text>(titleFinder);

      expect(
        textWidget.style?.decoration,
        TextDecoration.lineThrough,
      );
    });

    testWidgets('should show checked checkbox when task is completed', (
      tester,
    ) async {
      final completedTask = task.copyWith(
        isDone: true,
      );

      await tester.pumpWidget(
        buildTestWidget(task: completedTask),
      );

      final checkbox = tester.widget<Checkbox>(
        find.byType(Checkbox),
      );

      expect(checkbox.value, true);
    });

    testWidgets('should show unchecked checkbox when task is incomplete', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(task: task),
      );

      final checkbox = tester.widget<Checkbox>(
        find.byType(Checkbox),
      );

      expect(checkbox.value, false);
    });
  });

  // ============================================================
  // CHECKBOX
  // ============================================================

  group('TaskTile - CHECKBOX', () {
    testWidgets('should dispatch UpdateTask when checkbox is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(task: task),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      verify(
        () => mockBloc.add(
          any(
            that: isA<UpdateTask>().having(
              (event) => event.task,
              'task',
              task,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('should disable checkbox when task is deleted', (
      tester,
    ) async {
      final deletedTask = task.copyWith(
        isDeleted: true,
      );

      await tester.pumpWidget(
        buildTestWidget(task: deletedTask),
      );

      final checkbox = tester.widget<Checkbox>(
        find.byType(Checkbox),
      );

      expect(checkbox.onChanged, isNull);
    });

    testWidgets('should not dispatch UpdateTask for deleted task', (
      tester,
    ) async {
      final deletedTask = task.copyWith(
        isDeleted: true,
      );

      await tester.pumpWidget(
        buildTestWidget(task: deletedTask),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      verifyNever(
        () => mockBloc.add(any(that: isA<UpdateTask>())),
      );
    });
  });

  // ============================================================
  // SYNC INDICATORS
  // ============================================================

  group('TaskTile - SYNC INDICATOR', () {
    testWidgets('should show cloud done for synced task', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(task: task),
      );

      expect(
        find.byIcon(Icons.cloud_done),
        findsOneWidget,
      );
    });

    testWidgets('should show upload icon for pendingCreate', (
      tester,
    ) async {
      final pendingTask = task.copyWith(
        syncStatus: SyncStatus.pendingCreate,
      );

      await tester.pumpWidget(
        buildTestWidget(task: pendingTask),
      );

      expect(
        find.byIcon(Icons.cloud_upload_outlined),
        findsOneWidget,
      );
    });

    testWidgets('should show upload icon for pendingUpdate', (
      tester,
    ) async {
      final pendingTask = task.copyWith(
        syncStatus: SyncStatus.pendingUpdate,
      );

      await tester.pumpWidget(
        buildTestWidget(task: pendingTask),
      );

      expect(
        find.byIcon(Icons.cloud_upload_outlined),
        findsOneWidget,
      );
    });

    testWidgets('should show delete icon for pendingHardDelete', (
      tester,
    ) async {
      final pendingTask = task.copyWith(
        syncStatus: SyncStatus.pendingHardDelete,
      );

      await tester.pumpWidget(
        buildTestWidget(task: pendingTask),
      );

      expect(
        find.byIcon(Icons.delete_outline),
        findsOneWidget,
      );
    });

    testWidgets('should show progress indicator when task is syncing', (
      tester,
    ) async {
      final state = TasksState(
        syncingTaskIds: {'task-1'},
      );

      await tester.pumpWidget(
        buildTestWidget(
          task: task,
          state: state,
        ),
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.cloud_done),
        findsNothing,
      );
    });
  });

  // ============================================================
  // BLoC STATE
  // ============================================================

  group('TaskTile - BLOC STATE', () {
    testWidgets(
      'should show syncing indicator only for current task',
      (tester) async {
        final state = TasksState(
          syncingTaskIds: {'another-task'},
        );

        await tester.pumpWidget(
          buildTestWidget(
            task: task,
            state: state,
          ),
        );

        expect(
          find.byType(CircularProgressIndicator),
          findsNothing,
        );

        expect(
          find.byIcon(Icons.cloud_done),
          findsOneWidget,
        );
      },
    );
  });
}

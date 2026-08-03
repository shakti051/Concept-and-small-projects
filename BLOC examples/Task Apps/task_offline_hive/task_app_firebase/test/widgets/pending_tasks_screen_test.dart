import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/screens/pending_screen.dart';
import 'package:task_app_firebase/widgets/tasks_list.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

void main() {
  late MockTasksBloc mockBloc;

  setUp(() {
    mockBloc = MockTasksBloc();

    when(() => mockBloc.state).thenReturn(
      const TasksState(),
    );

    when(() => mockBloc.stream).thenAnswer(
      (_) => const Stream<TasksState>.empty(),
    );
  });

  Task createTask({
    String id = 'task-1',
    String title = 'Test Task',
    bool isDone = false,
    bool isDeleted = false,
    bool isFavorite = false,
  }) {
    return Task(
      id: id,
      title: title,
      description: 'Test Description',
      date: '2026-07-30',
      isDone: isDone,
      isDeleted: isDeleted,
      isFavorite: isFavorite,
      syncStatus: SyncStatus.synced,
      lastModified: DateTime.utc(2026, 7, 30, 10),
    );
  }

  Widget buildTestWidget({
    TasksState state = const TasksState(),
  }) {
    when(() => mockBloc.state).thenReturn(state);

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TasksBloc>.value(
          value: mockBloc,
          child: const PendingTasksScreen(),
        ),
      ),
    );
  }

  // ============================================================
  // BASIC RENDERING
  // ============================================================

  group('PendingTasksScreen - Rendering', () {
    testWidgets(
      'should render pending and completed task count',
      (tester) async {
        final pendingTask = createTask(
          id: '1',
          title: 'Pending Task',
        );

        final completedTask = createTask(
          id: '2',
          title: 'Completed Task',
          isDone: true,
        );

        final state = TasksState(
          pendingTasks: [pendingTask],
          completedTasks: [completedTask],
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.text('1 Pending | 1 Completed'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display zero counts when there are no tasks',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(),
          ),
        );

        expect(
          find.text('0 Pending | 0 Completed'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should render TasksList',
      (tester) async {
        final task = createTask();

        final state = TasksState(
          pendingTasks: [task],
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.byType(TasksList),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should render pending task title',
      (tester) async {
        final task = createTask(
          title: 'My Pending Task',
        );

        final state = TasksState(
          pendingTasks: [task],
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.text('My Pending Task'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should render multiple pending tasks',
      (tester) async {
        final tasks = [
          createTask(
            id: '1',
            title: 'Task One',
          ),
          createTask(
            id: '2',
            title: 'Task Two',
          ),
          createTask(
            id: '3',
            title: 'Task Three',
          ),
        ];

        final state = TasksState(
          pendingTasks: tasks,
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.text('Task One'),
          findsOneWidget,
        );

        expect(
          find.text('Task Two'),
          findsOneWidget,
        );

        expect(
          find.text('Task Three'),
          findsOneWidget,
        );

        expect(
          find.byType(TasksList),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // CHIP
  // ============================================================

  group('PendingTasksScreen - Task Count Chip', () {
    testWidgets(
      'should display correct pending count',
      (tester) async {
        final tasks = [
          createTask(id: '1'),
          createTask(id: '2'),
          createTask(id: '3'),
        ];

        final state = TasksState(
          pendingTasks: tasks,
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.byType(Chip),
          findsOneWidget,
        );

        expect(
          find.text('3 Pending | 0 Completed'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display correct completed count',
      (tester) async {
        final completedTasks = [
          createTask(
            id: '1',
            title: 'Completed One',
            isDone: true,
          ),
          createTask(
            id: '2',
            title: 'Completed Two',
            isDone: true,
          ),
        ];

        final state = TasksState(
          completedTasks: completedTasks,
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.byType(Chip),
          findsOneWidget,
        );

        expect(
          find.text('0 Pending | 2 Completed'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display both pending and completed counts',
      (tester) async {
        final state = TasksState(
          pendingTasks: [
            createTask(id: '1'),
            createTask(id: '2'),
          ],
          completedTasks: [
            createTask(
              id: '3',
              isDone: true,
            ),
          ],
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.text('2 Pending | 1 Completed'),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // BLOC STATE UPDATE
  // ============================================================

  group('PendingTasksScreen - Bloc State', () {
    testWidgets(
      'should use pendingTasks from TasksState',
      (tester) async {
        final task = createTask(
          title: 'Pending Task',
        );

        final state = TasksState(
          pendingTasks: [task],
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.text('Pending Task'),
          findsOneWidget,
        );

        expect(
          find.text('1 Pending | 0 Completed'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should not display completed tasks in TasksList',
      (tester) async {
        final pendingTask = createTask(
          id: 'pending',
          title: 'Pending Task',
        );

        final completedTask = createTask(
          id: 'completed',
          title: 'Completed Task',
          isDone: true,
        );

        final state = TasksState(
          pendingTasks: [pendingTask],
          completedTasks: [completedTask],
        );

        await tester.pumpWidget(
          buildTestWidget(state: state),
        );

        expect(
          find.text('Pending Task'),
          findsOneWidget,
        );

        // Completed tasks are only counted here.
        // They are not passed to TasksList.
        expect(
          find.text('Completed Task'),
          findsNothing,
        );
      },
    );
  });

  // ============================================================
  // SCREEN IDENTIFIER
  // ============================================================

  group('PendingTasksScreen - Configuration', () {
    test(
      'should have correct screen id',
      () {
        expect(
          PendingTasksScreen.id,
          'tasks_screen',
        );
      },
    );
  });
}
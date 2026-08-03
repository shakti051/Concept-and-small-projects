import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/screens/completed_tasks_screen.dart';
import 'package:task_app_firebase/widgets/task_tile.dart';
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
    String title = 'Completed Task',
    String description = 'Completed Description',
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      date: '2026-07-30',
      isDone: true,
      isDeleted: false,
      isFavorite: false,
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
          child: const CompletedTasksScreen(),
        ),
      ),
    );
  }

  // ============================================================
  // BASIC RENDERING
  // ============================================================

  group('CompletedTasksScreen - Rendering', () {
    testWidgets('should render completed tasks count', (tester) async {
      final tasks = [
        createTask(id: '1', title: 'Task One'),
        createTask(id: '2', title: 'Task Two'),
        createTask(id: '3', title: 'Task Three'),
      ];

      final state = TasksState(
        completedTasks: tasks,
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(find.text('3 Tasks'), findsOneWidget);
    });

    testWidgets('should show zero tasks when completed list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          state: const TasksState(
            completedTasks: [],
          ),
        ),
      );

      expect(find.text('0 Tasks'), findsOneWidget);
    });

    testWidgets('should render TasksList', (tester) async {
      final task = createTask();

      final state = TasksState(
        completedTasks: [task],
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(find.byType(TasksList), findsOneWidget);
    });
  });

  // ============================================================
  // TASK COUNT
  // ============================================================

  group('CompletedTasksScreen - Task Count', () {
    testWidgets('should display correct count for one task', (
      tester,
    ) async {
      final state = TasksState(
        completedTasks: [
          createTask(),
        ],
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(find.text('1 Tasks'), findsOneWidget);
    });

    testWidgets('should display correct count for multiple tasks', (
      tester,
    ) async {
      final tasks = [
        createTask(id: '1', title: 'Task One'),
        createTask(id: '2', title: 'Task Two'),
        createTask(id: '3', title: 'Task Three'),
        createTask(id: '4', title: 'Task Four'),
        createTask(id: '5', title: 'Task Five'),
      ];

      final state = TasksState(
        completedTasks: tasks,
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(find.text('5 Tasks'), findsOneWidget);
    });
  });

  // ============================================================
  // TASK LIST
  // ============================================================

  group('CompletedTasksScreen - Task List', () {
    testWidgets('should render completed task title', (tester) async {
      final task = createTask(
        title: 'Completed Task',
      );

      final state = TasksState(
        completedTasks: [task],
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(find.text('Completed Task'), findsOneWidget);
    });

    testWidgets('should render multiple completed task titles', (
      tester,
    ) async {
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
        completedTasks: tasks,
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(find.text('Task One'), findsOneWidget);
      expect(find.text('Task Two'), findsOneWidget);
      expect(find.text('Task Three'), findsOneWidget);
    });

    testWidgets('should render correct number of TaskTile widgets', (
      tester,
    ) async {
      final tasks = [
        createTask(id: '1', title: 'Task One'),
        createTask(id: '2', title: 'Task Two'),
        createTask(id: '3', title: 'Task Three'),
      ];

      final state = TasksState(
        completedTasks: tasks,
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(
        find.byType(TaskTile),
        findsNWidgets(3),
      );
    });
  });

  // ============================================================
  // EMPTY STATE
  // ============================================================

  group('CompletedTasksScreen - Empty State', () {
    testWidgets('should render empty TasksList without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          state: const TasksState(
            completedTasks: [],
          ),
        ),
      );

      expect(find.byType(TasksList), findsOneWidget);
      expect(find.byType(TaskTile), findsNothing);
      expect(find.text('0 Tasks'), findsOneWidget);
    });
  });

  // ============================================================
  // TASK DATA
  // ============================================================

  group('CompletedTasksScreen - Task Data', () {
    testWidgets('should preserve completed task title', (tester) async {
      final task = createTask(
        title: 'Buy groceries',
        description: 'Milk, bread and eggs',
      );

      final state = TasksState(
        completedTasks: [task],
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(find.text('Buy groceries'), findsOneWidget);
    });

    testWidgets('should display completed task as done', (tester) async {
      final task = createTask(
        title: 'Finished Task',
      );

      final state = TasksState(
        completedTasks: [task],
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      final taskTile = tester.widget<TaskTile>(
        find.byType(TaskTile),
      );

      expect(taskTile.task.isDone, true);
    });

    testWidgets('should not render pending tasks', (tester) async {
      final completedTask = createTask(
        id: 'completed',
        title: 'Completed Task',
      );

      final state = TasksState(
        completedTasks: [completedTask],
        pendingTasks: [
          createTask(
            id: 'pending',
            title: 'Pending Task',
          ),
        ],
      );

      await tester.pumpWidget(
        buildTestWidget(state: state),
      );

      expect(find.text('Completed Task'), findsOneWidget);
      expect(find.text('Pending Task'), findsNothing);
      expect(find.text('1 Tasks'), findsOneWidget);
    });
  });

  // ============================================================
  // STATE UPDATE
  // ============================================================

  group('CompletedTasksScreen - State Update', () {
    testWidgets('should rebuild when bloc emits a new state', (
      tester,
    ) async {
      final initialState = TasksState(
        completedTasks: [
          createTask(
            id: '1',
            title: 'First Task',
          ),
        ],
      );

      final updatedState = TasksState(
        completedTasks: [
          createTask(
            id: '1',
            title: 'First Task',
          ),
          createTask(
            id: '2',
            title: 'Second Task',
          ),
        ],
      );

      when(() => mockBloc.state).thenReturn(initialState);

      final streamController = Stream<TasksState>.fromIterable([
        updatedState,
      ]);

      when(() => mockBloc.stream).thenAnswer(
        (_) => streamController,
      );

      await tester.pumpWidget(
        buildTestWidget(state: initialState),
      );

      expect(find.text('1 Tasks'), findsOneWidget);
      expect(find.text('First Task'), findsOneWidget);

      await tester.pump();

      expect(find.text('2 Tasks'), findsOneWidget);
      expect(find.text('Second Task'), findsOneWidget);
    });
  });
}
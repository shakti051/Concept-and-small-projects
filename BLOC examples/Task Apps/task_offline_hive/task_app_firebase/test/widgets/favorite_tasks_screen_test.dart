import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/screens/favorite_tasks_screen.dart';
import 'package:task_app_firebase/widgets/tasks_list.dart';
import 'package:task_app_firebase/widgets/task_tile.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

void main() {
  late MockTasksBloc mockBloc;

  // ------------------------------------------------------------
  // TASK FACTORY
  // ------------------------------------------------------------

  Task createTask({
    String id = 'task-1',
    String title = 'Test Task',
    String description = 'Test Description',
    bool isDone = false,
    bool isDeleted = false,
    bool isFavorite = true,
    SyncStatus syncStatus = SyncStatus.synced,
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      date: '2026-07-30',
      isDone: isDone,
      isDeleted: isDeleted,
      isFavorite: isFavorite,
      syncStatus: syncStatus,
      lastModified: DateTime.utc(2026, 7, 30, 10),
    );
  }

  // ------------------------------------------------------------
  // SETUP
  // ------------------------------------------------------------

  setUp(() {
    mockBloc = MockTasksBloc();

    when(() => mockBloc.state).thenReturn(
      const TasksState(),
    );

    when(() => mockBloc.stream).thenAnswer(
      (_) => const Stream<TasksState>.empty(),
    );
  });

  // ------------------------------------------------------------
  // TEST WRAPPER
  // ------------------------------------------------------------

  Widget buildTestWidget({
    TasksState state = const TasksState(),
  }) {
    when(() => mockBloc.state).thenReturn(state);

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TasksBloc>.value(
          value: mockBloc,
          child: const FavoriteTasksScreen(),
        ),
      ),
    );
  }

  // ============================================================
  // FAVORITE TASKS SCREEN - BASIC RENDERING
  // ============================================================

  group('FavoriteTasksScreen - Rendering', () {
    testWidgets(
      'should render FavoriteTasksScreen',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(FavoriteTasksScreen),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should render TasksList',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(TasksList),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display task count',
      (tester) async {
        final tasks = [
          createTask(id: '1', title: 'Task One'),
          createTask(id: '2', title: 'Task Two'),
          createTask(id: '3', title: 'Task Three'),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: tasks,
            ),
          ),
        );

        expect(
          find.text('3 Tasks'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display zero tasks when favorite list is empty',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              favoriteTasks: [],
            ),
          ),
        );

        expect(
          find.text('0 Tasks'),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // FAVORITE TASKS
  // ============================================================

  group('FavoriteTasksScreen - Favorite Tasks', () {
    testWidgets(
      'should display favorite task title',
      (tester) async {
        final task = createTask(
          title: 'Favorite Task',
          isFavorite: true,
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: [task],
            ),
          ),
        );

        expect(
          find.text('Favorite Task'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display multiple favorite tasks',
      (tester) async {
        final tasks = [
          createTask(
            id: '1',
            title: 'Favorite One',
          ),
          createTask(
            id: '2',
            title: 'Favorite Two',
          ),
          createTask(
            id: '3',
            title: 'Favorite Three',
          ),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: tasks,
            ),
          ),
        );

        expect(
          find.text('Favorite One'),
          findsOneWidget,
        );

        expect(
          find.text('Favorite Two'),
          findsOneWidget,
        );

        expect(
          find.text('Favorite Three'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should create one TaskTile for each favorite task',
      (tester) async {
        final tasks = [
          createTask(id: '1', title: 'Task One'),
          createTask(id: '2', title: 'Task Two'),
          createTask(id: '3', title: 'Task Three'),
          createTask(id: '4', title: 'Task Four'),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: tasks,
            ),
          ),
        );

        expect(
          find.byType(TaskTile),
          findsNWidgets(4),
        );
      },
    );
  });

  // ============================================================
  // FAVORITE TASK STATE
  // ============================================================

  group('FavoriteTasksScreen - State', () {
    testWidgets(
      'should use favoriteTasks from TasksState',
      (tester) async {
        final favoriteTask = createTask(
          id: 'favorite-1',
          title: 'Favorite Task',
        );

        final pendingTask = createTask(
          id: 'pending-1',
          title: 'Pending Task',
          isFavorite: false,
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              pendingTasks: [pendingTask],
              favoriteTasks: [favoriteTask],
            ),
          ),
        );

        expect(
          find.text('Favorite Task'),
          findsOneWidget,
        );

        expect(
          find.text('Pending Task'),
          findsNothing,
        );

        expect(
          find.text('1 Tasks'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display favorite tasks even when they are completed',
      (tester) async {
        final task = createTask(
          title: 'Completed Favorite',
          isDone: true,
          isFavorite: true,
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              completedTasks: [task],
              favoriteTasks: [task],
            ),
          ),
        );

        expect(
          find.text('Completed Favorite'),
          findsOneWidget,
        );

        expect(
          find.text('1 Tasks'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display favorite tasks even when they are pending',
      (tester) async {
        final task = createTask(
          title: 'Pending Favorite',
          isDone: false,
          isFavorite: true,
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              pendingTasks: [task],
              favoriteTasks: [task],
            ),
          ),
        );

        expect(
          find.text('Pending Favorite'),
          findsOneWidget,
        );

        expect(
          find.text('1 Tasks'),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // TASK DATA
  // ============================================================

  group('FavoriteTasksScreen - Task Data', () {
    testWidgets(
      'should display correct task title and description',
      (tester) async {
        final task = createTask(
          title: 'Buy groceries',
          description: 'Milk, bread and eggs',
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: [task],
            ),
          ),
        );

        expect(
          find.text('Buy groceries'),
          findsOneWidget,
        );

        await tester.tap(
          find.text('Buy groceries'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Milk, bread and eggs'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should handle a long task title',
      (tester) async {
        final task = createTask(
          title:
              'This is a very long favorite task title that should still be displayed correctly',
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: [task],
            ),
          ),
        );

        expect(
          find.text(
            'This is a very long favorite task title that should still be displayed correctly',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should handle a long task description',
      (tester) async {
        final task = createTask(
          description:
              'This is a very long favorite task description containing '
              'multiple pieces of information about the task.',
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: [task],
            ),
          ),
        );

        await tester.tap(
          find.text('Test Task'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'This is a very long favorite task description containing '
            'multiple pieces of information about the task.',
          ),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // FAVORITE ICON
  // ============================================================

  group('FavoriteTasksScreen - Favorite Icon', () {
    testWidgets(
      'should show favorite icon for favorite task',
      (tester) async {
        final task = createTask(
          title: 'Favorite Task',
          isFavorite: true,
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: [task],
            ),
          ),
        );

        expect(
          find.byIcon(Icons.star),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show favorite outline icon when task is not favorite',
      (tester) async {
        final task = createTask(
          title: 'Not Favorite',
          isFavorite: false,
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              favoriteTasks: [task],
            ),
          ),
        );

        expect(
          find.byIcon(Icons.star_outline),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // EMPTY STATE
  // ============================================================

  group('FavoriteTasksScreen - Empty State', () {
    testWidgets(
      'should render empty TasksList without errors',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              favoriteTasks: [],
            ),
          ),
        );

        expect(
          find.byType(TasksList),
          findsOneWidget,
        );

        expect(
          find.byType(TaskTile),
          findsNothing,
        );

        expect(
          find.text('0 Tasks'),
          findsOneWidget,
        );
      },
    );
  });
}
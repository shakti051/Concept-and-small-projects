import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/widgets/task_tile.dart';
import 'package:task_app_firebase/widgets/tasks_list.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

void main() {
  late MockTasksBloc mockBloc;

  // ------------------------------------------------------------
  // SETUP
  // ------------------------------------------------------------

  setUp(() {
    mockBloc = MockTasksBloc();

    when(() => mockBloc.state).thenReturn(const TasksState());

    when(
      () => mockBloc.stream,
    ).thenAnswer(
      (_) => const Stream<TasksState>.empty(),
    );
  });

  // ------------------------------------------------------------
  // TASK FACTORY
  // ------------------------------------------------------------

  Task createTask({
    String id = 'task-1',
    String title = 'Test Task',
    String ownerId = 'test-owner-1',
    String description = 'Test Description',
    bool isDone = false,
    bool isDeleted = false,
    bool isFavorite = false,
    SyncStatus syncStatus = SyncStatus.synced,
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
      lastModified: DateTime.utc(2026, 7, 30, 10),
    );
  }

  // ------------------------------------------------------------
  // TEST WRAPPER
  // ------------------------------------------------------------

  Widget buildTestWidget({
    required List<Task> tasks,
    TasksState state = const TasksState(),
  }) {
    when(() => mockBloc.state).thenReturn(state);

    when(
      () => mockBloc.stream,
    ).thenAnswer(
      (_) => const Stream<TasksState>.empty(),
    );

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            BlocProvider<TasksBloc>.value(
              value: mockBloc,
              child: TasksList(
                tasksList: tasks,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HELPER
  // ------------------------------------------------------------

  String getExpandedText(WidgetTester tester) {
    final selectableText = tester.widget<SelectableText>(
      find.byType(SelectableText),
    );

    return selectableText.textSpan!.toPlainText();
  }

  // ============================================================
  // BASIC RENDERING
  // ============================================================

  group('TasksList - Rendering', () {
    testWidgets('should render task title', (tester) async {
      final task = createTask();

      await tester.pumpWidget(
        buildTestWidget(
          tasks: [task],
        ),
      );

      expect(
        find.text('Test Task'),
        findsOneWidget,
      );
    });

    testWidgets('should render multiple task titles', (tester) async {
      final task1 = createTask(
        id: 'task-1',
        title: 'Task One',
      );

      final task2 = createTask(
        id: 'task-2',
        title: 'Task Two',
      );

      final task3 = createTask(
        id: 'task-3',
        title: 'Task Three',
      );

      await tester.pumpWidget(
        buildTestWidget(
          tasks: [
            task1,
            task2,
            task3,
          ],
        ),
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
    });

    testWidgets('should render empty list without errors', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          tasks: [],
        ),
      );

      expect(
        find.byType(ExpansionPanelList),
        findsOneWidget,
      );

      expect(
        find.byType(TaskTile),
        findsNothing,
      );
    });

    testWidgets('should create one TaskTile for each task', (tester) async {
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

      await tester.pumpWidget(
        buildTestWidget(
          tasks: tasks,
        ),
      );

      expect(
        find.byType(TaskTile),
        findsNWidgets(3),
      );
    });
  });


  group('TasksList - Task Data', () {
    testWidgets(
      'should display task title and description correctly',
      (tester) async {
        final task = createTask(
          title: 'Buy groceries',
          description: 'Milk, bread and eggs',
        );

        await tester.pumpWidget(
          buildTestWidget(
            tasks: [task],
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

        final text = getExpandedText(tester);

        expect(
          text,
          contains('Milk, bread and eggs'),
        );
      },
    );

    testWidgets(
      'should handle long task title',
      (tester) async {
        final task = createTask(
          title:
              'This is a very long task title that should still be displayed correctly',
        );

        await tester.pumpWidget(
          buildTestWidget(
            tasks: [task],
          ),
        );

        expect(
          find.text(
            'This is a very long task title that should still be displayed correctly',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should handle long task description',
      (tester) async {
        final task = createTask(
          description:
              'This is a very long task description containing '
              'multiple pieces of information about the task.',
        );

        await tester.pumpWidget(
          buildTestWidget(
            tasks: [task],
          ),
        );

        await tester.tap(
          find.text('Test Task'),
        );

        await tester.pumpAndSettle();

        final text = getExpandedText(tester);

        expect(
          text,
          contains(
            'This is a very long task description containing '
            'multiple pieces of information about the task.',
          ),
        );
      },
    );
  });
}
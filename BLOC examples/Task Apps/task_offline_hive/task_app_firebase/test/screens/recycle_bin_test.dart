import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/screens/recycle_bin.dart';
import 'package:task_app_firebase/widgets/tasks_list.dart';
import 'package:task_app_firebase/widgets/task_tile.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

void main() {
  late MockTasksBloc mockBloc;

  // ============================================================
  // TASK FACTORY
  // ============================================================

  Task createTask({
    String id = 'task-1',
    String title = 'Deleted Task',
    String ownerId = 'test-owner-1',
    String description = 'Deleted Description',
    bool isDone = false,
    bool isDeleted = true,
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

  // ============================================================
  // SETUP
  // ============================================================

  setUp(() {
    mockBloc = MockTasksBloc();

    when(() => mockBloc.state).thenReturn(
      const TasksState(),
    );

    when(() => mockBloc.stream).thenAnswer(
      (_) => const Stream<TasksState>.empty(),
    );
  });

  // ============================================================
  // TEST WRAPPER
  // ============================================================

  Widget buildTestWidget({
    TasksState state = const TasksState(),
  }) {
    when(() => mockBloc.state).thenReturn(state);

    return MaterialApp(
      home: BlocProvider<TasksBloc>.value(
        value: mockBloc,
        child: const RecycleBin(),
      ),
    );
  }

  // ============================================================
  // BASIC RENDERING
  // ============================================================

  group('RecycleBin - Rendering', () {
    testWidgets(
      'should render RecycleBin screen',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(RecycleBin),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display Recycle Bin app bar title',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.text('Recycle Bin'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display TasksList',
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
      'should display MyDrawer',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        // Drawer widget is created by RecycleBin.
        expect(
          find.byType(Drawer),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // TASK COUNT
  // ============================================================

  group('RecycleBin - Task Count', () {
    testWidgets(
      'should display 0 Tasks when recycle bin is empty',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              removedTasks: [],
            ),
          ),
        );

        expect(
          find.text('0 Tasks'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display correct number of removed tasks',
      (tester) async {
        final tasks = [
          createTask(id: '1', title: 'Deleted One'),
          createTask(id: '2', title: 'Deleted Two'),
          createTask(id: '3', title: 'Deleted Three'),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              removedTasks: tasks,
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
      'should display 1 Tasks when one task is removed',
      (tester) async {
        final task = createTask();

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              removedTasks: [task],
            ),
          ),
        );

        expect(
          find.text('1 Tasks'),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // REMOVED TASKS
  // ============================================================

  group('RecycleBin - Removed Tasks', () {
    testWidgets(
      'should display removed task title',
      (tester) async {
        final task = createTask(
          title: 'Deleted Task',
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              removedTasks: [task],
            ),
          ),
        );

        expect(
          find.text('Deleted Task'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display multiple removed tasks',
      (tester) async {
        final tasks = [
          createTask(
            id: '1',
            title: 'Deleted One',
          ),
          createTask(
            id: '2',
            title: 'Deleted Two',
          ),
          createTask(
            id: '3',
            title: 'Deleted Three',
          ),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              removedTasks: tasks,
            ),
          ),
        );

        expect(
          find.text('Deleted One'),
          findsOneWidget,
        );

        expect(
          find.text('Deleted Two'),
          findsOneWidget,
        );

        expect(
          find.text('Deleted Three'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should create one TaskTile for each removed task',
      (tester) async {
        final tasks = [
          createTask(id: '1', title: 'Deleted One'),
          createTask(id: '2', title: 'Deleted Two'),
          createTask(id: '3', title: 'Deleted Three'),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              removedTasks: tasks,
            ),
          ),
        );

        expect(
          find.byType(TaskTile),
          findsNWidgets(3),
        );
      },
    );

    testWidgets(
      'should render empty TasksList when there are no removed tasks',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              removedTasks: [],
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
      },
    );
  });

  // ============================================================
  // STATE ISOLATION
  // ============================================================

  group('RecycleBin - State', () {
    testWidgets(
      'should display only removedTasks',
      (tester) async {
        final removedTask = createTask(
          id: 'removed',
          title: 'Removed Task',
        );

        final pendingTask = createTask(
          id: 'pending',
          title: 'Pending Task',
          isDeleted: false,
        );

        final completedTask = createTask(
          id: 'completed',
          title: 'Completed Task',
          isDeleted: false,
          isDone: true,
        );

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              pendingTasks: [pendingTask],
              completedTasks: [completedTask],
              removedTasks: [removedTask],
            ),
          ),
        );

        expect(
          find.text('Removed Task'),
          findsOneWidget,
        );

        expect(
          find.text('Pending Task'),
          findsNothing,
        );

        expect(
          find.text('Completed Task'),
          findsNothing,
        );

        expect(
          find.text('1 Tasks'),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // POPUP MENU
  // ============================================================

  group('RecycleBin - Popup Menu', () {
    testWidgets(
      'should display PopupMenuButton',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(PopupMenuButton),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show Delete all tasks menu item',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Delete all tasks'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.delete_forever),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // DELETE ALL TASKS
  // ============================================================

  group('RecycleBin - Delete All', () {
    testWidgets(
      'should dispatch DeleteAllTasks when delete all is selected',
      (tester) async {
        final tasks = [
          createTask(id: '1'),
          createTask(id: '2'),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              removedTasks: tasks,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Delete all tasks'),
        );

        await tester.pump();

        verify(
          () => mockBloc.add(
            any(
              that: isA<DeleteAllTasks>(),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should dispatch GetAllTsak after DeleteAllTasks',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              removedTasks: [
                createTask(),
              ],
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Delete all tasks'),
        );

        await tester.pump();

        verify(
          () => mockBloc.add(
            any(
              that: isA<GetAllTsak>(),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should dispatch both DeleteAllTasks and GetAllTsak',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: TasksState(
              removedTasks: [
                createTask(),
              ],
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Delete all tasks'),
        );

        await tester.pump();

        verify(
          () => mockBloc.add(
            any(
              that: isA<DeleteAllTasks>(),
            ),
          ),
        ).called(1);

        verify(
          () => mockBloc.add(
            any(
              that: isA<GetAllTsak>(),
            ),
          ),
        ).called(1);
      },
    );
  });
}
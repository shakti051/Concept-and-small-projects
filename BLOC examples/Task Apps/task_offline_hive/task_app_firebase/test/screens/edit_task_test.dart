import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/widgets/../screens/edit_task_screen.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

class FakeTasksEvent extends Fake implements TasksEvent {}

void main() {
  late MockTasksBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTasksEvent());
  });

  setUp(() {
    mockBloc = MockTasksBloc();

    when(() => mockBloc.state).thenReturn(const TasksState());

    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => const Stream<TasksState>.empty());
  });

  Task createTask({
    String id = 'task-1',
    String title = 'Test Task',
    String description = 'Test Description',
    bool isFavorite = false,
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      date: '2026-07-30',
      isDone: false,
      isDeleted: false,
      isFavorite: isFavorite,
      syncStatus: SyncStatus.synced,
      lastModified: DateTime.utc(2026, 7, 30, 10),
      ownerId: 'test-owner-1',
    );
  }

  Widget buildTestWidget({required Task task}) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TasksBloc>.value(
          value: mockBloc,
          child: EditTaskScreen(oldTask: task),
        ),
      ),
    );
  }

  group('EditTaskScreen - Rendering', () {
    testWidgets('should display Edit Task title', (tester) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      expect(find.text('Edit Task'), findsOneWidget);
    });

    testWidgets('should display Title field', (tester) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      expect(find.text('Title'), findsOneWidget);

      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should display Description field', (tester) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display Cancel button', (tester) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      expect(find.text('cancel'), findsOneWidget);
    });

    testWidgets('should display Save button', (tester) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      expect(find.text('Save'), findsOneWidget);
    });
  });

  // ============================================================
  // INITIAL VALUES
  // ============================================================

  group('EditTaskScreen - Initial Values', () {
    testWidgets('should display existing task title', (tester) async {
      final task = createTask(title: 'Existing Title');

      await tester.pumpWidget(buildTestWidget(task: task));

      expect(find.text('Existing Title'), findsOneWidget);
    });

    testWidgets('should display existing task description', (tester) async {
      final task = createTask(description: 'Existing Description');

      await tester.pumpWidget(buildTestWidget(task: task));

      expect(find.text('Existing Description'), findsOneWidget);
    });

    testWidgets('should initialize title TextField with old title', (
      tester,
    ) async {
      final task = createTask(title: 'Old Title');

      await tester.pumpWidget(buildTestWidget(task: task));

      final fields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();

      expect(fields[0].controller?.text, 'Old Title');
    });

    testWidgets(
      'should initialize description TextField with old description',
      (tester) async {
        final task = createTask(description: 'Old Description');

        await tester.pumpWidget(buildTestWidget(task: task));

        final fields = tester
            .widgetList<TextField>(find.byType(TextField))
            .toList();

        expect(fields[1].controller?.text, 'Old Description');
      },
    );
  });

  // ============================================================
  // EDITING
  // ============================================================

  group('EditTaskScreen - Editing', () {
    testWidgets('should allow editing title', (tester) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      final titleField = find.byType(TextField).first;

      await tester.enterText(titleField, 'Updated Title');

      expect(find.text('Updated Title'), findsOneWidget);
    });

    testWidgets('should allow editing description', (tester) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      final descriptionField = find.byType(TextField).at(1);

      await tester.enterText(descriptionField, 'Updated Description');

      expect(find.text('Updated Description'), findsOneWidget);
    });

    testWidgets('should update both title and description', (tester) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      await tester.enterText(find.byType(TextField).first, 'New Title');

      await tester.enterText(find.byType(TextField).at(1), 'New Description');

      expect(find.text('New Title'), findsOneWidget);

      expect(find.text('New Description'), findsOneWidget);
    });
  });

  // ============================================================
  // CANCEL
  // ============================================================

  group('EditTaskScreen - Cancel', () {
    testWidgets('should close screen when cancel is pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<TasksBloc>.value(
              value: mockBloc,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return EditTaskScreen(oldTask: createTask());
                        },
                      );
                    },
                    child: const Text('Open Edit'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Edit'));

      await tester.pumpAndSettle();

      expect(find.text('Edit Task'), findsOneWidget);

      await tester.tap(find.text('cancel'));

      await tester.pumpAndSettle();

      expect(find.text('Edit Task'), findsNothing);
    });

    testWidgets('should not dispatch EditTask when cancel is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(task: createTask()));

      await tester.tap(find.text('cancel'));

      await tester.pump();

      verifyNever(() => mockBloc.add(any()));
    });
  });

  // ============================================================
  // SAVE
  // ============================================================

  group('EditTaskScreen - Save', () {
    testWidgets('should dispatch events when Save is pressed', (tester) async {
      final task = createTask();

      await tester.pumpWidget(buildTestWidget(task: task));

      await tester.enterText(find.byType(TextField).first, 'Updated Title');

      await tester.enterText(
        find.byType(TextField).at(1),
        'Updated Description',
      );

      await tester.tap(find.text('Save'));

      await tester.pump();

      verify(() => mockBloc.add(any(that: isA<EditTask>()))).called(1);

      verify(() => mockBloc.add(any(that: isA<GetAllTsak>()))).called(1);
    });

    testWidgets('should dispatch EditTask with updated title', (tester) async {
      final task = createTask();

      await tester.pumpWidget(buildTestWidget(task: task));

      await tester.enterText(find.byType(TextField).first, 'Updated Title');

      await tester.tap(find.text('Save'));

      await tester.pump();

      final captured = verify(
        () => mockBloc.add(captureAny(that: isA<EditTask>())),
      ).captured;

      final event = captured.single as EditTask;

      expect(event.newTask.title, 'Updated Title');

      expect(event.oldTask, equals(task));
    });

    testWidgets('should dispatch EditTask with updated description', (
      tester,
    ) async {
      final task = createTask();

      await tester.pumpWidget(buildTestWidget(task: task));

      await tester.enterText(
        find.byType(TextField).at(1),
        'Updated Description',
      );

      await tester.tap(find.text('Save'));

      await tester.pump();

      final captured = verify(
        () => mockBloc.add(captureAny(that: isA<EditTask>())),
      ).captured;

      final event = captured.single as EditTask;

      expect(event.newTask.description, 'Updated Description');
    });

    testWidgets('should preserve task id when saving', (tester) async {
      final task = createTask(id: 'important-task-id');

      await tester.pumpWidget(buildTestWidget(task: task));

      await tester.tap(find.text('Save'));

      await tester.pump();

      final captured = verify(
        () => mockBloc.add(captureAny(that: isA<EditTask>())),
      ).captured;

      final event = captured.single as EditTask;

      expect(event.newTask.id, 'important-task-id');
    });

    testWidgets('should preserve favorite status when saving', (tester) async {
      final task = createTask(isFavorite: true);

      await tester.pumpWidget(buildTestWidget(task: task));

      await tester.tap(find.text('Save'));

      await tester.pump();

      final captured = verify(
        () => mockBloc.add(captureAny(that: isA<EditTask>())),
      ).captured;

      final event = captured.single as EditTask;

      expect(event.newTask.isFavorite, true);
    });
  });
}

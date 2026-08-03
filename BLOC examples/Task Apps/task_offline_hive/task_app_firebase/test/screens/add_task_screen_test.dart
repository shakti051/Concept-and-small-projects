import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/screens/edit_task_screen.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

void main() {
  late MockTasksBloc mockBloc;

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
    bool isDone = false,
    bool isFavorite = false,
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      date: '2026-07-30',
      isDone: isDone,
      isDeleted: false,
      isFavorite: isFavorite,
      syncStatus: SyncStatus.synced,
      lastModified: DateTime.utc(2026, 7, 30, 10),
    );
  }

  Widget buildTestWidget({Task? task}) {
    final testTask = task ?? createTask();

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TasksBloc>.value(
          value: mockBloc,
          child: EditTaskScreen(oldTask: testTask),
        ),
      ),
    );
  }

  group('EditTaskScreen - Rendering', () {
    testWidgets('should display Edit Task title', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Edit Task'), findsOneWidget);
    });

    testWidgets('should display Title field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('should display Description field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display Save button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('should display Cancel button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('cancel'), findsOneWidget);
    });
  });

  group('EditTaskScreen - Initial Values', () {
    testWidgets('should show existing task title', (tester) async {
      final task = createTask(title: 'Existing Title');

      await tester.pumpWidget(buildTestWidget(task: task));

      expect(find.text('Existing Title'), findsOneWidget);
    });

    testWidgets('should show existing task description', (tester) async {
      final task = createTask(description: 'Existing Description');

      await tester.pumpWidget(buildTestWidget(task: task));

      expect(find.text('Existing Description'), findsOneWidget);
    });
  });

  group('EditTaskScreen - Text Editing', () {
    testWidgets('should update title field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final titleField = find.byType(TextField).first;

      await tester.enterText(titleField, 'Updated Title');

      expect(find.text('Updated Title'), findsOneWidget);
    });

    testWidgets('should update description field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final descriptionField = find.byType(TextField).last;

      await tester.enterText(descriptionField, 'Updated Description');

      expect(find.text('Updated Description'), findsOneWidget);
    });

    testWidgets('should have two text fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(TextField), findsNWidgets(2));
    });
  });

  group('EditTaskScreen - Buttons', () {
    testWidgets('should have one Save button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    });

    testWidgets('should have one cancel button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.widgetWithText(TextButton, 'cancel'), findsOneWidget);
    });

    testWidgets('should close screen when cancel is tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => BlocProvider<TasksBloc>.value(
                        value: mockBloc,
                        child: EditTaskScreen(oldTask: createTask()),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Task'), findsOneWidget);

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Task'), findsNothing);
    });
  });

  group('EditTaskScreen - Save', () {
    testWidgets('should dispatch EditTask when Save is tapped', (tester) async {
      final task = createTask();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TasksBloc>.value(
            value: mockBloc,
            child: Builder(
              builder: (context) {
                return Scaffold(body: EditTaskScreen(oldTask: task));
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));

      await tester.pump();

      verify(() => mockBloc.add(any(that: isA<EditTask>()))).called(1);
    });
    testWidgets('should dispatch GetAllTsak after Save', (tester) async {
      final task = createTask();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TasksBloc>.value(
            value: mockBloc,
            child: Scaffold(body: EditTaskScreen(oldTask: task)),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));

      await tester.pump();

      verify(() => mockBloc.add(any(that: isA<GetAllTsak>()))).called(1);
    });
    testWidgets('should update title and description before saving', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextField).first, 'New Title');

      await tester.enterText(find.byType(TextField).last, 'New Description');

      expect(find.text('New Title'), findsOneWidget);

      expect(find.text('New Description'), findsOneWidget);
    });
  });
}

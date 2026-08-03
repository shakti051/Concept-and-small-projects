import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/screens/my_drawer.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';
import 'package:task_app_firebase/screens/recycle_bin.dart';
import 'package:task_app_firebase/screens/login_screen.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

class MockSwitchBloc extends Mock implements SwitchBloc {}


void main() {
  late MockTasksBloc mockTasksBloc;
  late MockSwitchBloc mockSwitchBloc;

  setUp(() {
    mockTasksBloc = MockTasksBloc();
    mockSwitchBloc = MockSwitchBloc();

    when(() => mockTasksBloc.state).thenReturn(const TasksState());

    when(
      () => mockTasksBloc.stream,
    ).thenAnswer((_) => const Stream<TasksState>.empty());

    when(
      () => mockSwitchBloc.state,
    ).thenReturn(const SwitchState(switchValue: false));

    when(
      () => mockSwitchBloc.stream,
    ).thenAnswer((_) => const Stream<SwitchState>.empty());
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
    TasksState tasksState = const TasksState(),
    SwitchState switchState = const SwitchState(switchValue: false),
  }) {
    when(() => mockTasksBloc.state).thenReturn(tasksState);

    when(() => mockSwitchBloc.state).thenReturn(switchState);

    return MaterialApp(
      routes: {
        TabsScreen.id: (_) =>
            const Scaffold(body: Text('Pending Tasks Screen')),
        RecycleBin.id: (_) => const Scaffold(body: Text('Recycle Bin Screen')),
        LoginScreen.id: (_) => const Scaffold(body: Text('Login Screen')),
      },
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TasksBloc>.value(value: mockTasksBloc),
          BlocProvider<SwitchBloc>.value(value: mockSwitchBloc),
        ],
        child: const Scaffold(drawer: MyDrawer()),
      ),
    );
  }

  // ============================================================
  // BASIC RENDERING
  // ============================================================

  group('MyDrawer - Rendering', () {
    testWidgets('should display Task Drawer header', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Task Drawer'), findsOneWidget);
    });

    testWidgets('should display My Tasks', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('My Tasks'), findsOneWidget);
    });

    testWidgets('should display Bin', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Bin'), findsOneWidget);
    });

    testWidgets('should display Logout', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('should display Switch', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Switch), findsOneWidget);
    });
  });

  // ============================================================
  // TASK COUNTS
  // ============================================================

  group('MyDrawer - Task Counts', () {
    testWidgets('should display pending and completed task counts', (
      tester,
    ) async {
      final pendingTasks = [
        createTask(id: '1'),
        createTask(id: '2'),
        createTask(id: '3'),
      ];

      final completedTasks = [
        createTask(id: '4', isDone: true),
        createTask(id: '5', isDone: true),
      ];

      await tester.pumpWidget(
        buildTestWidget(
          tasksState: TasksState(
            pendingTasks: pendingTasks,
            completedTasks: completedTasks,
          ),
        ),
      );

      expect(find.text('3 | 2'), findsOneWidget);
    });

    testWidgets('should display removed task count', (tester) async {
      final removedTasks = [
        createTask(id: '1', isDeleted: true),
        createTask(id: '2', isDeleted: true),
        createTask(id: '3', isDeleted: true),
        createTask(id: '4', isDeleted: true),
      ];

      await tester.pumpWidget(
        buildTestWidget(tasksState: TasksState(removedTasks: removedTasks)),
      );

      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('should display zero counts when there are no tasks', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('0 | 0'), findsOneWidget);

      expect(find.text('0'), findsWidgets);
    });
  });

  // ============================================================
  // SWITCH
  // ============================================================

  group('MyDrawer - Switch', () {
    testWidgets('should display switch in off state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(switchState: const SwitchState(switchValue: false)),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));

      expect(switchWidget.value, false);
    });

    testWidgets('should display switch in on state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(switchState: const SwitchState(switchValue: true)),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));

      expect(switchWidget.value, true);
    });

    testWidgets('should dispatch SwitchOnEvent when switch is turned on', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(switchState: const SwitchState(switchValue: false)),
      );

      await tester.tap(find.byType(Switch));

      await tester.pump();

      verify(
        () => mockSwitchBloc.add(any(that: isA<SwitchOnEvent>())),
      ).called(1);
    });

    testWidgets('should dispatch SwitchOffEvent when switch is turned off', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(switchState: const SwitchState(switchValue: true)),
      );

      await tester.tap(find.byType(Switch));

      await tester.pump();

      verify(
        () => mockSwitchBloc.add(any(that: isA<SwitchOffEvent>())),
      ).called(1);
    });
  });

  // ============================================================
  // NAVIGATION
  // ============================================================

  group('MyDrawer - Navigation', () {
    testWidgets('should navigate to My Tasks', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('My Tasks'));

      await tester.pumpAndSettle();

      expect(find.text('Pending Tasks Screen'), findsOneWidget);
    });

    testWidgets('should navigate to Bin', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Bin'));

      await tester.pumpAndSettle();

      expect(find.text('Recycle Bin Screen'), findsOneWidget);
    });
  });

  // ============================================================
  // LOGOUT
  // ============================================================

  group('MyDrawer - Logout', () {
    testWidgets('should navigate to Login screen when Logout is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Logout'));

      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    });
  });
}

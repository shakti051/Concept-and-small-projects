import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/screens/completed_tasks_screen.dart';
import 'package:task_app_firebase/screens/favorite_tasks_screen.dart';
import 'package:task_app_firebase/screens/pending_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';

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


 Widget buildTestWidget({
  TasksState state = const TasksState(),
}) {
  when(() => mockBloc.state).thenReturn(state);

  when(() => mockBloc.stream).thenAnswer(
    (_) => const Stream<TasksState>.empty(),
  );

  return MaterialApp(
    home: BlocProvider<TasksBloc>.value(
      value: mockBloc,
      child: const TabsScreen(),
    ),
  );
}
  // ============================================================
  // INITIAL RENDERING
  // ============================================================

  group('TabsScreen - Initial Rendering', () {
    testWidgets(
      'should render TabsScreen',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(TabsScreen),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show Pending Tasks title initially',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.text('Pending Tasks'),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'should show bottom navigation bar',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(BottomNavigationBar),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show three bottom navigation items',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        final navigationBar =
            tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );

        expect(
          navigationBar.items.length,
          3,
        );
      },
    );

    testWidgets(
      'should select Pending Tasks initially',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        final navigationBar =
            tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );

        expect(
          navigationBar.currentIndex,
          0,
        );
      },
    );
  });

  // ============================================================
  // INITIAL BLOC EVENT
  // ============================================================

  group('TabsScreen - Bloc Events', () {
    testWidgets(
      'should dispatch GetAllTsak on initialization',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

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
      'should dispatch SyncPendingTasks when sync button is tapped',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        final syncButton = find.byTooltip('Sync now');

        expect(
          syncButton,
          findsOneWidget,
        );

        await tester.tap(syncButton);
        await tester.pump();

        verify(
          () => mockBloc.add(
            any(
              that: isA<SyncPendingTasks>(),
            ),
          ),
        ).called(1);
      },
    );
  });

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  group('TabsScreen - Bottom Navigation', () {
    testWidgets(
      'should switch to Completed Tasks',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        await tester.tap(
          find.text('Completed Tasks').last,
        );

        await tester.pumpAndSettle();

        final navigationBar =
            tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );

        expect(
          navigationBar.currentIndex,
          1,
        );

        expect(
          find.text('Completed Tasks'),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'should switch to Favorite Tasks',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        await tester.tap(
          find.text('Favorite Tasks'),
        );

        await tester.pumpAndSettle();

        final navigationBar =
            tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );

        expect(
          navigationBar.currentIndex,
          2,
        );

        expect(
          find.text('Favorite Tasks'),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'should return to Pending Tasks',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        // Go to Completed.
        await tester.tap(
          find.text('Completed Tasks').last,
        );

        await tester.pumpAndSettle();

        // Return to Pending.
        await tester.tap(
          find.text('Pending Tasks').last,
        );

        await tester.pumpAndSettle();

        final navigationBar =
            tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );

        expect(
          navigationBar.currentIndex,
          0,
        );
      },
    );
  });

  // ============================================================
  // SYNC BUTTON
  // ============================================================

  group('TabsScreen - Sync Button', () {
    testWidgets(
      'should show Sync now tooltip when idle',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              syncState: SyncState.idle,
            ),
          ),
        );

        expect(
          find.byTooltip('Sync now'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show Syncing tooltip while syncing',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              syncState: SyncState.syncing,
            ),
          ),
        );

        expect(
          find.byTooltip('Syncing...'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should disable sync button while syncing',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              syncState: SyncState.syncing,
            ),
          ),
        );

        final button =
            tester.widget<IconButton>(
          find.byTooltip('Syncing...'),
        );

        expect(
          button.onPressed,
          isNull,
        );
      },
    );

    testWidgets(
      'should enable sync button when idle',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              syncState: SyncState.idle,
            ),
          ),
        );

        final button =
            tester.widget<IconButton>(
          find.byTooltip('Sync now'),
        );

        expect(
          button.onPressed,
          isNotNull,
        );
      },
    );

    testWidgets(
      'should show sync icon',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byIcon(Icons.sync),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // ADD TASK BUTTON
  // ============================================================

  group('TabsScreen - Add Task', () {
    testWidgets(
      'should show add task icon',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byIcon(Icons.add),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'should show Add Task floating action button on Pending tab',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byTooltip('Add Task'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should hide Add Task floating action button on Completed tab',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        await tester.tap(
          find.text('Completed Tasks').last,
        );

        await tester.pumpAndSettle();

        expect(
          find.byTooltip('Add Task'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'should hide Add Task floating action button on Favorite tab',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        await tester.tap(
          find.text('Favorite Tasks'),
        );

        await tester.pumpAndSettle();

        expect(
          find.byTooltip('Add Task'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'should open Add Task bottom sheet',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        await tester.tap(
          find.byTooltip('Add Task'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Add Task'),
          findsWidgets,
        );
      },
    );
  });

  // ============================================================
  // APP BAR
  // ============================================================

  group('TabsScreen - AppBar', () {
    testWidgets(
      'should show AppBar',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(AppBar),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show sync button in AppBar',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byTooltip('Sync now'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show add button in AppBar',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        final appBar =
            tester.widget<AppBar>(
          find.byType(AppBar),
        );

        expect(
          appBar.actions,
          isNotEmpty,
        );
      },
    );
  });

  // ============================================================
  // DRAWER
  // ============================================================

  group('TabsScreen - Drawer', () {
    testWidgets(
      'should create drawer',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(Drawer),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // SYNC STATES
  // ============================================================

  group('TabsScreen - Sync State', () {
    testWidgets(
      'should not show sync failure snackbar when idle',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              syncState: SyncState.idle,
            ),
          ),
        );

        expect(
          find.byType(SnackBar),
          findsNothing,
        );
      },
    );

    testWidgets(
      'should show success snackbar when sync completes',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              syncState: SyncState.synced,
              syncMessage: 'Sync completed successfully',
            ),
          ),
        );

        await tester.pump();

        expect(
          find.text('Sync completed successfully'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show failure snackbar when sync fails',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            state: const TasksState(
              syncState: SyncState.failed,
              syncMessage: 'Sync failed',
            ),
          ),
        );

        await tester.pump();

        expect(
          find.text('Sync failed'),
          findsOneWidget,
        );
      },
    );
  });

  // ============================================================
  // PAGE CONTENT
  // ============================================================

  group('TabsScreen - Page Content', () {
    testWidgets(
      'should show PendingTasksScreen initially',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        expect(
          find.byType(PendingTasksScreen),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show CompletedTasksScreen after navigation',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        await tester.tap(
          find.text('Completed Tasks').last,
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(CompletedTasksScreen),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show FavoriteTasksScreen after navigation',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(),
        );

        await tester.tap(
          find.text('Favorite Tasks'),
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(FavoriteTasksScreen),
          findsOneWidget,
        );
      },
    );
  });
}
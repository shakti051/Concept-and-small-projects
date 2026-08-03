import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/widgets/popup_menu.dart';


void main() {
  Task createTask({
    String id = 'task-1',
    String title = 'Test Task',
    bool isDeleted = false,
    bool isFavorite = false,
  }) {
    return Task(
      id: id,
      title: title,
      description: 'Test Description',
      date: '2026-07-30',
      isDone: false,
      isDeleted: isDeleted,
      isFavorite: isFavorite,
      syncStatus: SyncStatus.synced,
      lastModified: DateTime.utc(2026, 7, 30, 10),
    );
  }

  Widget buildTestWidget({
    required Task task,
    VoidCallback? cancelOrDeleteCallback,
    VoidCallback? likeOrDislikeCallback,
    VoidCallback? editTaskCallback,
    VoidCallback? restoreTaskCallback,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PopupMenu(
          task: task,
          cancelOrDeleteCallback:
              cancelOrDeleteCallback ?? () {},
          likeOrDislikeCallback:
              likeOrDislikeCallback ?? () {},
          editTaskCallback:
              editTaskCallback ?? () {},
          restoreTaskCallback:
              restoreTaskCallback ?? () {},
        ),
      ),
    );
  }

  // ============================================================
  // BASIC RENDERING
  // ============================================================

  group('PopupMenu - Rendering', () {
    testWidgets(
      'should render PopupMenuButton',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(),
          ),
        );

        expect(
          find.byType(PopupMenuButton),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should initially hide menu items',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(),
          ),
        );

        expect(find.text('Edit'), findsNothing);
        expect(find.text('Delete'), findsNothing);
        expect(find.text('Restore'), findsNothing);
        expect(find.text('Delete Forever'), findsNothing);
      },
    );
  });

  // ============================================================
  // NORMAL TASK
  // ============================================================

  group('PopupMenu - Normal Task', () {
    testWidgets(
      'should show Edit option',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: false,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Edit'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.edit),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show Add to Bookmarks for non-favorite task',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: false,
              isFavorite: false,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.textContaining('Add to'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.bookmark_add_outlined),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show Remove from Bookmarks for favorite task',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: false,
              isFavorite: true,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.textContaining('Remove from'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.bookmark_remove),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show Delete option for normal task',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: false,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Delete'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.delete),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should not show Restore for normal task',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: false,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Restore'),
          findsNothing,
        );

        expect(
          find.text('Delete Forever'),
          findsNothing,
        );
      },
    );
  });

  // ============================================================
  // DELETED TASK
  // ============================================================

  group('PopupMenu - Deleted Task', () {
    testWidgets(
      'should show Restore option',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: true,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Restore'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.restore_from_trash),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should show Delete Forever option',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: true,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Delete Forever'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.delete_forever),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should not show Edit for deleted task',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: true,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Edit'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'should not show bookmark option for deleted task',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: true,
            ),
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        expect(
          find.textContaining('Bookmarks'),
          findsNothing,
        );
      },
    );
  });

  // ============================================================
  // CALLBACKS - NORMAL TASK
  // ============================================================

  group('PopupMenu - Normal Task Callbacks', () {
    testWidgets(
      'should call edit callback',
      (tester) async {
        var called = false;

        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(),
            editTaskCallback: () {
              called = true;
            },
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Edit'),
        );

        await tester.pump();

        expect(
          called,
          isTrue,
        );
      },
    );

    testWidgets(
      'should call bookmark callback',
      (tester) async {
        var called = false;

        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isFavorite: false,
            ),
            likeOrDislikeCallback: () {
              called = true;
            },
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.textContaining('Add to'),
        );

        await tester.pump();

        expect(
          called,
          isTrue,
        );
      },
    );

    testWidgets(
      'should call delete callback',
      (tester) async {
        var called = false;

        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(),
            cancelOrDeleteCallback: () {
              called = true;
            },
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Delete'),
        );

        await tester.pump();

        expect(
          called,
          isTrue,
        );
      },
    );
  });

  // ============================================================
  // CALLBACKS - DELETED TASK
  // ============================================================

  group('PopupMenu - Deleted Task Callbacks', () {
    testWidgets(
      'should call restore callback',
      (tester) async {
        var called = false;

        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: true,
            ),
            restoreTaskCallback: () {
              called = true;
            },
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Restore'),
        );

        await tester.pump();

        expect(
          called,
          isTrue,
        );
      },
    );

    testWidgets(
      'should call delete forever callback',
      (tester) async {
        var called = false;

        await tester.pumpWidget(
          buildTestWidget(
            task: createTask(
              isDeleted: true,
            ),
            cancelOrDeleteCallback: () {
              called = true;
            },
          ),
        );

        await tester.tap(
          find.byType(PopupMenuButton),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Delete Forever'),
        );

        await tester.pump();

        expect(
          called,
          isTrue,
        );
      },
    );
  });
}
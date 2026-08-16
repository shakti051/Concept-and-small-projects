import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_app_firebase/main.dart' as app;
import 'package:task_app_firebase/screens/add_task_screen.dart';
import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Create task successfully after login', (tester) async {
    // ============================================================
    // 1. Clear previous session
    // ============================================================

    final storage = GetStorage();
    await storage.erase();

    // ============================================================
    // 2. Start application
    // ============================================================

    app.main();

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // ============================================================
    // 3. Wait for LoginScreen
    // ============================================================

    await waitForWidget(
      tester,
      find.byType(LoginScreen),
      timeout: const Duration(seconds: 10),
    );

    expect(find.byType(LoginScreen), findsOneWidget);

    // ============================================================
    // 4. Find login fields
    // ============================================================

    final emailField = find.byKey(const Key('login_email_field'));

    final passwordField = find.byKey(const Key('login_password_field'));

    final loginButton = find.byKey(const Key('login_button'));

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    // ============================================================
    // 5. Login
    // ============================================================

    await tester.enterText(emailField, 'user1@gmail.com');

    await tester.enterText(passwordField, '123456');

    await tester.tap(loginButton);

    // Give Firebase authentication/navigation some time.
    await tester.pump(const Duration(seconds: 2));

    // ============================================================
    // 6. Wait for TabsScreen
    // ============================================================

    await waitForWidget(
      tester,
      find.byType(TabsScreen),
      timeout: const Duration(seconds: 20),
    );

    expect(find.byType(TabsScreen), findsOneWidget);

    // Allow TabsScreen initialization and GetAllTask to complete.
    await tester.pump(const Duration(seconds: 2));

    // ============================================================
    // 7. Find FAB
    // ============================================================

    final fab = find.byKey(const Key('add_task_button'));

    expect(fab, findsOneWidget);

    // ============================================================
    // 8. Open AddTaskScreen
    // ============================================================

    await tester.tap(fab);

    // Let bottom sheet animation finish.
    await tester.pump(const Duration(milliseconds: 500));

    // ============================================================
    // 9. Verify AddTaskScreen
    // ============================================================

    expect(find.byType(AddTaskScreen), findsOneWidget);

    expect(find.text('Add Task'), findsOneWidget);

    // ============================================================
    // 10. Find input fields
    // ============================================================

    final titleField = find.byKey(const Key('add_task_title_field'));

    final descriptionField = find.byKey(
      const Key('add_task_description_field'),
    );

    expect(titleField, findsOneWidget);
    expect(descriptionField, findsOneWidget);

    // ============================================================
    // 11. Enter task data
    // ============================================================

    await tester.enterText(titleField, 'Integration Test Task');

    await tester.enterText(
      descriptionField,
      'Task created from integration test',
    );

    // ============================================================
    // 12. Find Add button
    // ============================================================

    final submitButton = find.byKey(const Key('add_task_button_submit'));

    expect(submitButton, findsOneWidget);

    // ============================================================
    // 13. Submit task
    // ============================================================

    await tester.tap(submitButton);

    // Let Navigator.pop() and BLoC event processing happen.
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 500));

    // ============================================================
    // 14. Wait for AddTaskScreen to close
    // ============================================================

    await waitForWidgetToDisappear(
      tester,
      find.byType(AddTaskScreen),
      timeout: const Duration(seconds: 10),
    );

    // ============================================================
    // 15. Wait for task title to appear
    // ============================================================

    await waitForWidget(
      tester,
      find.text('Integration Test Task'),
      timeout: const Duration(seconds: 15),
    );

    expect(find.text('Integration Test Task'), findsOneWidget);

    // ============================================================
    // 16. Expand the task
    // ============================================================

    final taskTitle = find.text('Integration Test Task');

    expect(taskTitle, findsOneWidget);

    await tester.tap(taskTitle);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // ============================================================
    // 17. Verify expanded task description
    // ============================================================

    // Your TasksList uses SelectableText.rich(), so don't use
    // find.text() for the description.

    final selectableTexts = find.byType(SelectableText);

    expect(selectableTexts, findsWidgets);

    bool descriptionFound = false;

    for (final element in selectableTexts.evaluate()) {
      final widget = element.widget;

      if (widget is SelectableText) {
        final text = widget.data;

        if (text != null &&
            text.contains('Task created from integration test')) {
          descriptionFound = true;
          break;
        }
      }
    }

    expect(
      descriptionFound,
      isTrue,
      reason: 'Task description was not found in the expanded task.',
    );

    // ============================================================
    // 18. Verify task description
    // ============================================================

    expect(find.text('Task created from integration test'), findsOneWidget);
  });
}

// ================================================================
// WAIT FOR WIDGET
// ================================================================

Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 250));

    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  throw TestFailure('Timed out waiting for widget: $finder');
}

// ================================================================
// WAIT FOR WIDGET TO DISAPPEAR
// ================================================================

Future<void> waitForWidgetToDisappear(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final endTime = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 250));

    if (finder.evaluate().isEmpty) {
      return;
    }
  }

  throw TestFailure('Timed out waiting for widget to disappear: $finder');
}

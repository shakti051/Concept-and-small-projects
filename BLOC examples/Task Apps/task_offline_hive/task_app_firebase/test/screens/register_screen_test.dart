import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_app_firebase/screens/register_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestWidget() {
    return const MaterialApp(home: RegisterScreen());
  }

  group('RegisterScreen - UI', () {
    testWidgets('should display Register app bar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final appBar = find.byType(AppBar);

      expect(appBar, findsOneWidget);

      expect(
        find.descendant(of: appBar, matching: find.text('Register')),
        findsOneWidget,
      );
    });

    testWidgets('should display email field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.bySemanticsLabel('Insert email'), findsOneWidget);
    });

    testWidgets('should display password field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.bySemanticsLabel('Insert password'), findsOneWidget);
    });

    testWidgets('should display Register button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
    });

    testWidgets('should display two text form fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });

  group('RegisterScreen - Email Validation', () {
    testWidgets('should show email required validation', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));

      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should accept non-empty email', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'test@example.com');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));

      await tester.pump();

      expect(find.text('Email is required'), findsNothing);

      expect(find.text('Password is required'), findsOneWidget);
    });
  });

  group('RegisterScreen - Password Validation', () {
    testWidgets('should show password required validation', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'test@example.com');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));

      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should reject password shorter than 6 characters', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'test@example.com');

      await tester.enterText(fields.at(1), '12345');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));

      await tester.pump();

      expect(
        find.text('Password should be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should accept password with 6 characters', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'test@example.com');

      await tester.enterText(fields.at(1), '123456');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));

      await tester.pump();

      expect(find.text('Email is required'), findsNothing);

      expect(find.text('Password is required'), findsNothing);

      expect(
        find.text('Password should be at least 6 characters'),
        findsNothing,
      );
    });
  });

  group('RegisterScreen - Text Input', () {
    testWidgets('should update email field text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final emailField = find.byType(TextFormField).at(0);

      await tester.enterText(emailField, 'user@example.com');

      final email = tester.widget<TextFormField>(emailField);

      expect(email.controller?.text, 'user@example.com');
    });

    testWidgets('should update password field text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(passwordField, 'password123');

      final password = tester.widget<TextFormField>(passwordField);

      expect(password.controller?.text, 'password123');
    });
  });

  group('RegisterScreen - Form Validation', () {
    testWidgets('should show both validation errors when fields are empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));

      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should have no validation errors for valid input', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'test@example.com');

      await tester.enterText(fields.at(1), '123456');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));

      await tester.pump();

      expect(find.text('Email is required'), findsNothing);

      expect(find.text('Password is required'), findsNothing);

      expect(
        find.text('Password should be at least 6 characters'),
        findsNothing,
      );
    });
  });
}

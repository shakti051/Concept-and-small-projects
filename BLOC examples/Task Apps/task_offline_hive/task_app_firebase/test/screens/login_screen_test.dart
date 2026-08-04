import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_app_firebase/screens/login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // Firebase may already be initialized.
    }
  });

  Widget buildTestWidget() {
    return MaterialApp(home: LoginScreen());
  }

  group('LoginScreen - UI', () {
    testWidgets('should display Login app bar', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
    });

    testWidgets('should display email field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byKey(const Key('login_email_field')), findsOneWidget);
    });

    testWidgets('should display password field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    });

    testWidgets('should display Login button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('should display two text form fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should display Register account button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text("Don't have an Account?"), findsOneWidget);
    });

    testWidgets('should display Forget Password button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Forget Password'), findsOneWidget);
    });
  });

  group('LoginScreen - Email Validation', () {
    testWidgets('should show email required validation', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should not show email required error for non-empty email', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@example.com',
      );

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsNothing);
    });
  });

  group('LoginScreen - Password Validation', () {
    testWidgets('should show password required validation', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@example.com',
      );

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should reject password shorter than 6 characters', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@example.com',
      );

      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '12345',
      );

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(
        find.text('Password should be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should accept password with 6 characters', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@example.com',
      );

      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '123456',
      );

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsNothing);

      expect(find.text('Password is required'), findsNothing);

      expect(
        find.text('Password should be at least 6 characters'),
        findsNothing,
      );
    });
  });

  group('LoginScreen - Form Validation', () {
    testWidgets('should show both validation errors when fields are empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should have no validation errors for valid input', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@example.com',
      );

      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '123456',
      );

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsNothing);

      expect(find.text('Password is required'), findsNothing);

      expect(
        find.text('Password should be at least 6 characters'),
        findsNothing,
      );
    });
  });

  group('LoginScreen - Text Input', () {
    testWidgets('should update email field text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final emailField = find.byKey(const Key('login_email_field'));

      await tester.enterText(emailField, 'user@example.com');

      final email = tester.widget<TextFormField>(emailField);

      expect(email.controller?.text, 'user@example.com');
    });

    testWidgets('should update password field text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final passwordField = find.byKey(const Key('login_password_field'));

      await tester.enterText(passwordField, 'password123');

      final password = tester.widget<TextFormField>(passwordField);

      expect(password.controller?.text, 'password123');
    });
  });

  group('LoginScreen - Button Interaction', () {
    testWidgets('should not attempt login when form is invalid', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);

      expect(find.text('Password is required'), findsOneWidget);
    });
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/register_screen.dart';
import 'package:task_app_firebase/screens/forgot_password_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  group('LoginScreen - Rendering', () {
    testWidgets('should display Login app bar', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display email field', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      expect(find.byKey(const Key('login_email_field')), findsOneWidget);

      expect(find.text('Insert email'), findsOneWidget);
    });

    testWidgets('should display password field', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      expect(find.byKey(const Key('login_password_field')), findsOneWidget);

      expect(find.text('Insert password'), findsOneWidget);
    });

    testWidgets('should display Login button', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      expect(find.byKey(const Key('login_button')), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('should display Register navigation button', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      expect(find.text("Don't have an Account?"), findsOneWidget);
    });

    testWidgets('should display Forgot Password button', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      expect(find.text('Forget Password'), findsOneWidget);
    });
  });

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  group('LoginScreen - Email Validation', () {
    testWidgets('should show email required validation', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should accept non-empty email', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@example.com',
      );

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsNothing);
    });
  });

  // ============================================================
  // PASSWORD VALIDATION
  // ============================================================

  group('LoginScreen - Password Validation', () {
    testWidgets('should show password required validation', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should show password length validation', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

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

    testWidgets('should accept password with six or more characters', (
      tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

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

      expect(
        find.text('Password should be at least 6 characters'),
        findsNothing,
      );
    });
  });

  // ============================================================
  // FORM VALIDATION
  // ============================================================

  group('LoginScreen - Form Validation', () {
    testWidgets('should show both required validation messages', (
      tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should not show validation errors for valid input', (
      tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@example.com',
      );

      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'password123',
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

  // ============================================================
  // TEXT ENTRY
  // ============================================================

  group('LoginScreen - Text Entry', () {
    testWidgets('should update email field text', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'user@gmail.com',
      );

      final field = tester.widget<TextFormField>(
        find.byKey(const Key('login_email_field')),
      );

      expect(field.controller!.text, 'user@gmail.com');
    });

    testWidgets('should update password field text', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'password123',
      );

      final field = tester.widget<TextFormField>(
        find.byKey(const Key('login_password_field')),
      );

      expect(field.controller!.text, 'password123');
    });
  });

  // ============================================================
  // NAVIGATION
  // ============================================================

  group('LoginScreen - Navigation', () {
    testWidgets('should navigate to RegisterScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            RegisterScreen.id: (_) =>
                const Scaffold(body: Text('Register Screen')),
          },
          home: const LoginScreen(),
        ),
      );

      await tester.tap(find.text("Don't have an Account?"));

      await tester.pumpAndSettle();

      expect(find.text('Register Screen'), findsOneWidget);
    });

    testWidgets('should navigate to ForgotPasswordScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            ForgotPasswordScreen.id: (_) =>
                const Scaffold(body: Text('Forgot Password Screen')),
          },
          home: const LoginScreen(),
        ),
      );

      await tester.tap(find.text('Forget Password'));

      await tester.pumpAndSettle();

      expect(find.text('Forgot Password Screen'), findsOneWidget);
    });
  });

  // ============================================================
  // CONTROLLER LIFECYCLE
  // ============================================================

  group('LoginScreen - Lifecycle', () {
    testWidgets('should dispose without errors', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Replacement'))),
      );

      expect(find.text('Replacement'), findsOneWidget);
    });
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app_firebase/screens/forgot_password_screen.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
  });

  tearDown(() {
    reset(mockAuth);
  });

  Widget buildTestWidget() {
    return MaterialApp(home: ForgotPasswordScreen(auth: mockAuth));
  }

  group('ForgotPasswordScreen', () {
    testWidgets('should display Forgot Password app bar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.widgetWithText(AppBar, 'Forgot Password'), findsOneWidget);
    });

    testWidgets('should display email field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(
        find.byKey(const Key('forgot_password_email_field')),
        findsOneWidget,
      );
    });

    testWidgets('should display Reset Password button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byKey(const Key('reset_password_button')), findsOneWidget);

      expect(find.text('Reset Password'), findsOneWidget);
    });

    testWidgets('should have email keyboard type', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final textField = find.byKey(const Key('forgot_password_email_field'));

      expect(textField, findsOneWidget);

      final editableText = tester.widget<EditableText>(
        find.descendant(of: textField, matching: find.byType(EditableText)),
      );

      expect(editableText.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('should show email required error when empty', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byKey(const Key('reset_password_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);

      // Firebase must NOT be called when validation fails.
      verifyNever(
        () => mockAuth.sendPasswordResetEmail(email: any(named: 'email')),
      );
    });

    testWidgets('should not show validation error for valid email', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(
        find.byKey(const Key('forgot_password_email_field')),
        'test@gmail.com',
      );

      await tester.tap(find.byKey(const Key('reset_password_button')));

      await tester.pump();

      expect(find.text('Email is required'), findsNothing);
    });

    testWidgets('should update email field text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      const email = 'test@gmail.com';

      await tester.enterText(
        find.byKey(const Key('forgot_password_email_field')),
        email,
      );

      expect(find.text(email), findsOneWidget);
    });

    testWidgets('should not call Firebase when email is empty', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byKey(const Key('reset_password_button')));

      await tester.pump();

      verifyNever(
        () => mockAuth.sendPasswordResetEmail(email: any(named: 'email')),
      );
    });

    testWidgets('should call Firebase with entered email', (tester) async {
      when(
        () => mockAuth.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(
        find.byKey(const Key('forgot_password_email_field')),
        'test@gmail.com',
      );

      await tester.tap(find.byKey(const Key('reset_password_button')));

      await tester.pump();

      verify(
        () => mockAuth.sendPasswordResetEmail(email: 'test@gmail.com'),
      ).called(1);
    });
  });
}

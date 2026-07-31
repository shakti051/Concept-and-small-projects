import 'package:flutter/foundation.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'User can login with valid credentials',
    (tester) async {
      print('===== TEST START =====');

      final storage = GetStorage();

      // Clear previous login.
      await storage.remove('token');
      await storage.remove('email');

      print('===== STORAGE CLEARED =====');

      // --------------------------------------------------
      // At this point the application should already be
      // running under the integration test runner.
      // --------------------------------------------------

      await tester.pump();

      print('===== INITIAL FRAME =====');

      // --------------------------------------------------
      // SplashScreen waits 2 seconds.
      // --------------------------------------------------

      await tester.pump(
        const Duration(seconds: 2),
      );

      await tester.pump();

      print('===== AFTER SPLASH =====');

      print(
        'LoginScreen count: '
        '${find.byType(LoginScreen).evaluate().length}',
      );

      print(
        'TabsScreen count: '
        '${find.byType(TabsScreen).evaluate().length}',
      );

      expect(
        find.byType(LoginScreen),
        findsOneWidget,
      );

      print('===== LOGIN SCREEN FOUND =====');

      // --------------------------------------------------
      // Find controls
      // --------------------------------------------------

      final emailField = find.byKey(
        const Key('login_email_field'),
      );

      final passwordField = find.byKey(
        const Key('login_password_field'),
      );

      final loginButton = find.byKey(
        const Key('login_button'),
      );

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      print('===== LOGIN CONTROLS FOUND =====');

      // --------------------------------------------------
      // Enter credentials
      // --------------------------------------------------

      await tester.enterText(
        emailField,
        'user1@gmail.com',
      );

      print('===== EMAIL ENTERED =====');

      await tester.enterText(
        passwordField,
        '123456',
      );

      print('===== PASSWORD ENTERED =====');

      // --------------------------------------------------
      // Login
      // --------------------------------------------------

      await tester.tap(loginButton);

      print('===== LOGIN BUTTON TAPPED =====');

      // Process button callback.
      await tester.pump();

      // Give Firebase authentication time.
      await tester.pump(
        const Duration(seconds: 5),
      );

      await tester.pump();

      print('===== FIREBASE WAIT COMPLETED =====');

      // --------------------------------------------------
      // Verify navigation
      // --------------------------------------------------

      print(
        'LoginScreen count: '
        '${find.byType(LoginScreen).evaluate().length}',
      );

      print(
        'TabsScreen count: '
        '${find.byType(TabsScreen).evaluate().length}',
      );

      print(
        'Stored token: '
        '${storage.read("token")}',
      );

      print(
        'Stored email: '
        '${storage.read("email")}',
      );

      expect(
        find.byType(TabsScreen),
        findsOneWidget,
      );

      expect(
        storage.read('token'),
        isNotNull,
      );

      expect(
        storage.read('email'),
        'user1@gmail.com',
      );

      print('===== LOGIN TEST PASSED =====');
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_app_firebase/main.dart' as app;
import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/register_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Register new user and login successfully', (tester) async {
    // ============================================================
    // 1. Clear previous login session
    // ============================================================

    final storage = GetStorage();

    await storage.erase();

    // ============================================================
    // 2. Start application
    // ============================================================

    app.main();

    // Give main() time to initialize Firebase, Hive,
    // Workmanager, GetIt and the application.
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));

    // ============================================================
    // 3. Wait for SplashScreen -> LoginScreen
    // ============================================================

    await waitForWidget(
      tester,
      find.byType(LoginScreen),
      timeout: const Duration(seconds: 10),
    );

    expect(find.byType(LoginScreen), findsOneWidget);

    // ============================================================
    // 4. Navigate Login -> Register
    // ============================================================

    final registerNavigationButton = find.byKey(
      const Key('register_navigation_button'),
    );

    expect(registerNavigationButton, findsOneWidget);

    await tester.tap(registerNavigationButton);

    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);

    // ============================================================
    // 5. Create unique Firebase user
    // ============================================================

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final email = 'integration_test_$timestamp@test.com';

    const password = 'Test@123456';

    // ============================================================
    // 6. Fill registration form
    // ============================================================

    final emailField = find.byType(TextFormField).at(0);

    final passwordField = find.byType(TextFormField).at(1);

    await tester.enterText(emailField, email);

    await tester.enterText(passwordField, password);

    // ============================================================
    // 7. Tap Register
    // ============================================================

    final registerButton = find.byKey(const Key('register_button'));

    expect(registerButton, findsOneWidget);

    await tester.tap(registerButton);

    // ============================================================
    // 8. Wait for Firebase registration
    // ============================================================

    await waitForWidget(
      tester,
      find.byType(LoginScreen),
      timeout: const Duration(seconds: 15),
    );

    expect(find.byType(LoginScreen), findsOneWidget);

    // ============================================================
    // 9. Login with newly created account
    // ============================================================

    final loginEmailField = find.byKey(const Key('login_email_field'));

    final loginPasswordField = find.byKey(const Key('login_password_field'));

    expect(loginEmailField, findsOneWidget);

    expect(loginPasswordField, findsOneWidget);

    await tester.enterText(loginEmailField, email);

    await tester.enterText(loginPasswordField, password);

    // ============================================================
    // 10. Tap Login
    // ============================================================

    final loginButton = find.byKey(const Key('login_button'));

    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);

    // ============================================================
    // 11. Wait for TabsScreen
    // ============================================================

    await waitForWidget(
      tester,
      find.byType(TabsScreen),
      timeout: const Duration(seconds: 20),
    );

    // ============================================================
    // 12. Verify successful login
    // ============================================================

    expect(find.byType(TabsScreen), findsOneWidget);
  });
}

///
/// Wait until a widget appears.
///
/// This is more reliable than using pumpAndSettle()
/// for integration tests involving Firebase, Firestore,
/// Workmanager, timers and BLoC streams.
///
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

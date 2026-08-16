import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integration_test/integration_test.dart';

import 'package:task_app_firebase/main.dart' as app;
import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';

void main() {
IntegrationTestWidgetsFlutterBinding.ensureInitialized();

testWidgets('Login existing user successfully', (tester) async {
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
// 4. Find login fields
// ============================================================

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

// ============================================================
// 5. Enter credentials
// ============================================================

await tester.enterText(
  emailField,
  'user1@gmail.com',
);

await tester.enterText(
  passwordField,
  '123456',
);

// ============================================================
// 6. Tap Login
// ============================================================

await tester.tap(loginButton);

// Allow Firebase authentication to start.
await tester.pump();

// ============================================================
// 7. Wait for TabsScreen
// ============================================================

await waitForWidget(
  tester,
  find.byType(TabsScreen),
  timeout: const Duration(seconds: 20),
);

// ============================================================
// 8. Verify successful login
// ============================================================

expect(
  find.byType(TabsScreen),
  findsOneWidget,
);


});
}

///
/// Wait until a widget appears.
///
/// This is more reliable than pumpAndSettle() for integration
/// tests involving Firebase, Firestore, Workmanager, timers
/// and BLoC streams.
///
Future<void> waitForWidget(
WidgetTester tester,
Finder finder, {
Duration timeout = const Duration(seconds: 10),
}) async {
final endTime = DateTime.now().add(timeout);

while (DateTime.now().isBefore(endTime)) {
await tester.pump(
const Duration(milliseconds: 250),
);


if (finder.evaluate().isNotEmpty) {
  return;
}


}

throw TestFailure(
'Timed out waiting for widget: $finder',
);
}

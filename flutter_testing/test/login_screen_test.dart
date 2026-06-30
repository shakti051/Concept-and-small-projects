
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/login_screen.dart';

void main(){
  testWidgets("Should have a title",(WidgetTester tester) async {
     await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    // ACT
    Finder title = find.byKey(const ValueKey('title'));

    // Assert
    expect(title, findsOneWidget);
  });


  testWidgets("Should have one text field form to collect user email id",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    // ACT
    Finder userNameTextField = find.byKey(const ValueKey("email_id"));

    // Assert
    expect(userNameTextField, findsOneWidget);
  });

  testWidgets("Should have one text field form to collect Password",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    // ACT
    Finder passwordTextField = find.byKey(const ValueKey("password"));

    // Assert
    expect(passwordTextField, findsOneWidget);
  });

testWidgets("Should have one login button", (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    // ACT
    Finder loginButton = find.byType(ElevatedButton);

    // Assert
    expect(loginButton, findsOneWidget );
  });

  testWidgets(
      "Should show Required Fields error message if user email id & password is empty",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    // ACT
    Finder loginButton = find.byType(ElevatedButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    Finder errorTexts = find.text("Required Field");

    //ASSERT
    expect(errorTexts, findsNWidgets(2));
  });

   testWidgets("Should submit form when user email id & password is valid",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    // ACT
    Finder userNameTextField = find.byKey(const ValueKey("email_id"));
    Finder passwordTextField = find.byKey(const ValueKey("password"));
    await tester.enterText(userNameTextField, "richa@gmail.com");
    await tester.enterText(passwordTextField, "password");

    Finder loginButton = find.byType(ElevatedButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    Finder errorTexts = find.text("Required Field");

    //ASSERT
    expect(errorTexts, findsNothing);
  });
  
}
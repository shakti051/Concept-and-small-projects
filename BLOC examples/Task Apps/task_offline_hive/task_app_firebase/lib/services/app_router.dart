import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'router_exports.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RecycleBin.id:
        return MaterialPageRoute(
          builder: (_) => const RecycleBin(),
        );

      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (_) => const TabsScreen(),
        );

      case RegisterScreen.id:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(
            auth: FirebaseAuth.instance,
          ),
        );

      case LoginScreen.id:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(
            auth: FirebaseAuth.instance,
          ),
        );

      case ForgotPasswordScreen.id:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(
            auth: FirebaseAuth.instance,
          ),
        );

      default:
        return null;
    }
  }
}
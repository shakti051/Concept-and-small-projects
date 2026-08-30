import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_app_firebase/blocs/bloc_exports.dart';
import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';
import 'package:task_app_firebase/services/locator.dart';

import '../extensions/locater_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetStorage _getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    _openNext();
  }

  Future<void> _openNext() async {
    // Give Firebase time to restore the authentication session.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // ============================================================
    // 1. Check Firebase authenticated user
    // ============================================================

    final user = FirebaseAuth.instance.currentUser;

    if (user == null ||
        user.email == null ||
        user.email!.trim().isEmpty) {
      debugPrint('SPLASH: No authenticated user');

      await _getStorage.remove('token');
      await _getStorage.remove('email');

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        LoginScreen.id,
      );

      return;
    }

    // ============================================================
    // 2. Get authenticated user's email
    // ============================================================

    final email = user.email!.trim().toLowerCase();

    debugPrint('SPLASH: Existing user found: $email');

    try {
      // ============================================================
      // 3. Restore GetStorage session
      // ============================================================

      await _getStorage.write(
        'token',
        user.uid,
      );

      await _getStorage.write(
        'email',
        email,
      );

      // ============================================================
      // 4. Setup user-specific dependencies
      //
      // This registers:
      // - HiveTaskDataSource
      // - TaskRepository
      // - SyncService
      // ============================================================

      debugPrint('SPLASH: Setting up user locator...');

      await setupUserLocator(email);

      debugPrint('SPLASH: User locator ready');

      // ============================================================
      // 5. Create ONE TasksBloc
      // ============================================================

      final tasksBloc = createTasksBloc(context);

      debugPrint(
        'SPLASH: TasksBloc created '
        '${identityHashCode(tasksBloc)}',
      );

      if (!mounted) {
        await tasksBloc.close();
        return;
      }

      // ============================================================
      // 6. Navigate with the SAME TasksBloc instance
      // ============================================================

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: tasksBloc,
            child: const TabsScreen(),
          ),
        ),
      );
    } catch (e, stack) {
      debugPrint('SPLASH: Failed to restore user session');
      debugPrint('ERROR: $e');
      debugPrint('$stack');

      if (!mounted) return;

      await _getStorage.remove('token');
      await _getStorage.remove('email');

      Navigator.of(context).pushReplacementNamed(
        LoginScreen.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

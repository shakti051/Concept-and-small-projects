import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import 'package:task_app_firebase/services/locator.dart';
import 'package:task_app_firebase/widgets/connectivity_listner.dart';

import '../blocs/bloc_exports.dart';
import '../core/logger/logger.dart';
import '../respository/task_repository.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../screens/recycle_bin.dart';
import '../screens/tabs_screen.dart';
import 'retry_scheduler.dart';
import 'sync_queue.dart';
import 'sync_schedular.dart';
import 'sync_service.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RecycleBin.id:
        return MaterialPageRoute(builder: (_) => const RecycleBin());

      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => TasksBloc(
                context.read<ConnectivityBloc>(),
                getIt<TaskRepository>(),
                getIt<SyncQueue>(),
                getIt<LoggerService>(),
                getIt<SyncScheduler>(),
                getIt<RetryScheduler>(),
                getIt<SyncService>(),
              ),
              child: const ConnectivityListener(child: TabsScreen()),
            );
          },
        );
      case RegisterScreen.id:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(auth: FirebaseAuth.instance),
        );

      case LoginScreen.id:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(auth: FirebaseAuth.instance),
        );

      case ForgotPasswordScreen.id:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(auth: FirebaseAuth.instance),
        );

      default:
        return null;
    }
  }
}

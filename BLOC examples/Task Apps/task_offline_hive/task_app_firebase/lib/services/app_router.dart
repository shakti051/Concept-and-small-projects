import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'router_exports.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RecycleBin.id:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => _createTasksBloc(context),
              child: const RecycleBin(),
            );
          },
        );

      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => _createTasksBloc(context),
              child: const ConnectivityListener(
                child: TabsScreen(),
              ),
            );
          },
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

  TasksBloc _createTasksBloc(BuildContext context) {
    return TasksBloc(
      context.read<ConnectivityBloc>(),
      getIt<TaskRepository>(),
      getIt<SyncQueue>(),
      getIt<LoggerService>(),
      getIt<SyncScheduler>(),
      getIt<RetryScheduler>(),
      getIt<SyncService>(),
    );
  }
}
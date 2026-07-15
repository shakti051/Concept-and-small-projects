import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/respository/task_repository.dart';
import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/register_screen.dart';
import 'package:task_app_firebase/screens/splash_screen.dart';
import 'package:task_app_firebase/services/locator.dart';
import 'package:task_app_firebase/services/sync_service.dart';
import 'package:task_app_firebase/widgets/connectivity_listner.dart';
import 'blocs/bloc_exports.dart';
import 'models/task.dart';
import 'screens/tabs_screen.dart';
import 'services/app_router.dart';
import 'services/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:workmanager/workmanager.dart';

//flutter pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupLocator();

  // Register Hive adapters
  Hive.registerAdapter(SyncStatusAdapter());
  Hive.registerAdapter(TaskAdapter());

  // Open Hive boxes
  await Hive.openBox<Task>('tasks');
  // Testing only
  //await Hive.box<Task>(HiveBoxes.tasks).clear();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await Workmanager().initialize(callbackDispatcher);

    await Workmanager().registerPeriodicTask(
      "taskSync",
      "syncPendingTasks",
      frequency: const Duration(minutes: 15),
    );
  }

  runApp(MyApp(appRouter: AppRouter()));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await setupLocator();

    // await getIt<SyncService>().syncPendingCreate();

    return true;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ConnectivityBloc(Connectivity())..add(ObserveConnectivity()),
        ),
        BlocProvider(
          create: (context) => TasksBloc(
            context.read<ConnectivityBloc>(),
            getIt<TaskRepository>(),
          ),
        ),
        BlocProvider(create: (context) => SwitchBloc()),
      ],
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Tasks App',
            theme: state.switchValue
                ? AppThemes.appThemeData[AppTheme.darkTheme]
                : AppThemes.appThemeData[AppTheme.lightTheme],
            builder: (context, child) {
              return ConnectivityListener(child: child!);
            },
            home: SplashScreen(), //const TabsScreen(),
            onGenerateRoute: appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/respository/task_repository.dart';
import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/register_screen.dart';
import 'package:task_app_firebase/screens/splash_screen.dart';
import 'package:task_app_firebase/services/locator.dart';
import 'package:task_app_firebase/services/retry_scheduler.dart';
import 'package:task_app_firebase/services/sync_queue.dart';
import 'package:task_app_firebase/services/sync_schedular.dart';
import 'package:task_app_firebase/services/sync_service.dart';
import 'package:task_app_firebase/widgets/connectivity_listner.dart';
import 'package:task_app_firebase/workmanager/callback_dispatcher.dart';
import 'blocs/bloc_exports.dart';
import 'core/logger/logger.dart';
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
//adb tcpip 5555
//restarting in TCP mode port: 5555
//Disconnect the USB cable.
//adb connect 192.168.1.33:5555

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint("1 Firebase");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint("2 Workmanager");

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    }

   // debugPrint("3 GetIt");
    //await setupLocator();

    debugPrint("4 Hive");
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SyncStatusAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }
    // Hive.registerAdapter(TaskAdapter());

    // Hive.registerAdapter(SyncStatusAdapter());

 //   await Hive.openBox<Task>(HiveBoxes.tasks);

    debugPrint("5 Register Worker");

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await Workmanager().registerOneOffTask(
        "backgroundSyncTest",
        "backgroundSync",
        constraints: Constraints(networkType: NetworkType.connected),
        initialDelay: const Duration(seconds: 5),
      );
      await Workmanager().registerPeriodicTask(
        "backgroundSync",
        "backgroundSync",
        frequency: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.connected),
      );
    }
    
    debugPrint("6 runApp");
    runApp(MyApp(appRouter: AppRouter()));
  } catch (e, stack) {
    debugPrint(e.toString());
    debugPrint(stack.toString());
  }
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
        
        BlocProvider(create: (context) => SwitchBloc()),
      ],
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeAnimationDuration: const Duration(milliseconds: 400),
            themeAnimationCurve: Curves.easeInOut,
            title: 'Flutter Tasks App',
            theme: state.switchValue
                ? AppThemes.appThemeData[AppTheme.darkTheme]
                : AppThemes.appThemeData[AppTheme.lightTheme],
            // builder: (context, child) {
            //   return ConnectivityListener(child: child!);
            // },
            home: SplashScreen(), //const TabsScreen(),
            onGenerateRoute: appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
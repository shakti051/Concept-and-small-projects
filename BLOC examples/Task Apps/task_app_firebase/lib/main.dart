import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/register_screen.dart';
import 'package:task_app_firebase/screens/splash_screen.dart';
import 'blocs/bloc_exports.dart';
import 'screens/tabs_screen.dart';
import 'services/app_router.dart';
import 'services/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize Hydrated Storage properly for all platforms
  final storage = await _initStorage();
  HydratedBloc.storage = storage;  
  runApp(MyApp(appRouter: AppRouter()));
}

Future<HydratedStorage> _initStorage() async {
  if (kIsWeb) {
    // ✅ Web uses browser storage (no path_provider)
    return await HydratedStorage.build(storageDirectory: HydratedStorage.webStorageDirectory);    
  } else {
    final dir = await getApplicationDocumentsDirectory();
    return await HydratedStorage.build(
      storageDirectory: dir,
    );
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
        BlocProvider(create: (context) => TasksBloc()),
        BlocProvider(create: (context) => SwitchBloc()),
      ],
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Tasks App',
            theme: state.switchValue
                ? AppThemes.appThemeData[AppTheme.darkTheme]
                : AppThemes.appThemeData[AppTheme.lightTheme],
            home: SplashScreen(),//const TabsScreen(),
            onGenerateRoute: appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}

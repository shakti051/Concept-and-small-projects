import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app1/blocs/tasks/tasks_bloc.dart';
import 'package:task_app1/models/task.dart';
import 'package:task_app1/screens/tabs_screen.dart';
import 'package:task_app1/services/app_router.dart';
import 'package:task_app1/services/app_theme.dart';
import 'blocs/blocs.dart';
import 'screens/pending_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hydrated Storage properly for all platforms
  final storage = await _initStorage();
  HydratedBloc.storage = storage;
  runApp(MyApp(appRouter: AppRouter()));
}

Future<HydratedStorage> _initStorage() async {
  if (kIsWeb) {
    // ✅ Web uses browser storage (no path_provider)
    return await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory.web,
    );
  } else {
    final dir = await getApplicationDocumentsDirectory();
    return await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.appRouter});
  AppRouter appRouter;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ConnectivityBloc(
            Connectivity(),
          )..add(ObserveConnectivity()),
        ),
        BlocProvider(create: (context) => TasksBloc()),
        BlocProvider(create: (context) => SwitchBloc()),
      ],
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Tasks App',
            theme: state.switchValue
                ? AppThemes.appThemeData[AppTheme.darkTheme]
                : AppThemes.appThemeData[AppTheme.lightTheme],
            home: TabsScreen(),
            onGenerateRoute: appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}





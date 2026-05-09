import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app1/blocs/tasks/tasks_bloc.dart';
import 'package:task_app1/models/task.dart';
import 'package:task_app1/services/app_router.dart';
import 'screens/tasks_screen.dart';
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
     return await HydratedStorage.build(storageDirectory: HydratedStorageDirectory.web);
  } else {
    final dir = await getApplicationDocumentsDirectory();
    return await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  }
}

class MyApp extends StatelessWidget {
 MyApp({super.key,required this.appRouter });
  AppRouter appRouter;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TasksBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Tasks App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: TasksScreen(),
        onGenerateRoute:appRouter.onGenerateRoute
      ),
    );
  }
}

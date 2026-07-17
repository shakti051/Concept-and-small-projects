import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app_firebase/firebase_options.dart';
import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/hive_boxes.dart';
import '../models/task.dart';
import '../data/local/hive_task_datasource.dart';
import '../respository/task_repository.dart';
import '../services/sync_service.dart';



@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    print("WORKER STARTED: $taskName");

    WidgetsFlutterBinding.ensureInitialized();

    try {
      print("Firebase init started");

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      print("Firebase initialized");

      await GetStorage.init();

      print("GetStorage initialized");

      final dir = await getApplicationDocumentsDirectory();

      Hive.init(dir.path);

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(SyncStatusAdapter());
      }

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TaskAdapter());
      }

      print("Hive initialized");

      await Hive.openBox<Task>(HiveBoxes.tasks);

      print("Hive box opened");

      final repository = TaskRepository(HiveTaskDataSource());

      final tasks = await repository.getAll();

      print("LOCAL TASK COUNT: ${tasks.length}");

      final syncService = SyncService(repository);

      await syncService.sync(tasks);

      print("SYNC COMPLETED");

      return true;
    } catch (e, stack) {
      print("WORKER ERROR: $e");
      print(stack.toString());

      return false;
    }
  });
}

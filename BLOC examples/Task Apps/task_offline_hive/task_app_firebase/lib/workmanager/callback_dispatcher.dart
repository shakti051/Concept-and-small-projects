import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/data/local/hive_task_datasource.dart';
import 'package:task_app_firebase/firebase_options.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/respository/task_repository.dart';
import 'package:task_app_firebase/services/sync_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    debugPrint('========================================');
    debugPrint('WORKER STARTED: $taskName');
    debugPrint('========================================');

    WidgetsFlutterBinding.ensureInitialized();

    try {
      // ------------------------------------------------------------
      // 1. Initialize GetStorage first
      // ------------------------------------------------------------

      await GetStorage.init();

      debugPrint('GetStorage initialized');

      // ------------------------------------------------------------
      // 2. Get logged-in user's email
      //
      // Priority:
      //    inputData['email']
      //    ↓
      //    GetStorage().read('email')
      //
      // This allows the worker to work even when the task was
      // registered without inputData.
      // ------------------------------------------------------------

      final inputEmail = inputData?['email'] as String?;

      final storedEmail = GetStorage().read<String>('email');

      final email = inputEmail ?? storedEmail;

      if (email == null || email.trim().isEmpty) {
        debugPrint('WORKER ERROR: email missing');
        return false;
      }

      final normalizedEmail = email.trim().toLowerCase();

      debugPrint('SYNC USER: $normalizedEmail');

      // ------------------------------------------------------------
      // 3. Initialize Firebase
      // ------------------------------------------------------------

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      debugPrint('Firebase initialized');

      // ------------------------------------------------------------
      // 4. Initialize Hive
      // ------------------------------------------------------------

      final dir = await getApplicationDocumentsDirectory();

      if (!Hive.isBoxOpen(HiveBoxes.tasks(normalizedEmail))) {
        if (!Hive.isAdapterRegistered(0) ||
            !Hive.isAdapterRegistered(1)) {
          Hive.init(dir.path);
        } else if (!Hive.isBoxOpen(HiveBoxes.tasks(normalizedEmail))) {
          Hive.init(dir.path);
        }
      }

      // ------------------------------------------------------------
      // 5. Register Hive adapters
      // ------------------------------------------------------------

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(SyncStatusAdapter());
      }

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TaskAdapter());
      }

      // ------------------------------------------------------------
      // 6. Open user's own Hive box
      // ------------------------------------------------------------

      final boxName = HiveBoxes.tasks(normalizedEmail);

      debugPrint('Opening Hive box: $boxName');

      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<Task>(boxName);
      }

      debugPrint('Hive box opened: $boxName');

      // ------------------------------------------------------------
      // 7. Create repository using the SAME user's email
      // ------------------------------------------------------------

      final repository = TaskRepository(
        HiveTaskDataSource(normalizedEmail),
      );

      // ------------------------------------------------------------
      // 8. Read ONLY this user's local tasks
      // ------------------------------------------------------------

      final tasks = await repository.getAll();

      debugPrint(
        'LOCAL TASK COUNT for $normalizedEmail: ${tasks.length}',
      );

      // ------------------------------------------------------------
      // 9. Sync ONLY this user's tasks
      // ------------------------------------------------------------

      final syncService = SyncService(repository);

      await syncService.sync(tasks);

      debugPrint('SYNC COMPLETED for $normalizedEmail');

      return true;
    } catch (e, stack) {
      debugPrint('========================================');
      debugPrint('WORKER ERROR: $e');
      debugPrint(stack.toString());
      debugPrint('========================================');

      return false;
    }
  });
}

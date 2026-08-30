import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/data/local/hive_task_datasource.dart';
import 'package:task_app_firebase/firebase_options.dart';
import 'package:task_app_firebase/models/task.dart';
import 'package:task_app_firebase/services/sync_service.dart';
import 'package:workmanager/workmanager.dart';

import '../respository/task_repository.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    debugPrint('========================================');
    debugPrint('WORKER STARTED: $taskName');
    debugPrint('========================================');

    WidgetsFlutterBinding.ensureInitialized();

    try {
      // ============================================================
      // 1. Initialize GetStorage
      // ============================================================

      await GetStorage.init();

      debugPrint('GetStorage initialized');

      // ============================================================
      // 2. Get user's email
      //
      // Priority:
      // inputData['email']
      //        ↓
      // GetStorage['email']
      // ============================================================

      final inputEmail = inputData?['email'] as String?;

      final storedEmail = GetStorage().read<String>('email');

      final email = inputEmail ?? storedEmail;

      if (email == null || email.trim().isEmpty) {
        debugPrint('WORKER ERROR: email missing');
        return false;
      }

      final normalizedEmail = email.trim().toLowerCase();

      debugPrint('SYNC USER: $normalizedEmail');

      // ============================================================
      // 3. Initialize Firebase
      // ============================================================

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      debugPrint('Firebase initialized');

      // ============================================================
      // 4. Initialize Hive
      // ============================================================

      final dir = await getApplicationDocumentsDirectory();

      if (!Hive.isBoxOpen(HiveBoxes.tasks(normalizedEmail))) {
        if (!Hive.isAdapterRegistered(0) ||
            !Hive.isAdapterRegistered(1)) {
          if (!Hive.isBoxOpen(HiveBoxes.tasks(normalizedEmail))) {
            Hive.init(dir.path);
          }
        } else {
          if (!Hive.isBoxOpen(HiveBoxes.tasks(normalizedEmail))) {
            Hive.init(dir.path);
          }
        }
      }

      // ============================================================
      // 5. Register Hive adapters
      // ============================================================

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(
          SyncStatusAdapter(),
        );
      }

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(
          TaskAdapter(),
        );
      }

      // ============================================================
      // 6. Open user's Hive box
      // ============================================================

      final boxName = HiveBoxes.tasks(normalizedEmail);

      debugPrint('Opening Hive box: $boxName');

      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<Task>(boxName);
      }

      debugPrint('Hive box opened: $boxName');

      // ============================================================
      // 7. Create user-specific repository
      // ============================================================

      final hiveDataSource = HiveTaskDataSource(
        normalizedEmail,
      );

      final repository = TaskRepository(
        hiveDataSource,
      );

      // ============================================================
      // 8. Read local tasks
      // ============================================================

      final tasks = await repository.getAll();

      debugPrint(
        'LOCAL TASK COUNT for $normalizedEmail: ${tasks.length}',
      );

      // ============================================================
      // 9. Sync with Firebase
      // ============================================================

      final syncService = SyncService(
        repository,
      );

      await syncService.sync(tasks);

      debugPrint(
        'SYNC COMPLETED for $normalizedEmail',
      );

      debugPrint('========================================');
      debugPrint('WORKER FINISHED SUCCESSFULLY');
      debugPrint('========================================');

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

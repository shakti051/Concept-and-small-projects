import 'package:get_it/get_it.dart';

import '../respository/task_repository.dart';
import 'sync_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepository());
  getIt.registerLazySingleton<SyncService>(
    () => SyncService(getIt<TaskRepository>()),
  );
}

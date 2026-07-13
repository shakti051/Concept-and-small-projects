import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import '../respository/task_repository.dart';
import 'sync_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepository());
  getIt.registerLazySingleton<SyncService>(
    () => SyncService(getIt<TaskRepository>()),
  );
   getIt.registerLazySingleton<Uuid>(
    () => const Uuid(),
  );
}

import 'package:get_it/get_it.dart';
import 'package:task_app_firebase/data/local/hive_task_datasource.dart';
import 'package:uuid/uuid.dart';
import '../core/logger/logger.dart';
import '../respository/task_repository.dart';
import 'sync_queue.dart';
import 'sync_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<HiveTaskDataSource>(() => HiveTaskDataSource());

  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepository(getIt<HiveTaskDataSource>()),
  );
  
  getIt.registerLazySingleton<SyncService>(
    () => SyncService(getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<Uuid>(() => const Uuid());
 getIt.registerLazySingleton<SyncQueue>(
  () => SyncQueue(),
);
getIt.registerLazySingleton<LoggerService>(
  () => const LoggerService(),
); 
}

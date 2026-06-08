
import 'package:get_it/get_it.dart';
import 'package:task_repository/task_repository.dart';

final lc = GetIt.instance;

void initializeDependencies() {
  lc.registerLazySingleton(() => TaskRepository());
}

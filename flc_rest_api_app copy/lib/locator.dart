import 'package:api_client/api_client.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:notifications_repo/notifications_repo.dart';
import 'package:prefs_storage/prefs_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final lc = GetIt.instance;

//initialize repos/services so we can use those initialized values in
//anywhere in our app
Future<void> initializeDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  lc
    ..registerLazySingleton(() => PrefsStorage(prefs))
    ..registerLazySingleton(ApiClient.new)
    ..registerLazySingleton(() => AuthRepo(lc(), lc()))
    ..registerLazySingleton(() => NotificationsRepo(lc(), lc()));
}

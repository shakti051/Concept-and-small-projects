import 'package:get/get.dart';
import 'package:shurtech_interview/database_helper.dart';
import 'package:shurtech_interview/hive_service.dart';
import 'api_service.dart';
import 'model.dart';


class UserController extends GetxController {
  final UserApiService _apiService = UserApiService();

  var users = <User>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    //loadUsersFromDB();
    loadFromHive();
    fetchUsers();
    super.onInit();
  }

  Future<void> loadUsersFromDB() async {
    final data = await DBHelper.getUsers();
    users.value = data.map((e) => User.fromMap(e)).toList();
  }

  void loadFromHive() {
    final data = UserHiveService.getUsers();
    users.value = data.map((e) => User.fromMap(e)).toList();
  }

  
  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      error('');
      //users.value = await _apiService.fetchUsers();
     await _apiService.fetchUsers();
    loadFromHive();
    //   await loadUsersFromDB(); // refresh UI
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }
}

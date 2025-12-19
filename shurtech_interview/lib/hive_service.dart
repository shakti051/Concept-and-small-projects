import 'package:hive/hive.dart';

class UserHiveService {
  static final Box _box = Hive.box('usersBox');

  static Future<void> saveUsers(List<Map<String, dynamic>> users) async {
    await _box.put('users', users);
  }

  static List<Map<String, dynamic>> getUsers() {
    final data = _box.get('users');
    return data != null ? List<Map<String, dynamic>>.from(data) : [];
  }

}

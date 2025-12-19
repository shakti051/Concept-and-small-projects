import 'package:shurtech_interview/hive_service.dart';
import 'dio_client.dart';
import 'model.dart';

class UserApiService {
  Future<void> fetchUsers() async {
    try {
      final response = await DioClient.dio.get('/users');
       final List data = response.data;

    final users =
        data.map((e) => User.fromJson(e).toMap()).toList();
      await UserHiveService.saveUsers(users);
    //await DBHelper.insertUsers(users);
      // return (response.data as List)
      //     .map((e) => User.fromJson(e))
      //     .toList();
    } catch (e) {
      throw Exception('Failed to fetch users');
    }
  }
}

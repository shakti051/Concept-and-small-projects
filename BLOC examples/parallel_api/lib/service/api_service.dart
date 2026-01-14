import 'package:dio/dio.dart';
import 'package:parallel_api/models/post.dart';
import 'package:parallel_api/service/dio_client.dart';
import 'package:parallel_api/service/dio_error_handler.dart';

import '../models/user.dart';

class ApiService {
  late final Dio dio = DioClient().dio;

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await dio.get('/posts');
      return (response.data as List)
          .map((e) => Post.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<List<User>> fetchUsers() async {
    try {
      final response = await dio.get('/users');
      return (response.data as List)
          .map((e) => User.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}

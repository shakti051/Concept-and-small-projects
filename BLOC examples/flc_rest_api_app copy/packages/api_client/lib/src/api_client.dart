import 'package:api_client/src/models/data_state.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final baseOptions = BaseOptions(
    validateStatus: (status) => status! < 400,
    headers: {'content-Type': 'application/json', 'accept': 'application/json'},
    connectTimeout: const Duration(seconds: 4),
  );

  Future<DataState<Response<dynamic>?>> getReq(String path,
      {String? token}) async {
    try {
      final dio = Dio(baseOptions);
      if (token != null) {
        dio.options.headers['authorization'] = 'Bearer $token';
      }
      final response = await dio.get<dynamic>(path);
      return DataSuccess(response);
    } on DioException catch (e) {
      return DataFailed(DataError(e.response?.statusCode, e.response?.data));
    } catch (e) {
      return DataFailed(DataError(null, e));
    }
  }

  Future<DataState<Response<dynamic>?>> postReq(
    String path, {
    Map<String, dynamic>? bodyJson,
    String? token,
  }) async {
    try {
      final dio = Dio(baseOptions);
      if (token != null) {
        dio.options.headers['authorization'] = 'Bearer $token';
      }
      final response = await dio.post<dynamic>(path, data: bodyJson);
      return DataSuccess(response);
    } on DioException catch (e) {
      return DataFailed(DataError(e.response?.statusCode, e.response?.data));
    } catch (e) {
      return DataFailed(DataError(null, e));
    }
  }
}

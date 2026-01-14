import 'package:dio/dio.dart';

class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://jsonplaceholder.typicode.com",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 👉 Add token, headers, logging
          options.headers["Authorization"] = "Bearer TOKEN";
          print("REQUEST ➜ ${options.uri}");
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("RESPONSE ✔ ${response.statusCode}");
          handler.next(response);
        },
        onError: (DioException e, handler) {
          print("ERROR ❌ ${e.message}");
          handler.next(e);
        },
      ),
    );
  }

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late Dio _dio;

  Dio get dio => _dio;
}

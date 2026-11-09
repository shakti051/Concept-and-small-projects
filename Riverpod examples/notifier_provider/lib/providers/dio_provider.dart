import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://bored-api.appbrewery.com/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  // Add custom interceptor
  dio.interceptors.add(
    AppInterceptor(),
  );

  return dio;
}

class AppInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.extra['startTime'] = DateTime.now();

    debugPrint('========== API REQUEST ==========');
    debugPrint('URL: ${options.uri}');
    debugPrint('METHOD: ${options.method}');
    debugPrint('HEADERS: ${options.headers}');
    debugPrint('QUERY PARAMETERS: ${options.queryParameters}');
    debugPrint('BODY: ${options.data}');
    debugPrint('=================================');

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final startTime =
        response.requestOptions.extra['startTime'] as DateTime?;

    final duration = startTime == null
        ? null
        : DateTime.now().difference(startTime).inMilliseconds;

    debugPrint('========== API RESPONSE ==========');
    debugPrint('URL: ${response.requestOptions.uri}');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('DURATION: ${duration ?? 'Unknown'} ms');
    debugPrint('DATA: ${response.data}');
    debugPrint('==================================');

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final startTime =
        err.requestOptions.extra['startTime'] as DateTime?;

    final duration = startTime == null
        ? null
        : DateTime.now().difference(startTime).inMilliseconds;

    debugPrint('========== API ERROR ==========');
    debugPrint('URL: ${err.requestOptions.uri}');
    debugPrint('METHOD: ${err.requestOptions.method}');
    debugPrint('STATUS CODE: ${err.response?.statusCode}');
    debugPrint('ERROR TYPE: ${err.type}');
    debugPrint('ERROR MESSAGE: ${getErrorMessage(err)}');
    debugPrint('DURATION: ${duration ?? 'Unknown'} ms');
    debugPrint('RESPONSE DATA: ${err.response?.data}');
    debugPrint('================================');

    handler.next(err);
  }

  String getErrorMessage(DioException error) {
     switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';

      case DioExceptionType.sendTimeout:
        return 'Request sending timeout.';

      case DioExceptionType.receiveTimeout:
        return 'Server response timeout.';

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.connectionError:
        return 'Network connection failed. Check your internet.';

      case DioExceptionType.badCertificate:
        return 'Invalid server certificate.';

      case DioExceptionType.unknown:
        return error.message ?? 'Something went wrong.';
       case DioExceptionType.transformTimeout:
         // TODO: Handle this case.
         throw UnimplementedError();
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Requested resource not found.';
      case 500:
        return 'Internal server error.';
      case 502:
        return 'Bad gateway.';
      case 503:
        return 'Service unavailable.';
      default:
        return 'Server error. Status code: $statusCode';
    }
  }
}

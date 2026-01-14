import 'package:dio/dio.dart';
import 'package:parallel_api/service/api_exception.dart';

class DioErrorHandler {
  static ApiException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException("Connection timeout");

      case DioExceptionType.sendTimeout:
        return ApiException("Send timeout");

      case DioExceptionType.receiveTimeout:
        return ApiException("Receive timeout");

      case DioExceptionType.badResponse:
        return ApiException(
          error.response?.data["message"] ??
              "Server error (${error.response?.statusCode})",
        );

      case DioExceptionType.cancel:
        return ApiException("Request cancelled");

      case DioExceptionType.unknown:
      default:
        return ApiException("Something went wrong");
    }
  }
}

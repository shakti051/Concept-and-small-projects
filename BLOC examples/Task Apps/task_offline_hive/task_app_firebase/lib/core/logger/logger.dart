import 'package:flutter/foundation.dart';

class LoggerService {
  const LoggerService();

  void info(String message) {
    debugPrint("ℹ️ INFO: $message");
  }

  void warning(String message) {
    debugPrint("⚠️ WARNING: $message");
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugPrint("❌ ERROR: $message");

    if (error != null) {
      debugPrint(error.toString());
    }

    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
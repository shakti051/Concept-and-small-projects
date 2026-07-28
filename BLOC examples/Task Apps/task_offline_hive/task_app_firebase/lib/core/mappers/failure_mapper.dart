
import 'package:task_app_firebase/core/failures/failures.dart';
import '../exceptions/app_exceptions.dart';

class FailureMapper {
  static AppFailure map(Object error) {
    switch (error) {
      case NetworkException():
        return const NetworkFailure();

      case AuthenticationException():
        return const AuthenticationFailure();

      case FirestoreReadException():
        return const ServerFailure(
          "Unable to fetch tasks.",
        );

      case FirestoreWriteException():
        return const ServerFailure(
          "Unable to sync tasks.",
        );

      default:
        return const UnknownFailure();
    }
  }
}
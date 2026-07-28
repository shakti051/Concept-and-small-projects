abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException() : super("No internet connection");
}

class AuthenticationException extends AppException {
  const AuthenticationException() : super("Authentication failed");
}

class FirestoreReadException extends AppException {
  const FirestoreReadException() : super("Unable to read data from Firestore");
}

class FirestoreWriteException extends AppException {
  const FirestoreWriteException() : super("Unable to write data to Firestore");
}

class LocalDatabaseException extends AppException {
  const LocalDatabaseException()
      : super("Unable to access local database");
}
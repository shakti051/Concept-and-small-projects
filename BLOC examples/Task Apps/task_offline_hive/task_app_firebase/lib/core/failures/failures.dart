
abstract class AppFailure {
  final String message;

  const AppFailure(this.message);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure() : super("No internet connection. Please try again.");
}

class AuthenticationFailure extends AppFailure {
  const AuthenticationFailure()
    : super("Your session has expired. Please login again.");
}

class ServerFailure extends AppFailure {
  const ServerFailure([
    super.message = "Server error. Please try again later.",
  ]);
}

class CacheFailure extends AppFailure {
  const CacheFailure() : super("Unable to access local storage.");
}

class UnknownFailure extends AppFailure {
  const UnknownFailure() : super("Something went wrong.");
}

class LocalDatabaseFailure extends AppFailure{
  LocalDatabaseFailure() : super("Unable to edit in local database");
}
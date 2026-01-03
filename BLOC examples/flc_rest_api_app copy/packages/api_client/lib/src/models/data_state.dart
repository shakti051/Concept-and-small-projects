abstract class DataState<T> {
  DataState({this.data, this.error});
  final T? data;
  final DataError? error;
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  DataFailed(DataError err) : super(error: err);
}

class DataError {
  DataError(this.statusCode, this.error);
  final int? statusCode;
  final dynamic error;
}
import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/error/failure.dart';


typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = ResultFuture<void>;
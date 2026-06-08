
import 'package:mvvm_stream/data/network/network_failure.dart';
import 'package:mvvm_stream/data/request/login_request.dart';
import 'package:dartz/dartz.dart';
import 'model.dart';

abstract class Repository{
  Future<Either<Failure,Authentication>> login(LoginRequest loginRequest);
}
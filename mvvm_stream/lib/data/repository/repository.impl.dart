import 'package:dartz/dartz.dart';
import 'package:mvvm_stream/data/data_source/data_source.dart';
import 'package:mvvm_stream/data/mapper/mapper.dart';
import 'package:mvvm_stream/data/network/error_handler.dart';
import 'package:mvvm_stream/data/network/network_failure.dart';
import 'package:mvvm_stream/data/network/network_info.dart';
import 'package:mvvm_stream/data/request/login_request.dart';
import 'package:mvvm_stream/domain/model/model.dart';
import 'package:mvvm_stream/domain/repository/repository.dart';


class RepositoryImpl extends Repository {
  RemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
     if (await _networkInfo.isConnected) {
      try {
        // its safe to call the API
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == ApiInternalStatus.SUCCESS) // success
        {
          // return data (success)
          // return right
          return Right(response.toDomain());
        } else {
          // return biz logic error
          // return left
          return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
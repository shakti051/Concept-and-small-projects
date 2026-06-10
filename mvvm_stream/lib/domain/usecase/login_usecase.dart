import 'package:dartz/dartz.dart';
import 'package:mvvm_stream/domain/model/model.dart';
import 'package:mvvm_stream/domain/repository/repository.dart';
import 'package:mvvm_stream/domain/usecase/base_usecase.dart';
import '../../app/functions.dart';
import '../../data/network/network_failure.dart';
import '../../data/request/login_request.dart';


class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    DeviceInfo deviceInfo = await getDeviceDetails();
    return await _repository.login(LoginRequest(
        input.email, input.password, deviceInfo.identifier, deviceInfo.name));
  }
}

class LoginUseCaseInput {
  String email;
  String password;

  LoginUseCaseInput(this.email, this.password);
}
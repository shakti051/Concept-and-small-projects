
import 'package:freezed_annotation/freezed_annotation.dart';
part 'freezed_data_classes.freezed.dart';
///dart run build_runner build --delete-conflicting-outputs

@freezed
class LoginObject with _$LoginObject{
factory LoginObject(String userName,String password) = _LoginObject;

  @override
  // TODO: implement password
  String get password => throw UnimplementedError();

  @override
  // TODO: implement userName
  String get userName => throw UnimplementedError();
}
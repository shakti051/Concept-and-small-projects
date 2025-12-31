part of 'login_bloc.dart';

sealed class LoginEvent {}

final class ChangeEmail extends LoginEvent {
  ChangeEmail(this.val);
  final String val;
}

final class ChangePwd extends LoginEvent {
  ChangePwd(this.val);
  final String val;
}

final class Submit extends LoginEvent {}

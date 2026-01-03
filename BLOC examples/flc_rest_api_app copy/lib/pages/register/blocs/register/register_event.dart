part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class ChangeEmail extends RegisterEvent {
  ChangeEmail(this.val);
  final String val;
}

final class ChangePwd extends RegisterEvent {
  ChangePwd(this.val);
  final String val;
}

final class Submit extends RegisterEvent {}

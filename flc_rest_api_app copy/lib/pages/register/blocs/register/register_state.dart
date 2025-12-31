part of 'register_bloc.dart';

@immutable

final class RegisterState extends Equatable {
  const RegisterState({
    this.emailInput = const EmailInput.pure(),
    this.pwdInput = const PwdInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.error,
  });

  final EmailInput emailInput;
  final PwdInput pwdInput;
  final FormzSubmissionStatus status;
  final String? error;
  final bool isValid;

  RegisterState copyWith({
    EmailInput? emailInput,
    PwdInput? pwdInput,
    FormzSubmissionStatus? status,
    String? error,
    bool? isValid,
  }) =>
      RegisterState(
        emailInput: emailInput ?? this.emailInput,
        pwdInput: pwdInput ?? this.pwdInput,
        status: status ?? this.status,
        error: error ?? this.error,
        isValid: isValid ?? this.isValid,
      );

  @override
  List<Object?> get props => [emailInput, pwdInput, status, error, isValid];
}

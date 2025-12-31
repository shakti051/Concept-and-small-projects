import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import 'package:flc_rest_api_test/pages/register/views/email_input.dart';
import 'package:flc_rest_api_test/pages/register/views/pwd_input.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this.authRepo) : super(const RegisterState()) {
    on<ChangeEmail>(_changeEmail);
    on<ChangePwd>(_changePwd);
    on<Submit>(_submit);
  }

  final AuthRepo authRepo;

  void _changeEmail(ChangeEmail event, Emitter<RegisterState> emit) {
    final emailInput = EmailInput.dirty(value: event.val);
    emit(
      state.copyWith(
        emailInput: emailInput,
        isValid: Formz.validate([emailInput, state.pwdInput]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _changePwd(ChangePwd event, Emitter<RegisterState> emit) {
    final pwdInput = PwdInput.dirty(value: event.val);
    emit(
      state.copyWith(
        pwdInput: pwdInput,
        isValid: Formz.validate([pwdInput, state.emailInput]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _submit(Submit event, Emitter<RegisterState> emit) async {
    //form validates?
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    //auth repo register user method
    final creds =
        Creds(email: state.emailInput.value, password: state.pwdInput.value);
    final error = await authRepo.register(creds);
    if (error != null) {
      return emit(
        state.copyWith(
          error: error,
          status: FormzSubmissionStatus.failure,
        ),
      );
    }

    emit(state.copyWith(status: FormzSubmissionStatus.success));
  }
}

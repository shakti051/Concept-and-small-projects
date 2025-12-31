import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:flc_rest_api_test/pages/register/views/email_input.dart';
import 'package:flc_rest_api_test/pages/register/views/pwd_input.dart';
part 'login_event.dart';
part 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.authRepo) : super(const LoginState()) {
    on<ChangeEmail>(_changeEmail);
    on<ChangePwd>(_changePwd);
    on<Submit>(_submit);
  }

  final AuthRepo authRepo;

  void _changeEmail(ChangeEmail event, Emitter<LoginState> emit) {
    final emailInput = EmailInput.dirty(value: event.val);
    emit(
      state.copyWith(
        emailInput: emailInput,
        isValid: Formz.validate([emailInput, state.pwdInput]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _changePwd(ChangePwd event, Emitter<LoginState> emit) {
    final pwdInput = PwdInput.dirty(value: event.val);
    emit(
      state.copyWith(
        pwdInput: pwdInput,
        isValid: Formz.validate([pwdInput, state.emailInput]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _submit(Submit event, Emitter<LoginState> emit) async {
    //form validates?
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    //auth repo register user method
    final creds =
        Creds(email: state.emailInput.value, password: state.pwdInput.value);
    final error = await authRepo.login(creds);
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

// ignore_for_file: always_use_package_imports
import 'package:flc_rest_api_test/pages/login/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../locator.dart';
import '../../home/views/home.dart';
import 'email_input.dart';
import 'pwd_input.dart';
import 'register_text.dart';
import 'signin_btn.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(lc()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          final snackbar = SnackBar(content: Text(state.error ?? 'Some error'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        if (state.status == FormzSubmissionStatus.success) {
          const snackbar = SnackBar(
            content: Text('Login success. You will be redirected to home page'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<dynamic>(builder: (cxt) => const HomePage()),
            (route) => false,
          );
        }
      },
      child: const Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 22),
              EmailInputTextField(),
              PwdInputTextField(),
              SizedBox(height: 22),
              SigninBtn(),
              SizedBox(height: 22),
              RegisterText(),
            ],
          ),
        ),
      ),
    );
  }
}

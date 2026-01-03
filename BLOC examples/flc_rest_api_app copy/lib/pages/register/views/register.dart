// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../locator.dart';
import '../blocs/register/register_bloc.dart';
import 'email_input.dart';
import 'pwd_input.dart';
import 'login_text.dart';
import 'signup_btn.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(lc()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          final snackbar = SnackBar(content: Text(state.error ?? 'Some error'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        if (state.status == FormzSubmissionStatus.success) {
          const snackbar =
              SnackBar(content: Text('User created successfuly. Please login'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      child: const Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 22),
              EmailInputTextField(),
              PwdInputTextField(),
              SizedBox(height: 22),
              SigninBtn(),
              SizedBox(height: 22),
              LoginText(),
            ],
          ),
        ),
      ),
    );
  }
}

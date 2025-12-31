// ignore_for_file: unnecessary_lambdas, avoid_dynamic_calls

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../blocs/register/register_bloc.dart';

class SigninBtn extends StatelessWidget {
  const SigninBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state.status == FormzSubmissionStatus.inProgress) {
          return const Align(child: CircularProgressIndicator());
        }
        return PrimaryBtn(
          text: 'Submit',
          ontap: ()=> context.read<RegisterBloc>().add(Submit()),
        );
      },
    );
  }
}

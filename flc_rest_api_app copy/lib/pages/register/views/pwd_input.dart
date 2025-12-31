import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:flc_rest_api_test/pages/register/blocs/register/register_bloc.dart';

enum PwdInputError { empty }

class PwdInput extends FormzInput<String, PwdInputError> {
  const PwdInput.pure() : super.pure('');

  const PwdInput.dirty({String value = ''}) : super.dirty(value);

  static String? getErrorMsg(PwdInputError? err) {
    if (err == PwdInputError.empty) {
      return 'password cannot be empty';
    } else {
      return null;
    }
  }

  @override
  PwdInputError? validator(String value) {
    return value.isEmpty ? PwdInputError.empty : null;
  }
}

class PwdInputTextField extends StatelessWidget {
  const PwdInputTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onChanged: (value) =>
                context.read<RegisterBloc>().add(ChangePwd(value)),
            decoration: InputDecoration(
              errorText: PwdInput.getErrorMsg(state.pwdInput.error),
              label: Container(
                margin: const EdgeInsets.symmetric(horizontal: 9),
                child: const Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 17, // Set the desired font size here
                  ),
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          );
        },
      ),
    );
  }
}

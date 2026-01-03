import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flc_rest_api_test/pages/register/blocs/register/register_bloc.dart';

enum EmailInputError { empty }

class EmailInput extends FormzInput<String, EmailInputError> {
  const EmailInput.pure() : super.pure('');

  const EmailInput.dirty({String value = ''}) : super.dirty(value);

  static String? getErrorMsg(EmailInputError? err) {
    if (err == EmailInputError.empty) {
      return 'Email cannot be empty';
    } else {
      return null;
    }
  }

  @override
  EmailInputError? validator(String value) {
    return value.isEmpty ? EmailInputError.empty : null;
  }
}

class EmailInputTextField extends StatelessWidget {
  const EmailInputTextField({
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
                context.read<RegisterBloc>().add(ChangeEmail(value)),
            decoration: InputDecoration(
              errorText: EmailInput.getErrorMsg(state.emailInput.error),
              label: Container(
                margin: const EdgeInsets.symmetric(horizontal: 9),
                child: const Text(
                  'Email',
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

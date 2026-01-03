import 'package:flc_rest_api_test/pages/login/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../register/views/pwd_input.dart';


class PwdInputTextField extends StatelessWidget {
  const PwdInputTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onChanged: (value)=>context.read<LoginBloc>().add(ChangePwd(value)),
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

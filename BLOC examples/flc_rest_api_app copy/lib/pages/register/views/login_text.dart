import 'package:flc_rest_api_test/pages/login/views/login.dart';
import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  const LoginText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<dynamic>(
            builder: (cxt) => const LoginPage(),
          ),
        );
      },
      child: const Text(
        'Already have an account? Signin here',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }
}

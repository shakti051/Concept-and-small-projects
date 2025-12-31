import 'package:flc_rest_api_test/pages/register/views/register.dart';
import 'package:flutter/material.dart';

class RegisterText extends StatelessWidget {
  const RegisterText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<dynamic>(
            builder: (cxt) => const RegisterPage(),
          ),
        );
      },
      child: const Text(
        "Don't have an account? Signup here",
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }
}

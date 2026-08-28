
import 'package:flutter/material.dart';
import 'package:login_bloc/src/blocs/validators.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final PasswordRequirements requirements;

  const PasswordRequirementsWidget({
    super.key,
    required this.requirements,
  });

  Widget _item(String text, bool valid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: valid ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: valid ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _item(
          'At least 8 characters',
          requirements.minLength,
        ),
        _item(
          'One uppercase letter',
          requirements.hasUppercase,
        ),
        _item(
          'One lowercase letter',
          requirements.hasLowercase,
        ),
        _item(
          'One number',
          requirements.hasDigit,
        ),
        _item(
          'One special character',
          requirements.hasSpecial,
        ),
      ],
    );
  }
}
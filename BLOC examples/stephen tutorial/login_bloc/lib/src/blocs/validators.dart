import 'dart:async';

class PasswordRequirements {
  final bool minLength;
  final bool hasLowercase;
  final bool hasUppercase;
  final bool hasDigit;
  final bool hasSpecial;

  const PasswordRequirements({
    this.minLength = false,
    this.hasLowercase = false,
    this.hasUppercase = false,
    this.hasDigit = false,
    this.hasSpecial = false,
  });

  bool get isValid =>
      minLength && hasLowercase && hasUppercase && hasDigit && hasSpecial;
}

mixin Validators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      final value = email.trim();

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (emailRegex.hasMatch(value)) {
        sink.add(value);
      } else {
        sink.addError('Enter a valid email address');
      }
    },
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      final requirements = PasswordRequirements(
        minLength: password.length >= 8,
        hasLowercase: RegExp(r'[a-z]').hasMatch(password),
        hasUppercase: RegExp(r'[A-Z]').hasMatch(password),
        hasDigit: RegExp(r'\d').hasMatch(password),
        hasSpecial: RegExp(r'''[!@#$%^&*(),.?":{}|<>\-\\/\[\]]''')
            .hasMatch(password),
      );

      if (requirements.isValid) {
        sink.add(password);
      } else {
        // Keep the stream in error state until all rules are satisfied.
        sink.addError(requirements);
      }
    },
  );
}

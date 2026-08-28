import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'validators.dart';

//

class Bloc with Validators {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  // Validated email stream
  Stream<String> get email => _email.stream.transform(validateEmail);

  // Validated password stream
  Stream<String> get password => _password.stream.transform(validatePassword);

  // Live password checklist
  Stream<PasswordRequirements> get passwordRequirements => _password.stream.map(
    (password) => PasswordRequirements(
      minLength: password.length >= 8,
      hasLowercase: RegExp(r'[a-z]').hasMatch(password),
      hasUppercase: RegExp(r'[A-Z]').hasMatch(password),
      hasDigit: RegExp(r'\d').hasMatch(password),
      hasSpecial: RegExp(r'''[!@#$%^&*(),.?":{}|<>\-\\/\[\]]''')
          .hasMatch(password),
    ),
  );

  // Button becomes enabled only when
  // both email and password are valid.
  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, password, (email, password) => true);

  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  void submit() {
    final validEmail = _email.value;
    final validPassword = _password.value;

    print('Email is $validEmail');
    print('Password is $validPassword');
  }

  void dispose() {
    _email.close();
    _password.close();
  }
}

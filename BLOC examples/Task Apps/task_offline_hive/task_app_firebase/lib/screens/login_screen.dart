import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app_firebase/screens/forgot_password_screen.dart';
import 'package:task_app_firebase/screens/register_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.auth});

  static const id = 'login_screen';

  final FirebaseAuth? auth;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: const Key('login_email_field'),
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Insert email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }

                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: const Key('login_password_field'),
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Insert password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }

                    if (value.length < 6) {
                      return 'Password should be at least 6 characters';
                    }

                    return null;
                  },
                ),
              ),

              ElevatedButton(
                key: const Key('login_button'),
                onPressed: _login,
                child: const Text('Login'),
              ),

              TextButton(
                key: const Key('register_navigation_button'),
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterScreen.id);
                },
                child: const Text("Don't have an Account?"),
              ),

              TextButton(
                key: const Key('forgot_password_button'),
                onPressed: () {
                  Navigator.of(context).pushNamed(ForgotPasswordScreen.id);
                },
                child: const Text('Forget Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    // Firebase authentication is intentionally skipped
    // when auth is not supplied. This allows pure widget
    // and validation testing without Firebase initialization.
    if (widget.auth == null) {
      return;
    }

    try {
      final result = await widget.auth!.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final user = result.user;

      if (user == null) {
        _showError('Login failed');
        return;
      }

      await GetStorage().write('token', user.uid);

      await GetStorage().write('email', user.email);

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, TabsScreen.id);
    } on FirebaseAuthException catch (error) {
      _showError(error.message ?? 'Login failed');
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error $message',
          style: const TextStyle(color: Colors.red),
        ),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}

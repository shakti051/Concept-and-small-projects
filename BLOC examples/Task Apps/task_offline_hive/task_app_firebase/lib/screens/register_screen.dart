import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_app_firebase/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.auth});

  static const id = 'register_screen';

  final FirebaseAuth? auth;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    // Use injected FirebaseAuth when testing.
    // Use FirebaseAuth.instance in the real application.
    final auth = widget.auth ?? FirebaseAuth.instance;

    try {
      await auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error ${error.message ?? error.code}',
            style: const TextStyle(color: Colors.red),
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error $error',
            style: const TextStyle(color: Colors.red),
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Insert password'),
                obscureText: true,
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
              key: const Key('register_button'),
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

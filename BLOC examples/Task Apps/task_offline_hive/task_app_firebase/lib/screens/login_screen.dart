import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_app_firebase/screens/forgot_password_screen.dart';
import 'package:task_app_firebase/screens/register_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';
import 'package:task_app_firebase/services/locator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.auth,
  });

  static const id = 'login_screen';

  final FirebaseAuth? auth;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
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
                  decoration: const InputDecoration(
                    labelText: 'Insert email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
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
                key: const Key('login_button'),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Login'),
              ),

              TextButton(
                key: const Key('register_navigation_button'),
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.of(context).pushNamed(
                          RegisterScreen.id,
                        );
                      },
                child: const Text("Don't have an Account?"),
              ),

              TextButton(
                key: const Key('forgot_password_button'),
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.of(context).pushNamed(
                          ForgotPasswordScreen.id,
                        );
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

    final auth = widget.auth;

    if (auth == null) {
      _showError('FirebaseAuth is not configured');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ------------------------------------------------------------
      // 1. Firebase login
      // ------------------------------------------------------------

      final result = await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = result.user;

      if (user == null ||
          user.email == null ||
          user.email!.trim().isEmpty) {
        _showError('Login failed');
        return;
      }

      // ------------------------------------------------------------
      // 2. Normalize email
      // ------------------------------------------------------------

      final email = user.email!.trim().toLowerCase();

      // ------------------------------------------------------------
      // 3. Save authenticated user
      // ------------------------------------------------------------

      final storage = GetStorage();

      await storage.write('token', user.uid);
      await storage.write('email', email);

      // ------------------------------------------------------------
      // 4. IMPORTANT
      //
      // setupLocator() must:
      //   - use this email
      //   - open tasks_<email>
      //   - register HiveTaskDataSource(email)
      //   - register SyncQueue
      //   - register other user-specific dependencies
      // ------------------------------------------------------------

      await setupUserLocator(email);

      if (!mounted) {
        return;
      }

      // ------------------------------------------------------------
      // 5. Navigate only AFTER user-specific dependencies are ready
      // ------------------------------------------------------------

      Navigator.pushReplacementNamed(
        context,
        TabsScreen.id,
      );
    } on FirebaseAuthException catch (error) {
      _showError(
        error.message ?? 'Login failed',
      );
    } catch (error) {
      _showError(
        error.toString(),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
        duration: const Duration(
          milliseconds: 2000,
        ),
      ),
    );
  }
}


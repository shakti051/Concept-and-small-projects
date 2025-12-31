import 'package:auth_repo/auth_repo.dart';
import 'package:flc_rest_api_test/pages/login/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../locator.dart';
import '../../home/views/home.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashView();
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView({super.key});

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), _routeUser);
  }

  void _routeUser() {
    final signedIn = lc<AuthRepo>().checkIfSignedIn();
    if (signedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<dynamic>(
          builder: (cxt) => const HomePage(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<dynamic>(
          builder: (cxt) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (cxt) => const LoginPage(),
                ),
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.blue,
                size: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flc_rest_api_test/l10n/l10n.dart';
import 'package:flc_rest_api_test/pages/splash/views/splash.dart';
import 'package:flutter/material.dart';
import '../../pages/home/views/home.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const _App();
  }
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SplashPage(),
    );
  }
}

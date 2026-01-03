import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/theme/theme_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Event Payload',
            debugShowCheckedModeBanner: false,
            theme:context.watch<ThemeBloc>().state.appTheme == AppTheme.light
                ? ThemeData.light(useMaterial3: true)
                : ThemeData.dark(useMaterial3: true),
            home: const MyHomePage(),
          );
        }
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final int randInt = Random().nextInt(10);
            print('randInt: $randInt');

            context.read<ThemeBloc>().add(ChangeThemeEvent(randInt: randInt));
          },
          child: const Text(
            'Change Theme',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}

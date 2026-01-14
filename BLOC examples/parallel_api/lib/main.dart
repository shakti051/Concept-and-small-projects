import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parallel_api/blocs/home/home_bloc.dart';
import 'package:parallel_api/service/api_service.dart';

import 'service/home_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        HomeRepository(ApiService()),
      )..add(LoadHomeData()), // 👈 trigger API
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoading) {
            BotToast.showLoading();
          }

          if (state is HomeLoaded) {
            BotToast.closeAllLoading();
            BotToast.showText(text: "Data loaded successfully");
          }

          if (state is HomeError) {
            BotToast.closeAllLoading();
            BotToast.showText(text: state.message);
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              return Column(
                children: [
                  Text("Posts: ${state.posts.length}"),
                  Text("Users: ${state.users.length}"),
                ],
              );
            }
            return const SizedBox(); // ❌ No Circular loader
          },
        ),
      ),
    );
  }
}

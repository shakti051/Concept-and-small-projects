import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../locator.dart';
import '../../login/views/login.dart';
import '../blocs/notification/notification_bloc.dart';
import '../card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(lc()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              lc<AuthRepo>().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (cxt) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NotificationBloc>().add(GetNotifications());
        },
        child: BlocBuilder<NotificationBloc, NotificationsState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (cxt, index) {
                return NotificationCard(state.notifications[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

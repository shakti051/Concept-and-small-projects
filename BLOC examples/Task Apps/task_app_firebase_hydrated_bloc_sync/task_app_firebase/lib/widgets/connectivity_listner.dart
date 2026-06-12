import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app_firebase/blocs/tasks_bloc/tasks_bloc.dart';

import '../../blocs/connectivity/connectivity_bloc.dart';

class ConnectivityListener extends StatelessWidget {
  final Widget child;

  const ConnectivityListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          previous.status != ConnectionStatus.initial,
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (state.status == ConnectionStatus.online) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are online'),
            ),
          );

          // Trigger sync
          // context.read<TasksBloc>().add(
          //   SyncPendingTasks(),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are offline'),
            ),
          );
        }
      },
      child: child,
    );
  }
}
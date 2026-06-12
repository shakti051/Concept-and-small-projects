import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.status == ConnectionStatus.online
                  ? 'You are online'
                  : 'You are offline',
            ),
          ),
        );
      },
      child: child,
    );
  }
}
part of 'connectivity_bloc.dart';

enum ConnectionStatus {
  initial,
  online,
  offline,
}

class ConnectivityState {
  final ConnectionStatus status;

   ConnectivityState({this.status  = ConnectionStatus.initial});
}
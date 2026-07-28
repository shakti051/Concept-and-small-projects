
import '../blocs/connectivity/connectivity_bloc.dart';

extension ConnectivityBlocExtension on ConnectivityBloc {
  bool get isOnline =>
      state.status == ConnectionStatus.online;

  bool get isOffline =>
      state.status == ConnectionStatus.offline;
}
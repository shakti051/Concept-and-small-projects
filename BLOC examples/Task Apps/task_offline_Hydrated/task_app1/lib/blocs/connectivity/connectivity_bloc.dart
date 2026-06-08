import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity connectivity;

  StreamSubscription? _subscription;
  
  ConnectivityBloc(this.connectivity) : super(ConnectivityInitial()) {
    on<ObserveConnectivity>(_onObserveConnectivity);
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<ConnectivityEvent>((event, emit) {
    });
  }

  Future<void> _onObserveConnectivity(
    ObserveConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    final result = await connectivity.checkConnectivity();

    final connected =
        !result.contains(ConnectivityResult.none);

    add(ConnectivityChanged(connected));

    _subscription = connectivity.onConnectivityChanged.listen(
      (results) {
        final connected =
            !results.contains(ConnectivityResult.none);

        add(ConnectivityChanged(connected));
      },
    );
  }

   void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    if (event.isConnected) {
      emit(ConnectivityOnline());
    } else {
      emit(ConnectivityOffline());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

}

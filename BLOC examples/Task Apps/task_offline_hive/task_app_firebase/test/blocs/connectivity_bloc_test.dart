import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';

// ============================================================
// MOCK
// ============================================================

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity connectivity;
  late ConnectivityBloc bloc;

  // ==========================================================
  // SETUP
  // ==========================================================

  setUp(() {
    connectivity = MockConnectivity();
  });

  tearDown(() async {
    await bloc.close();
  });

  // ==========================================================
  // INITIAL STATE
  // ==========================================================

  test('initial state should be initial', () {
    bloc = ConnectivityBloc(connectivity);

    expect(bloc.state.status, ConnectionStatus.initial);
  });

  // ==========================================================
  // CONNECTIVITY CHANGED - ONLINE
  // ==========================================================

  test('ConnectivityChanged(true) emits online state', () async {
    bloc = ConnectivityBloc(connectivity);

    expect(
      bloc.stream,
      emits(
        predicate<ConnectivityState>(
          (state) => state.status == ConnectionStatus.online,
        ),
      ),
    );

    bloc.add(ConnectivityChanged(true));
  });

  // ==========================================================
  // CONNECTIVITY CHANGED - OFFLINE
  // ==========================================================

  test('ConnectivityChanged(false) emits offline state', () async {
    bloc = ConnectivityBloc(connectivity);

    expect(
      bloc.stream,
      emits(
        predicate<ConnectivityState>(
          (state) => state.status == ConnectionStatus.offline,
        ),
      ),
    );

    bloc.add(ConnectivityChanged(false));
  });

  // ==========================================================
  // OBSERVE CONNECTIVITY - ONLINE
  // ==========================================================

  test(
    'ObserveConnectivity emits online when connectivity is available',
    () async {
      bloc = ConnectivityBloc(connectivity);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer(
        (_) => const Stream<List<ConnectivityResult>>.empty(),
      );

      expect(
        bloc.stream,
        emits(
          predicate<ConnectivityState>(
            (state) => state.status == ConnectionStatus.online,
          ),
        ),
      );

      bloc.add(ObserveConnectivity());
    },
  );

  // ==========================================================
  // OBSERVE CONNECTIVITY - OFFLINE
  // ==========================================================

  test(
    'ObserveConnectivity emits offline when connectivity is none',
    () async {
      bloc = ConnectivityBloc(connectivity);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer(
        (_) => const Stream<List<ConnectivityResult>>.empty(),
      );

      expect(
        bloc.stream,
        emits(
          predicate<ConnectivityState>(
            (state) => state.status == ConnectionStatus.offline,
          ),
        ),
      );

      bloc.add(ObserveConnectivity());
    },
  );

  // ==========================================================
  // OBSERVE CONNECTIVITY - MOBILE
  // ==========================================================

  test(
    'ObserveConnectivity emits online for mobile connection',
    () async {
      bloc = ConnectivityBloc(connectivity);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer(
        (_) => const Stream<List<ConnectivityResult>>.empty(),
      );

      expect(
        bloc.stream,
        emits(
          predicate<ConnectivityState>(
            (state) => state.status == ConnectionStatus.online,
          ),
        ),
      );

      bloc.add(ObserveConnectivity());
    },
  );

  // ==========================================================
  // OBSERVE CONNECTIVITY - ETHERNET
  // ==========================================================

  test(
    'ObserveConnectivity emits online for ethernet connection',
    () async {
      bloc = ConnectivityBloc(connectivity);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.ethernet]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer(
        (_) => const Stream<List<ConnectivityResult>>.empty(),
      );

      expect(
        bloc.stream,
        emits(
          predicate<ConnectivityState>(
            (state) => state.status == ConnectionStatus.online,
          ),
        ),
      );

      bloc.add(ObserveConnectivity());
    },
  );

  // ==========================================================
  // OBSERVE CONNECTIVITY - WIFI
  // ==========================================================

  test(
    'ObserveConnectivity emits online for wifi connection',
    () async {
      bloc = ConnectivityBloc(connectivity);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer(
        (_) => const Stream<List<ConnectivityResult>>.empty(),
      );

      expect(
        bloc.stream,
        emits(
          predicate<ConnectivityState>(
            (state) => state.status == ConnectionStatus.online,
          ),
        ),
      );

      bloc.add(ObserveConnectivity());
    },
  );

  // ==========================================================
  // STREAM - ONLINE -> OFFLINE
  // ==========================================================

  test(
    'connectivity stream changes state from online to offline',
    () async {
      bloc = ConnectivityBloc(connectivity);

      final controller =
          StreamController<List<ConnectivityResult>>();

      addTearDown(controller.close);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer((_) => controller.stream);

      final states = <ConnectionStatus>[];

      final subscription = bloc.stream.listen((state) {
        states.add(state.status);
      });

      addTearDown(subscription.cancel);

      bloc.add(ObserveConnectivity());

      await Future<void>.delayed(Duration.zero);

      controller.add([ConnectivityResult.none]);

      await Future<void>.delayed(Duration.zero);

      expect(
        states,
        contains(ConnectionStatus.offline),
      );
    },
  );

  // ==========================================================
  // STREAM - OFFLINE -> ONLINE
  // ==========================================================

  test(
    'connectivity stream changes state from offline to online',
    () async {
      bloc = ConnectivityBloc(connectivity);

      final controller =
          StreamController<List<ConnectivityResult>>();

      addTearDown(controller.close);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer((_) => controller.stream);

      final states = <ConnectionStatus>[];

      final subscription = bloc.stream.listen((state) {
        states.add(state.status);
      });

      addTearDown(subscription.cancel);

      bloc.add(ObserveConnectivity());

      await Future<void>.delayed(Duration.zero);

      controller.add([ConnectivityResult.wifi]);

      await Future<void>.delayed(Duration.zero);

      expect(
        states,
        contains(ConnectionStatus.online),
      );
    },
  );

  // ==========================================================
  // STREAM - WIFI -> MOBILE
  // ==========================================================

  test(
    'connectivity stream remains online when connection changes',
    () async {
      bloc = ConnectivityBloc(connectivity);

      final controller =
          StreamController<List<ConnectivityResult>>();

      addTearDown(controller.close);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer((_) => controller.stream);

      final states = <ConnectionStatus>[];

      final subscription = bloc.stream.listen((state) {
        states.add(state.status);
      });

      addTearDown(subscription.cancel);

      bloc.add(ObserveConnectivity());

      await Future<void>.delayed(Duration.zero);

      controller.add([ConnectivityResult.mobile]);

      await Future<void>.delayed(Duration.zero);

      expect(
        states,
        contains(ConnectionStatus.online),
      );
    },
  );

  // ==========================================================
  // MULTIPLE CONNECTIVITY RESULTS
  // ==========================================================

  test(
    'multiple non-none connectivity results are considered online',
    () async {
      bloc = ConnectivityBloc(connectivity);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer(
        (_) async => [
          ConnectivityResult.wifi,
          ConnectivityResult.mobile,
        ],
      );

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer(
        (_) => const Stream<List<ConnectivityResult>>.empty(),
      );

      expect(
        bloc.stream,
        emits(
          predicate<ConnectivityState>(
            (state) => state.status == ConnectionStatus.online,
          ),
        ),
      );

      bloc.add(ObserveConnectivity());
    },
  );

  // ==========================================================
  // STREAM CONTAINS NONE
  // ==========================================================

  test(
    'connectivity stream containing none is considered offline',
    () async {
      bloc = ConnectivityBloc(connectivity);

      final controller =
          StreamController<List<ConnectivityResult>>();

      addTearDown(controller.close);

      when(
        () => connectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(
        () => connectivity.onConnectivityChanged,
      ).thenAnswer((_) => controller.stream);

      final states = <ConnectionStatus>[];

      final subscription = bloc.stream.listen((state) {
        states.add(state.status);
      });

      addTearDown(subscription.cancel);

      bloc.add(ObserveConnectivity());

      await Future<void>.delayed(Duration.zero);

      controller.add([ConnectivityResult.none]);

      await Future<void>.delayed(Duration.zero);

      expect(
        states,
        contains(ConnectionStatus.offline),
      );
    },
  );

  // ==========================================================
  // CLOSE
  // ==========================================================

  test('close completes successfully', () async {
    bloc = ConnectivityBloc(connectivity);

    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);

    when(
      () => connectivity.onConnectivityChanged,
    ).thenAnswer(
      (_) => const Stream<List<ConnectivityResult>>.empty(),
    );

    bloc.add(ObserveConnectivity());

    await Future<void>.delayed(Duration.zero);

    await expectLater(
      bloc.close(),
      completes,
    );

    // Prevent tearDown from trying to close it again.
    bloc = ConnectivityBloc(connectivity);
  });
}

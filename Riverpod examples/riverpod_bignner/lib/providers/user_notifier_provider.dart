import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNotifierProvider =
    NotifierProvider.autoDispose<UserNotifier, String>(
  UserNotifier.new,
);

class UserNotifier extends Notifier<String> {
  @override
  String build() {
    final keepAlive = ref.keepAlive();

    Timer? timer;

    ref.onCancel(() {
      debugPrint('UserNotifier onCancel');

      timer?.cancel();

      timer = Timer(const Duration(seconds: 10), () {
        debugPrint('10 seconds passed');
        keepAlive.close();
      });
    });

    ref.onResume(() {
      debugPrint('UserNotifier onResume');

      timer?.cancel();
      timer = null;
    });

    ref.onDispose(() {
      debugPrint('UserNotifier dispose');

      timer?.cancel();
    });

    return '-';
  }

  void update(String value) {
    state = value;
  }
}
import 'dart:async';
import 'dart:ui';

class SyncScheduler {

  Timer? _timer;

  void schedule(VoidCallback callback) {
    _timer?.cancel();

    _timer = Timer(
      const Duration(seconds: 5),
      callback,
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
import 'dart:async';
import 'dart:ui';

class SyncQueue {
  Timer? _timer;

  void enqueue(VoidCallback sync) {
    _timer?.cancel();

    _timer = Timer(
      const Duration(seconds: 1),
      sync,
    );
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

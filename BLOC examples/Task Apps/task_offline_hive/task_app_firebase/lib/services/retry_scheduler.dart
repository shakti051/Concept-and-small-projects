import 'dart:async';

class RetryScheduler {
  Timer? _timer;

  int _attempt = 0;

  void schedule(void Function() callback) {
    _timer?.cancel();

    final delay = _nextDelay();

    _timer = Timer(delay, callback);
  }

  void reset() {
    _attempt = 0;
    _timer?.cancel();
  }

  Duration _nextDelay() {
    _attempt++;

    switch (_attempt) {
      case 1:
        return const Duration(seconds: 5);

      case 2:
        return const Duration(seconds: 10);

      default:
        return const Duration(seconds: 30);
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
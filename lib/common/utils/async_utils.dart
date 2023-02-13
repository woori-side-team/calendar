import 'dart:async';

class Debouncer {
  Timer? timer;

  void run(Duration duration, void Function() job) {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }

    timer = Timer(duration, job);
  }
}

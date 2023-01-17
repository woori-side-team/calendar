/// Throttling 구현.
/// 아래 링크의 구현을 살짝 수정.
/// https://stackoverflow.com/a/66384196
class Throttler {
  final int throttleGapInMillis;
  int lastActionTime = 0;

  Throttler({required this.throttleGapInMillis});

  void run(void Function() action) {
    if (lastActionTime == 0) {
      action();
      lastActionTime = _getTime();
    } else {
      if (_getTime() - lastActionTime > throttleGapInMillis) {
        action();
        lastActionTime = _getTime();
      }
    }
  }

  _getTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}

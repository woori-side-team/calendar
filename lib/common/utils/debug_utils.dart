import 'package:flutter/foundation.dart';

// 아래의 print()에서 원본 print() 대신 새로운 print() 불려서 무한루프 발생하는 것 막기 위해...
const _originalPrint = print;

class DebugUtils {
  /// alwaysPrint가 false이면 디버그 모드일때만 print.
  /// alwaysPrint가 true이면 항상 print.
  /// print() 쓰면 linter가 if (kDebugMode) 걸으라고 제안하는데, 해당 if 문 안에 다른 조건을 섞으면 linter가 인식 못할 때가 있음. 이런 케이스 위해 제작...
  static void print<Value>(Value value, {bool alwaysPrint = false}) {
    if (kDebugMode || alwaysPrint) {
      _originalPrint(value);
    }
  }
}

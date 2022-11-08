import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Bottom sheet 등이 올라올 때 뒷부분을 반투명하게 가려줍니다.
class CustomBackdrop extends StatelessWidget {
  /// 얼마나 짙게.
  final double value;

  /// value 최소값.
  final double minValue;

  /// value 최대값.
  final double maxValue;

  /// value가 이 값 이상이어야 backdrop이 보여집니다.
  /// 그 미만일때만 뒷부분에 상호작용이 가능합니다.
  final double minShowValue;

  const CustomBackdrop(
      {super.key,
      required this.value,
      required this.minValue,
      required this.maxValue,
      required this.minShowValue});

  @override
  Widget build(BuildContext context) {
    if (value < minShowValue) {
      return const SizedBox(width: 0, height: 0);
    } else {
      final ratio =
          clampDouble((value - minValue) / (maxValue - minValue), 0, 1);

      return Container(
          color: Color.fromARGB((ratio * 0.8 * 255).floor(), 144, 144, 144),
          constraints: const BoxConstraints.expand());
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomBackdrop extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
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

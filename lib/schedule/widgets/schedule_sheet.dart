import 'package:calendar/common/styles/custom_theme.dart';
import 'package:calendar/common/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ScheduleSheet extends StatelessWidget {
  const ScheduleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    const minSize = 0.13;
    const maxSize = 1.0;

    final header = Padding(
        padding: const EdgeInsets.only(top: 6, left: 20, right: 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('다가오는 일정',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          TextButton(
              onPressed: () {},
              child: Text('편집',
                  style: TextStyle(fontSize: 14, color: CustomTheme.tint.blue)))
        ]));

    return CustomBottomSheet(
        minSize: minSize,
        maxSize: maxSize,
        snapSizes: const [minSize, 0.5, maxSize],
        child: Column(children: [header]));
  }
}

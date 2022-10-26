import 'package:calendar/common/providers/selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekView extends StatelessWidget {
  const WeekView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedMonthDate =
        context.watch<SelectionProvider>().getSelectedMonthDate();

    return Container(
        margin: const EdgeInsets.only(top: 37),
        child: Text(
            '${selectedMonthDate.year}년 ${selectedMonthDate.month}월 week view'));
  }
}

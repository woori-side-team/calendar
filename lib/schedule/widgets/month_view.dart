import 'package:calendar/common/styles/custom_theme.dart';
import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MonthView extends StatelessWidget {
  final DateTime selectedMonthDate;

  const MonthView({super.key, required this.selectedMonthDate});

  Color _getCellColor(int index) {
    if (index == 0) {
      return CustomTheme.tint.red;
    } else if (index == 6) {
      return CustomTheme.tint.blue;
    } else {
      return CustomTheme.scale.max;
    }
  }

  Widget _createNameCell(int index, String name) {
    return Expanded(
        child: Container(
            alignment: Alignment.center,
            height: 28,
            child: Text(name,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: _getCellColor(index)))));
  }

  Widget _createDayCell(int index, DateTime dayDate) {
    final dayArea = SizedBox(
        height: 28,
        child: Text('${dayDate.day}',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: _getCellColor(index))));

    return Expanded(
        child: Container(
            constraints: const BoxConstraints(minHeight: 58),
            child: Column(children: [dayArea])));
  }

  @override
  Widget build(BuildContext context) {
    final dayNames = ['일', '월', '화', '수', '목', '금', '토'];
    final weeks = CustomDateUtils.getMonthCalendar(selectedMonthDate);

    final nameRow = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dayNames.mapIndexed(_createNameCell).toList());

    final dayRows = weeks
        .map((week) => Row(children: week.mapIndexed(_createDayCell).toList()))
        .toList();

    return Padding(
        padding: const EdgeInsets.only(top: 28),
        child: Column(children: [nameRow, ...dayRows]));
  }
}

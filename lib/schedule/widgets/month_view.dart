import 'package:calendar/common/styles/custom_theme.dart';
import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MonthView extends StatelessWidget {
  final DateTime selectedMonthDate;

  const MonthView({super.key, required this.selectedMonthDate});

  Color _getCellColor(int weekDay) {
    if (weekDay == DateTime.sunday) {
      return CustomTheme.tint.red;
    } else if (weekDay == DateTime.saturday) {
      return CustomTheme.tint.blue;
    } else {
      return CustomTheme.scale.max;
    }
  }

  Widget _createNameCell(String name, int weekDay) {
    return Expanded(
        child: Container(
            alignment: Alignment.center,
            height: 28,
            child: Text(name,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: _getCellColor(weekDay)))));
  }

  Widget _createNameRow() {
    final dayNames = ['일', '월', '화', '수', '목', '금', '토'];

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dayNames
            .mapIndexed(
                (index, name) => _createNameCell(name, index == 0 ? 7 : index))
            .toList());
  }

  Widget _createDayLabel(DateTime dayDate) {
    return Container(
        width: double.infinity,
        height: 26,
        alignment: Alignment.center,
        decoration:
            !CustomDateUtils.areSameDays(CustomDateUtils.getToday(), dayDate)
                ? null
                : BoxDecoration(
                    color: CustomTheme.background.secondary,
                    borderRadius: BorderRadius.circular(8)),
        child: Text('${dayDate.day}',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: _getCellColor(dayDate.weekday))));
  }

  Widget _createDayCell(DateTime dayDate) {
    return Expanded(
        child: Container(
            constraints: const BoxConstraints(minHeight: 58),
            child: Column(children: [_createDayLabel(dayDate)])));
  }

  List<Widget> _createDayRows() {
    final weeks = CustomDateUtils.getMonthCalendar(selectedMonthDate);

    return weeks
        .map((week) => Row(children: week.map(_createDayCell).toList()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 28),
        child: Column(children: [_createNameRow(), ..._createDayRows()]));
  }
}

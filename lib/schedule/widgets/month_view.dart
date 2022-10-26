import 'package:calendar/common/models/schedule.dart';
import 'package:calendar/common/providers/schedules_provider.dart';
import 'package:calendar/common/styles/custom_theme.dart';
import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthView extends StatelessWidget {
  static const _dayNames = ['일', '월', '화', '수', '목', '금', '토'];

  static final _markerColors = [
    CustomTheme.tint.indigo,
    CustomTheme.tint.orange,
    CustomTheme.tint.pink,
    CustomTheme.tint.teal
  ];

  final DateTime selectedMonthDate;

  const MonthView({super.key, required this.selectedMonthDate});

  /// 날짜를 key로 하는 Map을 만들 때 사용.
  String _getDayKey(DateTime dayDate) {
    return '${dayDate.year}:${dayDate.month}:${dayDate.day}';
  }

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
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _dayNames
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

  Widget _createAllDayMarker(Schedule schedule) {
    return Container(
        width: double.infinity,
        height: 6,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
            color: _markerColors[schedule.colorIndex % _markerColors.length]));
  }

  Widget _createHoursMarker(Schedule schedule) {
    return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _markerColors[schedule.colorIndex % _markerColors.length]));
  }

  Widget _createDayCell(DateTime dayDate, List<_ScheduleInfo> scheduleInfos) {
    final allDayMarkers = scheduleInfos
        .where((info) => info.schedule.type == ScheduleType.allDay)
        .map((info) => _createAllDayMarker(info.schedule));

    final hoursMarkers = scheduleInfos
        .where((info) => info.schedule.type == ScheduleType.hours)
        .map((info) => _createHoursMarker(info.schedule))
        .toList();

    return Expanded(
        child: Container(
            constraints: const BoxConstraints(minHeight: 58),
            child: Column(children: [
              _createDayLabel(dayDate),
              ...allDayMarkers,
              Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Wrap(spacing: 2, children: hoursMarkers))
            ])));
  }

  List<Widget> _createDayRows(BuildContext context) {
    final schedules = context.watch<SchedulesProvider>().getSchedules();

    // key: 각 날짜.
    // value: 해당 날짜에 있는 스케줄들.
    final Map<String, List<_ScheduleInfo>> scheduleMap = {};

    for (final schedule in schedules) {
      final dayDates = schedule.type == ScheduleType.hours
          ? [schedule.start]
          : CustomDateUtils.getDaysUntil(schedule.start, schedule.end);

      for (final dayDate in dayDates) {
        final key = _getDayKey(dayDate);

        if (!scheduleMap.containsKey(key)) {
          scheduleMap[key] = [];
        }

        scheduleMap[key]
            ?.add(_ScheduleInfo(schedule: schedule, dayCount: dayDates.length));
      }
    }

    // 각 날짜 안에서 스케줄들을 날 수별로 sorting.
    // - 스케줄 막대들이 안 끊기고 나오게 하기 위함. 이 방식 현재 버그 있어서 추후 새로운 방식 필요.
    // - ex. Widget 안 쓰고 캔버스로 직접 그려버리기.
    scheduleMap.forEach((key, infos) {
      infos.sort((info1, info2) => info2.dayCount - info1.dayCount);
    });

    return CustomDateUtils.getMonthCalendar(selectedMonthDate)
        .map((week) => Row(
            children: week
                .map((dayDate) => _createDayCell(
                    dayDate, scheduleMap[_getDayKey(dayDate)] ?? []))
                .toList()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 28),
        child:
            Column(children: [_createNameRow(), ..._createDayRows(context)]));
  }
}

class _ScheduleInfo {
  final Schedule schedule;
  final int dayCount;

  const _ScheduleInfo({required this.schedule, required this.dayCount});
}

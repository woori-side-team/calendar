import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/presentation/providers/schedules_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MonthView extends StatelessWidget {
  final DateTime monthDate;

  const MonthView({super.key, required this.monthDate});

  /// 날짜를 key로 하는 Map을 만들 때 사용.
  String _getDayKey(DateTime dayDate) {
    return '${dayDate.year}:${dayDate.month}:${dayDate.day}';
  }

  @override
  Widget build(BuildContext context) {
    final schedules = context.watch<SchedulesProvider>().selectedMonthSchedules;

    // key: 각 날짜.
    // value: 해당 날짜에 있는 스케줄들.
    final Map<String, List<_ScheduleInfo>> scheduleMap = {};

    for (final schedule in schedules) {
      final List<DateTime> dayDates = schedule.type == ScheduleType.hours
          ? [schedule.start]
          : CustomDateUtils.getDaysUntil(schedule.start, schedule.end);

      for (final dayDate in dayDates) {
        final key = _getDayKey(dayDate);

        if (!scheduleMap.containsKey(key)) {
          scheduleMap[key] = [];
        }

        scheduleMap[key]
            ?.add(_ScheduleInfo(schedule: schedule, dayDates: dayDates));
      }
    }

    // 각 날짜 안에서 스케줄들을 날 수별로 sorting.
    // - 스케줄 막대들이 안 끊기고 나오게 하기 위함. 이 방식 현재 버그 있어서 추후 새로운 방식 필요.
    // - ex. Widget 안 쓰고 캔버스로 직접 그려버리기.
    scheduleMap.forEach((key, infos) {
      infos.sort(
          (info1, info2) => info2.dayDates.length - info1.dayDates.length);
    });

    return Container(
        margin: const EdgeInsets.only(top: 28),
        child: Column(children: [
          const _NameRow(),
          ...CustomDateUtils.getMonthCalendar(monthDate).map((week) => Row(
              children: week
                  .map((dayDate) => _DayCell(
                      dayDate: dayDate,
                      scheduleInfos: scheduleMap[_getDayKey(dayDate)] ?? []))
                  .toList()))
        ]));
  }
}

class _NameRow extends StatelessWidget {
  static const _dayNames = ['일', '월', '화', '수', '목', '금', '토'];

  const _NameRow();

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _dayNames
            .mapIndexed((index, name) =>
                _NameCell(name: name, weekDay: index == 0 ? 7 : index))
            .toList());
  }
}

class _NameCell extends StatelessWidget {
  final String name;
  final int weekDay;

  const _NameCell({required this.name, required this.weekDay});

  @override
  Widget build(BuildContext context) {
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
}

class _DayCell extends StatelessWidget {
  final DateTime dayDate;
  final List<_ScheduleInfo> scheduleInfos;

  const _DayCell({required this.dayDate, required this.scheduleInfos});

  @override
  Widget build(BuildContext context) {
    final schedulesProvider = context.watch<SchedulesProvider>();

    final allDayMarkers = scheduleInfos
        .where((info) => info.schedule.type == ScheduleType.allDay)
        .map((info) => _AllDayMarker(schedule: info.schedule));

    final hoursMarkers = scheduleInfos
        .where((info) => info.schedule.type == ScheduleType.hours)
        .map((info) => _HoursMarker(schedule: info.schedule))
        .toList();

    return Expanded(
        child: GestureDetector(
      onTap: () {
        schedulesProvider.getOneDaySchedules(dayDate);

        context.pushNamed('dayPage',
            params: {'selectedDate': CustomDateUtils.dateToString(dayDate)});
      },
      child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          child: Column(children: [
            _DayLabel(dayDate: dayDate),
            ...allDayMarkers,
            Container(
                margin: const EdgeInsets.only(top: 2),
                child: Wrap(spacing: 2, children: hoursMarkers))
          ])),
    ));
  }
}

class _DayLabel extends StatelessWidget {
  final DateTime dayDate;

  const _DayLabel({required this.dayDate});

  @override
  Widget build(BuildContext context) {
    final selectedMonthDate =
        context.watch<SchedulesProvider>().getSelectedMonthDate();

    final now = CustomDateUtils.getNow();

    final decoration = !CustomDateUtils.areSameDays(now, dayDate)
        ? null
        : BoxDecoration(
            color: CustomTheme.background.secondary,
            borderRadius: BorderRadius.circular(8));

    final color = dayDate.month != selectedMonthDate.month
        ? CustomTheme.scale.scale3
        : _getCellColor(dayDate.weekday);

    return Container(
        width: double.infinity,
        height: 26,
        alignment: Alignment.center,
        decoration: decoration,
        child: Text('${dayDate.day}',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w400, color: color)));
  }
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

class _AllDayMarker extends StatelessWidget {
  final ScheduleModel schedule;

  const _AllDayMarker({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 6,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
            color: markerColors[schedule.colorIndex % markerColors.length]));
  }
}

class _HoursMarker extends StatelessWidget {
  final ScheduleModel schedule;

  const _HoursMarker({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: markerColors[schedule.colorIndex % markerColors.length]));
  }
}

class _ScheduleInfo {
  final ScheduleModel schedule;

  /// schedule에 해당하는 날들.
  /// ex. 일정이 2022.10.01 ~ 2022.10.05면 1일부터 5일까지.
  final List<DateTime> dayDates;

  const _ScheduleInfo({required this.schedule, required this.dayDates});
}

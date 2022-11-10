import 'package:calendar/domain/models/schedule_model.dart';
import 'package:flutter/material.dart';

class SchedulesProvider with ChangeNotifier {
  final List<ScheduleModel> _schedules = <ScheduleModel>[
    ScheduleModel(
        title: '개인',
        content: '공부하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 10, 28),
        end: DateTime(2022, 11, 2),
        colorIndex: 0),
    ScheduleModel(
        title: '개인',
        content: '종소세 내야해!',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 5),
        end: DateTime(2022, 11, 9),
        colorIndex: 1),
    ScheduleModel(
        title: '업무',
        content: '개발팀과 QA 미팅',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 1, 14 - 1),
        end: DateTime(2022, 11, 1, 15 - 1),
        colorIndex: 2),
    ScheduleModel(
        title: '업무',
        content: '가족 모임',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 1, 16 - 1),
        end: DateTime(2022, 11, 1, 17 - 1, 30),
        colorIndex: 3),
    ScheduleModel(
        title: '업무',
        content: '매니저님에게 기획서 전달',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 1, 17 - 1),
        end: DateTime(2022, 11, 1, 18 - 1, 30),
        colorIndex: 4),
    ScheduleModel(
        title: '개인',
        content: '기타 연습하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 4, 17 - 1),
        end: DateTime(2022, 11, 4, 18 - 1, 30),
        colorIndex: 5),
    ScheduleModel(
        title: '개인',
        content: '피아노 연습하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 4, 17 - 1),
        end: DateTime(2022, 11, 4, 18 - 1, 30),
        colorIndex: 6),
    ScheduleModel(
        title: '개인',
        content: '운동하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 11),
        end: DateTime(2022, 11, 11),
        colorIndex: 7),
    ScheduleModel(
        title: '개인',
        content: '운동하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 25),
        end: DateTime(2022, 11, 25),
        colorIndex: 8),
    ScheduleModel(
        title: '개인',
        content: 'Vue 공부하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 25, 17 - 1),
        end: DateTime(2022, 11, 25, 18 - 1, 30),
        colorIndex: 1),
    ScheduleModel(
        title: '개인',
        content: 'Svelte 공부하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 25, 17 - 1, 30),
        end: DateTime(2022, 11, 25, 18 - 1, 30),
        colorIndex: 0),
    ScheduleModel(
        title: '개인',
        content: 'React 공부하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 25),
        end: DateTime(2022, 11, 30),
        colorIndex: 2),
  ];

  List<ScheduleModel> getSchedules() {
    return _schedules;
  }

  final List<ScheduleModel> _oneDaySchedules = [];

  final List<int> _allDaySchedulesColorIndexes = [];

  List<ScheduleModel> get schedules => _schedules;

  List<ScheduleModel> get oneDaySchedules => _oneDaySchedules;

  /// day에 있는 스케줄 불러오기
  void loadOneDaySchedules(DateTime day) {
    // start와 end 사이에 있거나 같은가?
    bool isBetweenStartAndEnd(ScheduleModel schedule, DateTime day) {
      return day.isAfter(schedule.start) && day.isBefore(schedule.end) ||
          day.isAtSameMomentAs(schedule.start) ||
          day.isAtSameMomentAs(schedule.end);
    }

    bool isSameDay(DateTime scheduleTime, DateTime day) {
      return scheduleTime.year == day.year &&
          scheduleTime.month == day.month &&
          scheduleTime.day == day.day;
    }

    sortByDate();

    _oneDaySchedules.clear();
    _oneDaySchedules.addAll(_schedules.where((e) =>
        isSameDay(e.start, day) ||
        isSameDay(e.end, day) ||
        isBetweenStartAndEnd(e, day)));

    notifyListeners();
  }

  List<int> get allDaySchedulesColorIndexes => _allDaySchedulesColorIndexes;

  void addSchedule(int progressHours, DateTime day) {
    if (progressHours == 24) {
      return;
    }

    // 테스트용 시작 시간
    int startHour = _schedules.isEmpty ? 9 : _schedules.last.end.hour;
    int endHour = startHour + progressHours;

    _schedules.add(ScheduleModel(
        title: '${_schedules.length}번 요소',
        content: '공부하기',
        type: ScheduleType.hours,
        start: DateTime(day.year, day.month, day.day, startHour),
        end: DateTime(day.year, day.month, day.day, endHour),
        colorIndex: _schedules.length % 4));
    loadOneDaySchedules(day);
    notifyListeners();
  }

  void addAllDaySchedule(DateTime day) {
    // 테스트용 시작 시간
    int startHour = _schedules.isEmpty ? 9 : _schedules.last.end.hour;
    int endHour = startHour + 2;

    int listLength = _schedules.length;
    _schedules.add(ScheduleModel(
        title: '$listLength번 요소',
        content: '공부하기',
        type: ScheduleType.allDay,
        start: DateTime(day.year, day.month, day.day, startHour),
        end: DateTime(day.year, day.month, day.day, endHour),
        colorIndex: listLength % 4));

    _allDaySchedulesColorIndexes.add(listLength % 4);
    loadOneDaySchedules(day);
    notifyListeners();
  }

  void sortByDate() {
    _schedules.sort((a, b) => a.start.compareTo(b.start));

    notifyListeners();
  }
}

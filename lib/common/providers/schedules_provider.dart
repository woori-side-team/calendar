import 'package:calendar/common/models/schedule.dart';
import 'package:flutter/material.dart';

class SchedulesProvider with ChangeNotifier {
  final _schedules = <Schedule>[
    Schedule(
        tag: '개인',
        content: '공부하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 10, 28),
        end: DateTime(2022, 11, 2),
        colorIndex: 0),
    Schedule(
        tag: '개인',
        content: '종소세 내야해!',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 5),
        end: DateTime(2022, 11, 9),
        colorIndex: 3),
    Schedule(
        tag: '업무',
        content: '개발팀과 QA 미팅',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 1, 14 - 1),
        end: DateTime(2022, 11, 1, 15 - 1),
        colorIndex: 0),
    Schedule(
        tag: '업무',
        content: '가족 모임',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 1, 16 - 1),
        end: DateTime(2022, 11, 1, 17 - 1, 30),
        colorIndex: 1),
    Schedule(
        tag: '업무',
        content: '매니저님에게 기획서 전달',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 1, 17 - 1),
        end: DateTime(2022, 11, 1, 18 - 1, 30),
        colorIndex: 2),
    Schedule(
        tag: '개인',
        content: '기타 연습하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 4, 17 - 1),
        end: DateTime(2022, 11, 4, 18 - 1, 30),
        colorIndex: 2),
    Schedule(
        tag: '개인',
        content: '피아노 연습하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 4, 17 - 1),
        end: DateTime(2022, 11, 4, 18 - 1, 30),
        colorIndex: 1),
    Schedule(
        tag: '개인',
        content: '운동하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 11),
        end: DateTime(2022, 11, 11),
        colorIndex: 2),
    Schedule(
        tag: '개인',
        content: '운동하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 25),
        end: DateTime(2022, 11, 25),
        colorIndex: 2),
    Schedule(
        tag: '개인',
        content: 'Vue 공부하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 25, 17 - 1),
        end: DateTime(2022, 11, 25, 18 - 1, 30),
        colorIndex: 4),
    Schedule(
        tag: '개인',
        content: 'Svelte 공부하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 11, 25, 17 - 1, 30),
        end: DateTime(2022, 11, 25, 18 - 1, 30),
        colorIndex: 3),
    Schedule(
        tag: '개인',
        content: 'React 공부하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 25),
        end: DateTime(2022, 11, 3),
        colorIndex: 1),
  ];

  List<Schedule> getSchedules() {
    return _schedules;
  }
}

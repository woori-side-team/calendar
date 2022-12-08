import 'dart:async';

import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/common/utils/custom_string_utils.dart';
import 'package:calendar/common/utils/schedule_command_utils.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/domain/use_cases/schedule_use_cases.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class SchedulesProvider with ChangeNotifier {
  final AddScheduleUseCase _addScheduleUseCase;
  final GetSchedulesAtMonthUseCase _getSchedulesAtMonthUseCase;
  final DeleteAllSchedulesUseCase _deleteAllSchedulesUseCase;
  final DeleteScheduleUseCase _deleteScheduleUseCase;

  /// 변화 있을 때마다 이번 달 일정들을 미리 계산해서 여기에 캐싱.
  List<ScheduleModel> _selectedMonthSchedulesCache = [];

  /// 현재 선택한 달.
  var _selectedMonthDate = CustomDateUtils.toDay(CustomDateUtils.getNow());

  /// 일정 생성 테스트용.
  int _nextStartHour = 9;
  int _nextItemIndex = 0;

  SchedulesProvider(this._addScheduleUseCase, this._getSchedulesAtMonthUseCase,
      this._deleteAllSchedulesUseCase, this._deleteScheduleUseCase) {
    // 시작 때 필요 데이터 로딩.
    (() async {
      await _loadData();
      notifyListeners();
    })();
  }

  DateTime getSelectedMonthDate() {
    return _selectedMonthDate;
  }

  // async 때문에 setter 안 씀.
  Future<void> setSelectedMonthDate(DateTime value) async {
    _selectedMonthDate = value;

    await _loadData();
    notifyListeners();
  }

  List<ScheduleModel> get selectedMonthSchedules =>
      _selectedMonthSchedulesCache;

  List<ScheduleModel> get sortedSelectedMonthSchedules {
    final sortedList = [..._selectedMonthSchedulesCache];
    sortedList.sort((a, b) => a.start.compareTo(b.start));
    return sortedList;
  }

  /// day에 있는 스케줄 불러오기
  List<ScheduleModel> getOneDaySchedules(DateTime day) {
    // start와 end 사이에 있거나 같은가?
    bool isBetweenStartAndEnd(ScheduleModel schedule, DateTime day) {
      return day.isAfter(schedule.start) && day.isBefore(schedule.end) ||
          day.isAtSameMomentAs(schedule.start) ||
          day.isAtSameMomentAs(schedule.end);
    }

    return _selectedMonthSchedulesCache
        .where((e) =>
            CustomDateUtils.areSameDays(e.start, day) ||
            CustomDateUtils.areSameDays(e.end, day) ||
            isBetweenStartAndEnd(e, day))
        .toList();
  }

  /// [day]의 스케줄 리스트를 시간순으로 오름차순하고
  /// [ScheduleType]이 [ScheduleType.allDay]인 스케줄을
  /// 리스트의 앞으로 옮긴 리스트를 반환
  List<ScheduleModel> getSortedOneDaySchedules(DateTime day) {
    List<ScheduleModel> sortedList =
        getOneDaySchedules(day).sorted((a, b) => a.start.compareTo(b.start));
    List<ScheduleModel> sortedAllDayList =
        sortedList.where((e) => e.type == ScheduleType.allDay).toList();
    sortedList.removeWhere((e) => e.type == ScheduleType.allDay);
    sortedList.insertAll(0, sortedAllDayList);
    return sortedList;
  }

  /// 테스트용.
  Future<void> generateHoursSchedule(int progressHours, DateTime day) async {
    if (progressHours == 24) {
      return;
    }

    // 테스트용 시작 시간
    int startHour = _nextStartHour;
    int endHour = (startHour + progressHours) % 24;
    _nextStartHour = endHour;
    _nextItemIndex++;

    final schedule = ScheduleModel(
        id: CustomStringUtils.generateID(),
        title: '$_nextItemIndex번 요소',
        content: '공부하기',
        type: ScheduleType.hours,
        start: DateTime(day.year, day.month, day.day, startHour),
        end: DateTime(day.year, day.month, day.day, endHour),
        colorIndex: _nextItemIndex % 4);

    await _addScheduleUseCase(schedule);
    await _loadData();
    notifyListeners();
  }

  /// 테스트용.
  Future<void> generateAllDaySchedule(DateTime day) async {
    // 테스트용 시작 시간
    int startHour = _nextStartHour;
    int endHour = 24;
    DateTime realRecordedDateTime =
        DateTime(day.year, day.month, day.day, 23, 59, 59);
    _nextStartHour = (startHour + 2) % 24;
    _nextItemIndex++;

    final schedule = ScheduleModel(
        id: CustomStringUtils.generateID(),
        title: '$_nextItemIndex번 요소',
        content: '공부하기',
        type: ScheduleType.allDay,
        start: DateTime(day.year, day.month, day.day, startHour),
        end: realRecordedDateTime,
        colorIndex: _nextItemIndex % 4);

    await _addScheduleUseCase(schedule);
    await _loadData();
    notifyListeners();
  }

  Future<void> addSchedule(String command) async {
    String title = ScheduleCommandUtils.getTitle(command) ?? '';
    DateTime start = ScheduleCommandUtils.getDateTime(command);
    _nextItemIndex++;
    ScheduleModel schedule = ScheduleModel(
      id: CustomStringUtils.generateID(),
      title: title,
      content: '',
      type: ScheduleType.allDay,
      start: start,
      end: DateTime(start.year, start.month, start.day, 23, 59, 59),
      colorIndex: _nextItemIndex % 4,
    );
    await _addScheduleUseCase(schedule);
    await _loadData();
    notifyListeners();
  }

  /// 테스트용.
  Future<void> deleteAllSchedules() async {
    await _deleteAllSchedulesUseCase();
    await _loadData();
    notifyListeners();
  }

  Future<void> deleteSchedule(String id) async {
    await _deleteScheduleUseCase(id);
    await _loadData();
    notifyListeners();
  }

  /// DB에서 캐싱할 것들 로딩.
  Future<void> _loadData() async {
    _selectedMonthSchedulesCache =
        await _getSchedulesAtMonthUseCase(_selectedMonthDate);
  }
}

import 'dart:async';
import 'dart:collection';

import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/common/utils/custom_string_utils.dart';
import 'package:calendar/common/utils/debug_utils.dart';
import 'package:calendar/common/utils/notification_utils.dart';
import 'package:calendar/common/utils/schedule_command_utils.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/domain/use_cases/schedule_use_cases.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
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

  /// Month page 안의 캐러셀들용.
  final _neighborMonthDates = Queue<DateTime>();
  var _selectedNeighborMonthDateIndex = 0;

  SchedulesProvider(this._addScheduleUseCase, this._getSchedulesAtMonthUseCase,
      this._deleteAllSchedulesUseCase, this._deleteScheduleUseCase) {
    const dMonthMin = -5;
    const dMonthMax = 5;

    for (var dMonth = dMonthMin; dMonth <= dMonthMax; dMonth++) {
      _neighborMonthDates.addLast(
          DateTime(_selectedMonthDate.year, _selectedMonthDate.month + dMonth));
    }

    _selectedNeighborMonthDateIndex = -dMonthMin;

    // 시작 때 필요 데이터 로딩.
    (() async {
      await _loadData();
      notifyListeners();
    })();
  }

  Queue<DateTime> get neighborMonthDates => _neighborMonthDates;

  get selectedNeighborMonthDateIndex => _selectedNeighborMonthDateIndex;

  void selectNeighborMonthDate(int index) {
    if (index == 0) {
      _neighborMonthDates.addFirst(DateTime(
          _neighborMonthDates.first.year, _neighborMonthDates.first.month - 1));
      _selectedNeighborMonthDateIndex = 1;
    } else if (index == _neighborMonthDates.length - 1) {
      _neighborMonthDates.addLast(DateTime(
          _neighborMonthDates.last.year, _neighborMonthDates.last.month + 1));
      _selectedNeighborMonthDateIndex = _neighborMonthDates.length - 2;
    } else {
      _selectedNeighborMonthDateIndex = index;
    }

    _selectedMonthDate =
        _neighborMonthDates.elementAt(_selectedNeighborMonthDateIndex);

    _loadData();
    notifyListeners();
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

  Future<void> addSchedule(String command) async {
    DateTime? startDate = ScheduleCommandUtils.getStartDateTime(command);
    if (startDate == null) {
      return;
    }
    DateTime endDate = ScheduleCommandUtils.getEndDateTime(command, startDate,
        ScheduleCommandUtils.getStartDateTimeString(command)!);
    DebugUtils.print(startDate, alwaysPrint: true);
    DebugUtils.print(endDate, alwaysPrint: true);
    String title = ScheduleCommandUtils.getTitle(command) ?? '';
    ScheduleModel schedule = ScheduleModel(
        id: CustomStringUtils.generateID(),
        title: title,
        content: '',
        type: endDate.second == 59 ? ScheduleType.allDay : ScheduleType.hours,
        start: startDate,
        end: endDate,
        colorIndex: _selectedMonthSchedulesCache.length % markerColors.length,
        notificationInterval: NotificationTime.oneDay);
    await _addScheduleUseCase(schedule);
    await _loadData();
    await NotificationUtils().setNotification(schedule);
    notifyListeners();
  }

  Future<void> addScheduleBySaveButton(
      ScheduleModel schedule) async {
    await _addScheduleUseCase(schedule);
    await _loadData();
    await NotificationUtils().setNotification(schedule);
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
    await NotificationUtils().removeNotification(id);
    notifyListeners();
  }

  /// DB에서 캐싱할 것들 로딩.
  Future<void> _loadData() async {
    _selectedMonthSchedulesCache =
        await _getSchedulesAtMonthUseCase(_selectedMonthDate);
  }
}

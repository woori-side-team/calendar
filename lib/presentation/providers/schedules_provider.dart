import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/common/utils/custom_string_utils.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/domain/use_cases/schedule_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class SchedulesProvider with ChangeNotifier {
  final AddScheduleUseCase _addScheduleUseCase;
  final GetSchedulesAtMonthUseCase _getSchedulesAtMonthUseCase;
  final DeleteAllSchedulesUseCase _deleteAllSchedulesUseCase;

  /// 변화 있을 때마다 이번 달 일정들을 미리 계산해서 여기에 캐싱.
  List<ScheduleModel> _selectedMonthSchedulesCache = [];

  /// 현재 선택한 달.
  var _selectedMonthDate = CustomDateUtils.toDay(CustomDateUtils.getNow());

  /// 일정 생성 테스트용.
  int _nextStartHour = 9;
  int _nextItemIndex = 0;

  SchedulesProvider(this._addScheduleUseCase, this._getSchedulesAtMonthUseCase,
      this._deleteAllSchedulesUseCase) {
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

  get selectedMonthSchedules => _selectedMonthSchedulesCache;

  /// day에 있는 스케줄 불러오기
  List<ScheduleModel> getOneDaySchedules(DateTime day) {
    // start와 end 사이에 있거나 같은가?
    bool isBetweenStartAndEnd(ScheduleModel schedule, DateTime day) {
      return day.isAfter(schedule.start) && day.isBefore(schedule.end) ||
          day.isAtSameMomentAs(schedule.start) ||
          day.isAtSameMomentAs(schedule.end);
    }

    return selectedMonthSchedules
        .where((e) =>
            CustomDateUtils.areSameDays(e.start, day) ||
            CustomDateUtils.areSameDays(e.end, day) ||
            isBetweenStartAndEnd(e, day))
        .toList();
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
    int endHour = (startHour + 2) % 24;
    _nextStartHour = endHour;
    _nextItemIndex++;

    final schedule = ScheduleModel(
        id: CustomStringUtils.generateID(),
        title: '$_nextItemIndex번 요소',
        content: '공부하기',
        type: ScheduleType.allDay,
        start: DateTime(day.year, day.month, day.day, startHour),
        end: DateTime(day.year, day.month, day.day, endHour),
        colorIndex: _nextItemIndex % 4);

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

  /// DB에서 캐싱할 것들 로딩.
  Future<void> _loadData() async {
    _selectedMonthSchedulesCache =
        await _getSchedulesAtMonthUseCase(_selectedMonthDate);
  }
}

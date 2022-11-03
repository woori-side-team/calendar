import 'package:flutter/widgets.dart';

import '../models/schedule.dart';

class DayPageScheduleListProvider with ChangeNotifier {
  final List<Schedule> _schedules = [];
  final List<int> _allDaySchedulesColorIndexes = [];
  final scrollController = ScrollController();
  double bottomSheetPosition = 0;

  // 필요할 때만 bottomSheetPosition을 0로 만들기 위함
  bool _isScrollMax = false;

  List<Schedule> get schedules => _schedules;

  List<int> get allDaySchedulesColorIndexes => _allDaySchedulesColorIndexes;

  void init() {
    scrollController.addListener(() {
      if (!_isScrollMax && scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        bottomSheetPosition = 750;
        print('scrolled max');
        _isScrollMax = true;
        notifyListeners();
      }
      if (_isScrollMax &&
          scrollController.position.pixels <=
              scrollController.position.maxScrollExtent - 100) {
        bottomSheetPosition = 0;
        _isScrollMax = false;
        print('not scrolled max');
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void addSchedule(int progressHours) {
    if (progressHours == 24) {
      return;
    }

    // 테스트용 시작 시간
    int startHour = _schedules.isEmpty ? 9 : _schedules.last.end.hour;
    int endHour = startHour + progressHours;

    _schedules.add(Schedule(
        tag: '${_schedules.length}번 요소',
        content: '공부하기',
        type: ScheduleType.hours,
        start: DateTime(2022, 10, 10, startHour),
        end: DateTime(2022, 10, 10, endHour),
        colorIndex: _schedules.length % 4));
    notifyListeners();
  }

  void addAllDaySchedule(){
    // 테스트용 시작 시간
    int startHour = _schedules.isEmpty ? 9 : _schedules.last.end.hour;
    int endHour = startHour + 2;

    _schedules.add(Schedule(
        tag: '${_schedules.length}번 요소',
        content: '공부하기',
        type: ScheduleType.allDay,
        start: DateTime(2022, 10, 10, startHour),
        end: DateTime(2022, 10, 10, endHour),
        colorIndex: _schedules.length % 4));

    _allDaySchedulesColorIndexes.add(_schedules.length % 4);

    notifyListeners();
  }

  void sortByDate() {
    notifyListeners();
  }
}

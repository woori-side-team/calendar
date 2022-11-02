import 'package:flutter/widgets.dart';

import '../models/schedule.dart';

class DayPageScheduleListProvider with ChangeNotifier {
  final List<Schedule> _schedules = [];
  final scrollController = ScrollController();

  List<Schedule> get schedules => _schedules;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void addSchedule(int progressHours) {
    if(progressHours == 24){
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

  void sortByDate() {
    notifyListeners();
  }
}

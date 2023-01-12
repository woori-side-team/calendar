import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../common/utils/custom_string_utils.dart';
import '../../domain/models/schedule_model.dart';
import '../../domain/use_cases/schedule_use_cases.dart';

enum NotificationTime { tenMinute, thirtyMinute, oneHour, twoHour, oneDay }

@injectable
class AddSchedulePageProvider with ChangeNotifier {
  final AddScheduleUseCase _addScheduleUseCase;

  final _titleTextEditingController = TextEditingController();
  final _contentTextEditingController = TextEditingController();

  double _startTimeSpinnerScale = 0;
  double _endTimeSpinnerScale = 0;
  DateTime _startDateTime = CustomDateUtils.getNow();
  DateTime _endDateTime = CustomDateUtils.getNow().add(Duration(hours: 1));
  bool _isAllDay = false;
  NotificationTime _notificationTime = NotificationTime.oneDay;

  Color _tagColor = markerColors[0];

  AddSchedulePageProvider(this._addScheduleUseCase);

  get titleTextEditingController => _titleTextEditingController;

  get contentTextEditingController => _contentTextEditingController;

  double get startTimeSpinnerScale => _startTimeSpinnerScale;

  set startTimeSpinnerScale(double value) {
    _startTimeSpinnerScale = value;
    notifyListeners();
  }

  double get endTimeSpinnerScale => _endTimeSpinnerScale;

  set endTimeSpinnerScale(double value) {
    _endTimeSpinnerScale = value;
    notifyListeners();
  }

  bool get isAllDay => _isAllDay;

  set isAllDay(bool value) {
    _isAllDay = value;
    notifyListeners();
  }

  NotificationTime get notificationTime => _notificationTime;

  set notificationTime(NotificationTime value) {
    _notificationTime = value;
    notifyListeners();
  }

  Color get tagColor => _tagColor;

  set tagColor(Color value) {
    _tagColor = value;
    notifyListeners();
  }

  // Future<void> addSchedule() async {
  //   ScheduleModel schedule = ScheduleModel(
  //     id: CustomStringUtils.generateID(),
  //     title: _titleTextEditingController.text,
  //     content: _contentTextEditingController.text,
  //     type: _isAllDay ? ScheduleType.allDay : ScheduleType.hours,
  //     start: startDate,
  //     end: endDate,
  //     colorIndex: _nextItemIndex % 4,
  //   );
  // }
}

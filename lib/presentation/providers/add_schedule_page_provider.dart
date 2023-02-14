import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../common/utils/custom_string_utils.dart';
import '../../domain/models/schedule_model.dart';

enum NotificationTime {
  tenMinute('10분 전'),
  thirtyMinute('30분 전'),
  oneHour('1시간 전'),
  twoHour('2시간 전'),
  oneDay('1일 전');

  final String name;

  Duration toDuration() {
    late Duration result;
    switch(this) {
      case NotificationTime.tenMinute:
        result = const Duration(minutes: 10);
        break;
      case NotificationTime.thirtyMinute:
        result = const Duration(minutes: 30);
        break;
      case NotificationTime.oneHour:
        result = const Duration(hours: 1);
        break;
      case NotificationTime.twoHour:
        result = const Duration(hours: 2);
        break;
      case NotificationTime.oneDay:
        result = const Duration(days: 1);
        break;
    }
    return result;
  }

  const NotificationTime(this.name);
}

class AddSchedulePageProvider with ChangeNotifier {
  final _titleTextEditingController = TextEditingController();
  final _contentTextEditingController = TextEditingController();

  double _startTimeSpinnerScale = 0.001;
  double _endTimeSpinnerScale = 0.001;
  DateTime _startDateTime = CustomDateUtils.getNow();

  // only hour and minute
  DateTime _startTime = CustomDateUtils.getNow();
  String _startDateString = CustomDateUtils.formatDateStringExceptHourMinute(
      CustomDateUtils.getNow());
  String _startTimeString = DateFormat('H:mm').format(CustomDateUtils.getNow());
  DateTime _endDateTime =
      CustomDateUtils.getNow().add(const Duration(hours: 1));

  // only hour and minute
  DateTime _endTime = CustomDateUtils.getNow().add(const Duration(hours: 1));
  String _endDateString = CustomDateUtils.formatDateStringExceptHourMinute(
      CustomDateUtils.getNow().add(const Duration(hours: 1)));
  String _endTimeString = DateFormat('H:mm')
      .format(CustomDateUtils.getNow().add(const Duration(hours: 1)));

  bool _isAllDay = false;
  NotificationTime _notificationTime = NotificationTime.oneDay;
  int _tagColorIndex = 0;
  bool _isEditMode = false;
  String? _scheduleId;

  get titleTextEditingController => _titleTextEditingController;

  get contentTextEditingController => _contentTextEditingController;

  double get startTimeSpinnerScale => _startTimeSpinnerScale;

  double get endTimeSpinnerScale => _endTimeSpinnerScale;

  bool get isAllDay => _isAllDay;

  NotificationTime get notificationTime => _notificationTime;

  int get tagColorIndex => _tagColorIndex;

  String get startDateString => _startDateString;

  String get startTimeString => _startTimeString;

  String get endDateString => _endDateString;

  String get endTimeString => _endTimeString;

  DateTime get startDateTime => _startDateTime;

  DateTime get endDateTime => _endDateTime;

  DateTime get endTime => _endTime;

  bool get isEditMode => _isEditMode;

  set startTimeSpinnerScale(double value) {
    _startTimeSpinnerScale = value;
    notifyListeners();
  }

  set endTimeSpinnerScale(double value) {
    _endTimeSpinnerScale = value;
    notifyListeners();
  }

  set isAllDay(bool value) {
    _isAllDay = value;
    _endTime = CustomDateUtils.getEndOfThisDay(_endTime);
    _endTimeString = '24:00';
    notifyListeners();
  }

  set notificationTime(NotificationTime value) {
    _notificationTime = value;
    notifyListeners();
  }

  set tagColorIndex(int value) {
    _tagColorIndex = value;
    notifyListeners();
  }

  set startTime(DateTime value) {
    _startTime = value;
    notifyListeners();
  }

  set startDateTime(DateTime value) {
    _startDateTime = value;

    if (_startDateTime.isAfter(_endDateTime) ||
        _startDateTime.isAtSameMomentAs(_endDateTime)) {
      _endDateTime = _startDateTime;
      _endDateString =
          CustomDateUtils.formatDateStringExceptHourMinute(_endDateTime);
    }

    _startDateString =
        CustomDateUtils.formatDateStringExceptHourMinute(_startDateTime);
    notifyListeners();
  }

  set endTime(DateTime value) {
    _endTime = value;
    notifyListeners();
  }

  set endDateTime(DateTime value) {
    _endDateTime = value;
    _endDateString =
        CustomDateUtils.formatDateStringExceptHourMinute(_endDateTime);
    notifyListeners();
  }

  void customDispose() {
    _titleTextEditingController.text = '';
    _contentTextEditingController.text = '';

    _startTimeSpinnerScale = 0.001;
    _endTimeSpinnerScale = 0.001;
    _startDateTime = CustomDateUtils.getNow();

    _startTime = CustomDateUtils.getNow();
    _startDateString = CustomDateUtils.formatDateStringExceptHourMinute(
        CustomDateUtils.getNow());
    _startTimeString = DateFormat('H:mm').format(CustomDateUtils.getNow());
    _endDateTime = CustomDateUtils.getNow().add(const Duration(hours: 1));

    _endTime = CustomDateUtils.getNow().add(const Duration(hours: 1));
    _endDateString = CustomDateUtils.formatDateStringExceptHourMinute(
        CustomDateUtils.getNow().add(const Duration(hours: 1)));
    _endTimeString = DateFormat('H:mm')
        .format(CustomDateUtils.getNow().add(const Duration(hours: 1)));

    _isAllDay = false;
    _notificationTime = NotificationTime.oneDay;
    _tagColorIndex = 0;
  }

  void init({DateTime? dateTimeInDayPage}) {
    _isEditMode = false;

    _titleTextEditingController.text = '';
    _contentTextEditingController.text = '';

    _startTimeSpinnerScale = 0.001;
    _endTimeSpinnerScale = 0.001;
    _startDateTime = dateTimeInDayPage ?? CustomDateUtils.getNow();

    _startTime = dateTimeInDayPage == null
        ? CustomDateUtils.getNow()
        : CustomDateUtils.getMidnightOfThisDay(dateTimeInDayPage)
            .add(const Duration(hours: 8));
    _startDateString =
        CustomDateUtils.formatDateStringExceptHourMinute(_startTime);
    _startTimeString = DateFormat('H:mm').format(_startTime);
    _endDateTime = _startTime.add(const Duration(hours: 1));

    _endTime = _startTime.add(const Duration(hours: 1));
    _endDateString = CustomDateUtils.formatDateStringExceptHourMinute(
        _startTime.add(const Duration(hours: 1)));
    _endTimeString =
        DateFormat('H:mm').format(_startTime.add(const Duration(hours: 1)));

    _isAllDay = false;
    _notificationTime = NotificationTime.oneDay;
    _tagColorIndex = 0;
  }

  void initWithSchedule(ScheduleModel schedule) {
    _isEditMode = true;
    _scheduleId = schedule.id;

    _titleTextEditingController.text = schedule.title;
    _contentTextEditingController.text = schedule.content;

    _startTimeSpinnerScale = 0.001;
    _endTimeSpinnerScale = 0.001;
    _startDateTime = schedule.start;

    _startTime = schedule.start;
    _startDateString =
        CustomDateUtils.formatDateStringExceptHourMinute(schedule.start);
    _startTimeString = DateFormat('H:mm').format(schedule.start);
    _endDateTime = schedule.end;

    _endTime = schedule.end;
    _endDateString =
        CustomDateUtils.formatDateStringExceptHourMinute(schedule.end);
    _endTimeString = DateFormat('H:mm').format(schedule.end);

    _isAllDay = schedule.type == ScheduleType.allDay ? true : false;
    //TODO: model에 noti 변수 추가하고 다시 수정하기
    _notificationTime = NotificationTime.oneDay;
    _tagColorIndex = schedule.colorIndex;
  }

  void changeStartTimeSpinnerScale() {
    _startTimeSpinnerScale = _startTimeSpinnerScale == 0.001 ? 0.99 : 0.001;
    _startTimeString = DateFormat('H:mm').format(_startTime);

    if (_startTime.isAfter(_endTime) || _startTime.isAtSameMomentAs(_endTime)) {
      _endTime = _startTime.add(const Duration(hours: 1));
      _endTimeString = DateFormat('H:mm').format(_endTime);
    }

    notifyListeners();
  }

  void changeEndTimeSpinnerScale() {
    _endTimeSpinnerScale = _endTimeSpinnerScale == 0.001 ? 0.99 : 0.001;
    _endTimeString = DateFormat('H:mm').format(_endTime);

    if (CustomDateUtils.combineYearMonthDayAndHourMinute(_endDateTime, _endTime)
            .isBefore(CustomDateUtils.combineYearMonthDayAndHourMinute(
                _startDateTime, _startTime)) ||
        CustomDateUtils.combineYearMonthDayAndHourMinute(_endDateTime, _endTime)
            .isAtSameMomentAs(CustomDateUtils.combineYearMonthDayAndHourMinute(
                _startDateTime, _startTime))) {
      _endDateTime = _endDateTime.add(const Duration(days: 1));
    }
    _endDateString =
        CustomDateUtils.formatDateStringExceptHourMinute(_endDateTime);

    notifyListeners();
  }

  ScheduleModel getSchedule() {
    DateTime start = CustomDateUtils.combineYearMonthDayAndHourMinute(
        _startDateTime, _startTime);
    DateTime end = CustomDateUtils.combineYearMonthDayAndHourMinute(
        _endDateTime, _endTime);

    assert(!start.isAfter(end) && !start.isAtSameMomentAs(end),
        'AddSchedulePageProvider: addSchedule error. start must be before end');

    if (!CustomDateUtils.areSameDays(start, end)) {
      _isAllDay = true;
    }

    ScheduleModel result = ScheduleModel(
      id: !_isEditMode ? CustomStringUtils.generateID() : _scheduleId!,
      title: _titleTextEditingController.text,
      content: _contentTextEditingController.text,
      type: _isAllDay ? ScheduleType.allDay : ScheduleType.hours,
      start: start,
      end: end,
      colorIndex: _tagColorIndex,
    );

    return result;
  }
}

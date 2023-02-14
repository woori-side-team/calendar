import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

enum ScheduleType {
  /// 하루 종일. (n일)
  allDay,

  /// 몇 시간. (무조건 1일)
  hours
}

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

@freezed
class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel(
      {required String id,
      required String title,
      required String content,
      required ScheduleType type,
      required DateTime start,
      required DateTime end,
      required int colorIndex,
      required NotificationTime notificationInterval}) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, Object?> json) =>
      _$ScheduleModelFromJson(json);
}

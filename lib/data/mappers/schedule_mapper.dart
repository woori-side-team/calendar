import 'package:calendar/data/data_sources/local/schedule_entity.dart';
import 'package:calendar/domain/models/schedule_model.dart';

extension ToScheduleModel on ScheduleEntity {
  ScheduleModel toScheduleModel() {
    return ScheduleModel(
        id: id,
        title: title,
        content: content,
        type: ScheduleType.values[type],
        start: start,
        end: end,
        colorIndex: colorIndex,
        notificationInterval: notificationMinute.toNotificationTime());
  }
}

extension ToScheduleEntity on ScheduleModel {
  ScheduleEntity toScheduleEntity() {
    return ScheduleEntity(
      id: id,
      title: title,
      content: content,
      type: type.index,
      start: start,
      end: end,
      colorIndex: colorIndex,
      notificationMinute: notificationInterval.toNotificationInterval(),
    );
  }
}

extension ToNotificationInterval on NotificationTime {
  int toNotificationInterval() {
    switch (this) {
      case NotificationTime.tenMinute:
        return 10;
      case NotificationTime.thirtyMinute:
        return 30;
      case NotificationTime.oneHour:
        return 60;
      case NotificationTime.twoHour:
        return 120;
      case NotificationTime.oneDay:
        return 1440;
      default:
        assert(false, 'ToNotificationInterval error');
        return -1;
    }
  }
}

extension ToNotificationTime on int {
  NotificationTime toNotificationTime() {
    switch (this) {
      case 10:
        return NotificationTime.tenMinute;
      case 30:
        return NotificationTime.thirtyMinute;
      case 60:
        return NotificationTime.oneHour;
      case 120:
        return NotificationTime.twoHour;
      case 1440:
        return NotificationTime.oneDay;
      default:
        assert(false, 'ToNotificationTime error');
        return NotificationTime.oneDay;
    }
  }
}

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
        colorIndex: colorIndex);
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
        colorIndex: colorIndex);
  }
}

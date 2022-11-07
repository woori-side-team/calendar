import 'package:calendar/data/data_sources/local/schedule_entity.dart';
import 'package:calendar/domain/models/schedule_model.dart';

extension ToScheduleModel on ScheduleEntity {
  ScheduleModel toScheduleModel() {
    return ScheduleModel(
        title: title,
        content: content,
        type: ScheduleType.values[type],
        start: start,
        end: end,
        colorIndex: colorIndex);
  }
}

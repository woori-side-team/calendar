import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

enum ScheduleType {
  /// 하루 종일. (n일)
  allDay,

  /// 몇 시간. (무조건 1일)
  hours
}

@freezed
class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel(
      {required String title,
      required String content,
      required ScheduleType type,
      required DateTime start,
      required DateTime end,
      required int colorIndex}) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, Object?> json) =>
      _$ScheduleModelFromJson(json);
}

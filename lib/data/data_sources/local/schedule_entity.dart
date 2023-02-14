import 'package:hive/hive.dart';

part 'schedule_entity.g.dart';

@HiveType(typeId: 0)
class ScheduleEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  int type;

  @HiveField(4)
  DateTime start;

  @HiveField(5)
  DateTime end;

  @HiveField(6)
  int colorIndex;

  @HiveField(7)
  int notificationMinute;

  ScheduleEntity(
      {required this.id,
      required this.title,
      required this.content,
      required this.type,
      required this.start,
      required this.end,
      required this.colorIndex,
      required this.notificationMinute});
}

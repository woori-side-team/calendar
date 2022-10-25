enum ScheduleType { allDay, hours }

class Schedule {
  final String tag;
  final String content;
  final ScheduleType type;
  final DateTime start;
  final DateTime end;
  final int colorIndex;

  const Schedule(
      {required this.tag,
      required this.content,
      required this.type,
      required this.start,
      required this.end,
      required this.colorIndex});
}

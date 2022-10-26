enum ScheduleType {
  /// 하루 종일. (n일)
  allDay,

  /// 몇 시간. (무조건 1일)
  hours
}

/// 각 일정을 표현.
class Schedule {
  /// 태그. (ex. '업무')
  final String tag;

  /// 내용. (ex. '종소세 내야해!')
  final String content;

  /// 종류.
  final ScheduleType type;

  /// 일정 시작.
  final DateTime start;

  /// 일정 끝.
  final DateTime end;

  /// 일정 표시 색깔.
  final int colorIndex;

  const Schedule(
      {required this.tag,
      required this.content,
      required this.type,
      required this.start,
      required this.end,
      required this.colorIndex});
}

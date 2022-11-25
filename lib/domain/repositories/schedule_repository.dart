import 'package:calendar/domain/models/schedule_model.dart';

abstract class ScheduleRepository {
  /// start >= minDate이고 end <= maxDate인 일정들 가져오기.
  Future<List<ScheduleModel>> getSchedulesBetweenDays(
      DateTime minDayDate, DateTime maxDayDate);

  Future<ScheduleModel?> getScheduleByID(String id);

  Future<void> addSchedule(ScheduleModel scheduleModel);

  Future<void> updateSchedule(ScheduleModel scheduleModel);

  Future<void> deleteSchedule(String id);

  /// 일정 모두 삭제. (-> 주로 디버깅, 테스트용)
  Future<void> deleteAllSchedules();

  Future<List<ScheduleModel>> getAllSchedules(String inputString);
}

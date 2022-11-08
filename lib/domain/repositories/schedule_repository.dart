abstract class ScheduleRepository {
  Future<void> insertSchedule();

  Future<void> updateSchedule();

  Future<void> deleteSchedule();

  Future<void> getAllSchedules();
}

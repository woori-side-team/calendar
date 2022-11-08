import 'package:calendar/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  @override
  Future<void> deleteSchedule() async {}

  @override
  Future<void> getAllSchedules() async {}

  @override
  Future<void> insertSchedule() async {}

  @override
  Future<void> updateSchedule() async {}
}

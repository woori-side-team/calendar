import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddScheduleUseCase {
  final ScheduleRepository _scheduleRepository;

  const AddScheduleUseCase(this._scheduleRepository);

  Future<void> call(ScheduleModel scheduleModel) async {
    await _scheduleRepository.addSchedule(scheduleModel);
  }
}

@injectable
class GetSchedulesAtMonthUseCase {
  final ScheduleRepository _scheduleRepository;

  const GetSchedulesAtMonthUseCase(this._scheduleRepository);

  Future<List<ScheduleModel>> call(DateTime monthDate) async {
    return await _scheduleRepository.getSchedulesBetweenDays(
        DateTime(monthDate.year, monthDate.month, 1),
        DateTime(monthDate.year, monthDate.month + 1, 0));
  }
}

@injectable
class DeleteAllSchedulesUseCase {
  final ScheduleRepository _scheduleRepository;

  const DeleteAllSchedulesUseCase(this._scheduleRepository);

  Future<void> call() async {
    await _scheduleRepository.deleteAllSchedules();
  }
}

import 'package:calendar/common/utils/custom_date_utils.dart';
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

  Future<List<ScheduleModel>> call() async {
    DateTime now = CustomDateUtils.getNow();
    return await _scheduleRepository.getSchedulesBetweenDays(
        DateTime(now.year, now.month, now.day),
        DateTime(now.year, now.month, now.day).add(const Duration(days: 30)));
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

@injectable
class DeleteScheduleUseCase {
  final ScheduleRepository _scheduleRepository;

  const DeleteScheduleUseCase(this._scheduleRepository);

  Future<void> call(String id) async {
    await _scheduleRepository.deleteSchedule(id);
  }
}

@injectable
class SearchScheduleUseCase {
  final ScheduleRepository _scheduleRepository;

  const SearchScheduleUseCase(this._scheduleRepository);

  Future<List<ScheduleModel>> call(String inputString) async {
    if (inputString == '') return [];

    var schedules = await _scheduleRepository.getAllSchedules(inputString);
    var searchedSchedules = schedules
        .where((e) =>
            e.title.contains(inputString) || e.content.contains(inputString))
        .toList();
    searchedSchedules.sort((a, b) => a.start.compareTo(b.start));
    return searchedSchedules;
  }
}
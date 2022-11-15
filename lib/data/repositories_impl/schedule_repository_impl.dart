import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/data/data_sources/local/schedule_entity.dart';
import 'package:calendar/data/mappers/schedule_mapper.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/domain/repositories/schedule_repository.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final _tableName = 'schedules';

  @override
  Future<List<ScheduleModel>> getSchedulesBetweenDays(
      DateTime minDayDate, DateTime maxDayDate) async {
    final box = await Hive.openLazyBox<ScheduleEntity>(_tableName);

    // 안전을 위해...
    final safeMinDayDate = CustomDateUtils.toDay(minDayDate);
    final safeMaxDayDate = CustomDateUtils.toDay(maxDayDate);

    final List<ScheduleModel> models = [];

    await Future.forEach(box.keys, (id) async {
      final entity = await box.get(id);

      if (entity == null) {
        return;
      }

      final startDayDate = CustomDateUtils.toDay(entity.start);
      final endDayDate = CustomDateUtils.toDay(entity.end);

      if (startDayDate.compareTo(safeMinDayDate) >= 0 &&
          endDayDate.compareTo(safeMaxDayDate) <= 0) {
        models.add(entity.toScheduleModel());
      }
    });

    // await box.close();
    return models;
  }

  @override
  Future<ScheduleModel?> getScheduleByID(String id) async {
    final box = await Hive.openLazyBox<ScheduleEntity>(_tableName);
    final entity = await box.get(id);
    // await box.close();
    return entity?.toScheduleModel();
  }

  @override
  Future<void> addSchedule(ScheduleModel scheduleModel) async {
    final box = await Hive.openLazyBox<ScheduleEntity>(_tableName);
    await box.put(scheduleModel.id, scheduleModel.toScheduleEntity());
    // await box.close();
  }

  @override
  Future<void> updateSchedule(ScheduleModel scheduleModel) async {
    final box = await Hive.openLazyBox<ScheduleEntity>(_tableName);
    await box.put(scheduleModel.id, scheduleModel.toScheduleEntity());
    // await box.close();
  }

  @override
  Future<void> deleteSchedule(String id) async {
    final box = await Hive.openLazyBox<ScheduleEntity>(_tableName);
    await box.delete(id);
    // await box.close();
  }

  @override
  Future<void> deleteAllSchedules() async {
    final box = await Hive.openLazyBox<ScheduleEntity>(_tableName);
    await box.clear();
    // await box.close();
  }
}

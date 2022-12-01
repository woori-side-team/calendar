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

  // box.values를 쓰려면 openLazyBox 대신 openBox를 써야 해서
  // 다 openBox로 교체
  @override
  Future<List<ScheduleModel>> getSchedulesBetweenDays(
      DateTime minDayDate, DateTime maxDayDate) async {
    final box = await Hive.openBox<ScheduleEntity>(_tableName);

    // 안전을 위해...
    final safeMinDayDate = CustomDateUtils.toDay(minDayDate);
    final safeMaxDayDate = CustomDateUtils.toDay(maxDayDate);

    final List<ScheduleModel> models = [];

    await Future.forEach(box.keys, (id) async {
      final entity = box.get(id);

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
    final box = await Hive.openBox<ScheduleEntity>(_tableName);
    final entity = box.get(id);
    // await box.close();
    return entity?.toScheduleModel();
  }

  @override
  Future<void> addSchedule(ScheduleModel scheduleModel) async {
    final box = await Hive.openBox<ScheduleEntity>(_tableName);
    await box.put(scheduleModel.id, scheduleModel.toScheduleEntity());
    // await box.close();
  }

  @override
  Future<void> updateSchedule(ScheduleModel scheduleModel) async {
    final box = await Hive.openBox<ScheduleEntity>(_tableName);
    await box.put(scheduleModel.id, scheduleModel.toScheduleEntity());
    // await box.close();
  }

  @override
  Future<void> deleteSchedule(String id) async {
    final box = await Hive.openBox<ScheduleEntity>(_tableName);
    await box.delete(id);
    // await box.close();
  }

  @override
  Future<void> deleteAllSchedules() async {
    final box = await Hive.openBox<ScheduleEntity>(_tableName);
    await box.clear();
    // await box.close();
  }

  @override
  Future<List<ScheduleModel>> getAllSchedules(String inputString) async {
    // box.values를 쓰려면 openLazyBox 대신 openBox를 써야 함.
    final box = await Hive.openBox<ScheduleEntity>(_tableName);
    var entities = box.values.toList();
    List<ScheduleModel> models = [];
    for(var item in entities){
      models.add(item.toScheduleModel());
    }
    return models;
  }
}

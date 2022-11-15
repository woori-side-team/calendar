import 'package:calendar/common/di/di.dart';
import 'package:calendar/data/data_sources/local/schedule_entity.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/domain/use_cases/schedule_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  Hive.init('Test');
  Hive.registerAdapter(ScheduleEntityAdapter());

  test('use case test', () async {
    final addScheduleUseCase = getIt<AddScheduleUseCase>();
    final getSchedulesAtMonthUseCase = getIt<GetSchedulesAtMonthUseCase>();
    final deleteAllSchedulesUseCase = getIt<DeleteAllSchedulesUseCase>();

    final model1 = ScheduleModel(
        id: '1',
        title: '1',
        content: '',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 11),
        end: DateTime(2022, 11, 13),
        colorIndex: 0);

    await addScheduleUseCase(model1);
    var models = await getSchedulesAtMonthUseCase(model1.start);
    expect(models[0].start.month, model1.start.month);

    await deleteAllSchedulesUseCase();
    models = await getSchedulesAtMonthUseCase(model1.start);
    expect(models.length, 0);
  });
}

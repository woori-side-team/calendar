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

  test('schedule use case test', () async {
    final addScheduleUseCase = getIt<AddScheduleUseCase>();
    final getSchedulesAtMonthUseCase = getIt<GetSchedulesAtMonthUseCase>();
    final deleteAllSchedulesUseCase = getIt<DeleteAllSchedulesUseCase>();
    final searchScheduleUseCase = getIt<SearchScheduleUseCase>();

    final model1 = ScheduleModel(
        id: '1',
        title: '1',
        content: '',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 11),
        end: DateTime(2022, 11, 13),
        colorIndex: 0,
        notificationInterval: NotificationTime.oneDay);

    await addScheduleUseCase(model1);
    var models = await getSchedulesAtMonthUseCase();
    expect(models[0].start.month, model1.start.month);

    await deleteAllSchedulesUseCase();
    models = await getSchedulesAtMonthUseCase();
    expect(models.length, 0);

    await addScheduleUseCase(model1);
    await addScheduleUseCase(model1.copyWith(id: '2', title: '11'));
    await addScheduleUseCase(
        model1.copyWith(id: '3', title: '22', content: '1'));
    await addScheduleUseCase(
        model1.copyWith(id: '4', title: '22', content: '2'));
    var searchedResult = await searchScheduleUseCase('1');
    expect(searchedResult[0].title, '1');
    expect(searchedResult[1].title, '11');
    expect(searchedResult.length, 3);
  });
}

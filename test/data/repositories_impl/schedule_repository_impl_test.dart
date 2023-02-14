import 'package:calendar/data/data_sources/local/schedule_entity.dart';
import 'package:calendar/data/repositories_impl/schedule_repository_impl.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  test('schedule repo impl test', () async {
    Hive.init('Test');
    Hive.registerAdapter(ScheduleEntityAdapter());
    final repository = ScheduleRepositoryImpl();

    final model1 = ScheduleModel(
        id: '1',
        title: '1',
        content: '',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 11),
        end: DateTime(2022, 11, 13),
        colorIndex: 0,
        notificationInterval: NotificationTime.oneDay);

    final model2 = ScheduleModel(
        id: '2',
        title: '2',
        content: '',
        type: ScheduleType.allDay,
        start: DateTime(2022, 11, 12),
        end: DateTime(2022, 11, 13),
        colorIndex: 0,
        notificationInterval: NotificationTime.oneDay);

    // Test insert.
    await repository.addSchedule(model1);
    await repository.addSchedule(model2);

    var schedulesInRange = await repository.getSchedulesBetweenDays(
        DateTime(2022, 11, 11), DateTime(2022, 11, 15));
    expect(schedulesInRange[0].title, model1.title);
    expect(schedulesInRange[1].title, model2.title);

    schedulesInRange = await repository.getSchedulesBetweenDays(
        DateTime(2022, 11, 12), DateTime(2022, 11, 15));
    expect(schedulesInRange[0].title, model2.title);

    // Test update.
    const newContent = 'Hello';
    await repository.updateSchedule(model2.copyWith(content: newContent));
    final model2FromDB = await repository.getScheduleByID(model2.id);
    expect(model2FromDB?.content, newContent);

    // Test delete.
    await repository.deleteSchedule(model2.id);
    schedulesInRange = await repository.getSchedulesBetweenDays(
        DateTime(2022, 11, 12), DateTime(2022, 11, 15));
    expect(schedulesInRange.length, 0);

    // Test delete all.
    await repository.deleteAllSchedules();
    schedulesInRange = await repository.getSchedulesBetweenDays(
        DateTime(2022, 11, 1), DateTime(2022, 11, 15));
    expect(schedulesInRange.length, 0);
  });
}

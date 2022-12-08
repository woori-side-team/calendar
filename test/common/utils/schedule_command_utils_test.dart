import 'package:calendar/common/utils/schedule_command_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('command test', () {
    expect('2022-12-21', ScheduleCommandUtils.getDateString('12232022-12-21'));
    expect('2022년 12월 21일',
        ScheduleCommandUtils.getDateString('12232022년 12월 21일'));
    expect('7시 30분', ScheduleCommandUtils.getHourMinuteString('3457시 30분45'));
    expect('7시', ScheduleCommandUtils.getHourMinuteString('3457시'));
    expect(' ', ScheduleCommandUtils.getTitle('7시 30분 2022년 12월 30일'));

    List<String> dateList = '2022년12-21'.split(RegExp(r'-|\.|\/|년|월|일'));
    expect(dateList[0], '2022');
    expect(DateTime(2023, 1, 1), ScheduleCommandUtils.getDateTime('1월 1일'));
    List<String> dateList2 = '15시'.split(RegExp(r'시|:'));
    expect('15', dateList2[0]);
    expect('', dateList2[1]);
    expect(2, dateList2.length);
  });
}

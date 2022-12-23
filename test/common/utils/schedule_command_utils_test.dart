import 'package:calendar/common/utils/schedule_command_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('command test', () {
    expect('7시 30분', ScheduleCommandUtils.getHourMinuteString('3457시 30분45'));
    expect('7시', ScheduleCommandUtils.getHourMinuteString('3457시'));
    expect(' ', ScheduleCommandUtils.getTitle('7시 30분 2022년 12월 30일'));

    List<String> dateList = '2022년12-21'.split(RegExp(r'-|\.|\/|년|월|일'));
    expect(dateList[0], '2022');
    List<String> dateList2 = '15시'.split(RegExp(r'시|:'));
    expect('15', dateList2[0]);
    expect('', dateList2[1]);
    expect(2, dateList2.length);
    expect(1, ''.split(' ').length);
    expect('1', '20201'.split('2020')[1][0]);
    expect('-01234'.replaceFirst(RegExp(r'-|~'), ''), '01234');
    //expect('2020-11-25', ScheduleCommandUtils.getEndDateTime('2020-11-20-2020-11-25'));
    expect(DateTime(2023, 3, 3, 15, 14), ScheduleCommandUtils.getStartDateTimeWithFullForm('2023-3-3 15시 14'));
    expect(DateTime(2023, 3, 3, 15), ScheduleCommandUtils.getStartDateTimeWithFullForm('2023-3-3 15시'));
    expect(null, ScheduleCommandUtils.getStartDateTimeWithFullForm('202-3-3 15시'));
    expect(DateTime(2023, 11, 11), ScheduleCommandUtils.getStartDateTimeWithoutYear('11월 11일'));
    expect(DateTime(2023, 1, 11), ScheduleCommandUtils.getStartDateTimeWithoutYearAndMonth('11일'));
    expect('2020-2-2 1시', ScheduleCommandUtils.removeAmPm('2020-2-2 오전 1시'));
    expect(true, ScheduleCommandUtils.isEndWithRangeSymbol('2020-2-2 오전 1시-'));
    expect('2020 2 2', ScheduleCommandUtils.getEndDateTimeWithNumberAndBlank('2020 2 2', DateTime(2020, 2, 1)));
  });
}

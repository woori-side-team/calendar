import 'package:calendar/common/utils/custom_date_utils.dart';

class ScheduleCommandUtils {
  static String trimSpace(String command) {
    return command.replaceAll(' ', '');
  }

  static String? getDateString(String command) {
    // ([12][0-9]|3[01]|0?[1-9]) 이 부분 순서 중요
    // 0?[1-9]가 앞으로 가면 숫자 하나만 인식
    return RegExp(
            r'((19|20)\d\d([- /.년]))? *(0?[1-9]|1[012])([- /.월]) *([12][0-9]|3[01]|0?[1-9])일?')
        .firstMatch(command)
        ?.group(0);
  }

  static String? getHourMinuteString(String command) {
    return RegExp(r'[0-2]?[0-9](시|:) ?([0-5]?[0-9]분?)?')
        .firstMatch(command)
        ?.group(0);
  }

  static DateTime getDateTime(String command) {
    String date = trimSpace(getDateString(command) ?? '');
    String hourMinute = trimSpace(getHourMinuteString(command) ?? '');
    final DateTime now = CustomDateUtils.getNow();

    if (hourMinute == '') {
      hourMinute = '00:00';
    }
    List<String> hourMinuteList = hourMinute.split(RegExp(r'시|:'));

    if (hourMinuteList[1] == '') {
      hourMinuteList.insert(1, '00');
    }

    if (hourMinuteList.last.endsWith('분')) {
      hourMinuteList.last = hourMinuteList.last.replaceAll('분', '');
    }

    int hour = int.parse(hourMinuteList[0]);
    int minute = int.parse(hourMinuteList[1]);

    List<String> dateList = date.split(RegExp(r'-|\.|\/|년|월|일'));

    if (date == '') {
      var scheduleDateTime =
          DateTime(now.year, now.month, now.day, hour, minute);
      if (now.isAfter(scheduleDateTime)) {
        scheduleDateTime = scheduleDateTime.add(const Duration(days: 1));
      }
      dateList[0] = scheduleDateTime.year.toString();
      dateList.add(scheduleDateTime.month.toString());
      dateList.add(scheduleDateTime.day.toString());
    } else if (dateList[0].length < 4) {
      // 오늘이 2022년 8월 8일인데 7월 1일 이라고 입력하면 2023년 7월 1일이 되게
      int thisYear = now.year;
      print(date);
      if (DateTime(
        thisYear,
        int.parse(dateList[0]),
        int.parse(dateList[1]),
      ).isBefore(now)) {
        thisYear++;
      }
      dateList.insert(0, thisYear.toString());
    }

    return DateTime(
      int.parse(dateList[0]),
      int.parse(dateList[1]),
      int.parse(dateList[2]),
      hour,
      minute,
    );
  }

  static String? getTitle(String command) {
    String? hourMinute = getHourMinuteString(command);
    String? date = getDateString(command);
    String? result = command;
    if (hourMinute != null) {
      result = result.replaceAll(hourMinute, '');
    }
    if (date != null) {
      result = result.replaceAll(date, '');
    }
    return result;
  }
}

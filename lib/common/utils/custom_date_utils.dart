import 'package:intl/intl.dart';

class CustomDateUtils {
  /// 현재 날짜를 반환합니다.
  /// (만약 앱 전체에서 동일 값을 써야 할 시 수정이 쉽도록 이 함수를 제작하였습니다.)
  static DateTime getNow() {
    return DateTime.now();
  }

  /// 시, 분, 초 등을 제거하고 일만 반환합니다.
  static DateTime toDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// 두 날짜가 같은 일을 나타내는지 판단합니다.
  /// (시, 분, 초 등은 관련 X)
  static bool areSameDays(DateTime dayDate1, DateTime dayDate2) {
    return dayDate1.year == dayDate2.year &&
        dayDate1.month == dayDate2.month &&
        dayDate1.day == dayDate2.day;
  }

  /// 첫 날짜부터 둘째 날짜까지의 일들을 반환합니다.
  static List<DateTime> getDaysUntil(DateTime dayDate1, DateTime dayDate2) {
    if (dayDate1.compareTo(dayDate2) > 0) {
      return [];
    }

    if (areSameDays(dayDate1, dayDate2)) {
      return [dayDate1];
    }

    final List<DateTime> result = [dayDate1];

    while (true) {
      final last = result.last;
      final next = DateTime(last.year, last.month, last.day + 1);

      if (!areSameDays(next, dayDate2)) {
        result.add(next);
      } else {
        break;
      }
    }

    result.add(dayDate2);
    return result;
  }

  /// 해당 달의 첫 번째 날(1일)을 반환합니다.
  static DateTime getFirstDayOfMonth(DateTime monthDate) {
    return DateTime(monthDate.year, monthDate.month, 1);
  }

  /// 해당 달에 며칠까지 있는지 계산합니다.
  static int getMonthSize(DateTime monthDate) {
    return DateTime(monthDate.year, monthDate.month + 1, 0).day;
  }

  /// 해당 달의 달력을 만듭니다.
  /// (해당 달이 주의 중간에 시작/끝이 날 경우, 이전/다음 달도 일부 포함됩니다.)
  static List<List<DateTime>> getMonthCalendar(DateTime monthDate) {
    final monthSize = getMonthSize(monthDate);
    final monthFirstDayDate = getFirstDayOfMonth(monthDate);

    final prevMonthDate = DateTime(monthDate.year, monthDate.month - 1);
    final prevMonthSize = getMonthSize(prevMonthDate);

    final nextMonthDate = DateTime(monthDate.year, monthDate.month + 1);

    final List<List<DateTime>> weeks = [[]];
    var addCount = 0;

    void addDay(DateTime dayDate) {
      final currentWeek = weeks.last;

      if (currentWeek.length < 7) {
        currentWeek.add(dayDate);
      } else {
        weeks.add([dayDate]);
      }

      addCount++;
    }

    for (var day = prevMonthSize - (monthFirstDayDate.weekday % 7) + 1;
        day <= prevMonthSize;
        day++) {
      addDay(DateTime(prevMonthDate.year, prevMonthDate.month, day));
    }

    for (var day = 1; day <= monthSize; day++) {
      addDay(DateTime(monthDate.year, monthDate.month, day));
    }

    final remainingSize = 7 * 6 - addCount;

    for (var day = 1; day <= remainingSize; day++) {
      addDay(DateTime(nextMonthDate.year, nextMonthDate.month, day));
    }

    return weeks;
  }

  /// 영어 요일 한글로 변환
  static String getKoreanDayOfWeek(String dayOfWeek) {
    switch (dayOfWeek) {
      case 'Sun':
        return '일';
      case 'Mon':
        return '월';
      case 'Tue':
        return '화';
      case 'Wed':
        return '수';
      case 'Thu':
        return '목';
      case 'Fri':
        return '금';
      case 'Sat':
        return '토';
      default:
        assert(false, 'CustomDateUtils: getKoreanDayOfWeek error.');
        return '';
    }
  }

  /// DateTime.now()와 target이 며칠 차이나는지 반환
  static int getDCount(DateTime target) {
    final startDate = DateTime(target.year, target.month, target.day);
    final now = getNow();
    final nowDate = DateTime(now.year, now.month, now.day);
    return startDate.difference(nowDate).inDays;
  }

  /// 해당 날짜의 자정 반환
  static DateTime getMidnightOfThisDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Route 매개변수 등에 사용하기 위한 문자열.
  /// 빈칸없음 & 정확한 파싱 위해 Unix time 사용.
  static String dateToString(DateTime date) {
    return '${date.millisecondsSinceEpoch}';
  }

  /// [dateToString]의 반대.
  static DateTime stringToDate(String value) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(value));
  }

  // 24시를 저장하려고 하면 다음 날 0시로 저장된다.
  // 24시 저장 대신에 23시 59분 59초로 저장하게 했다.(SchedulesProvider에서)
  // 59초를 저장할린 없지 않겠는가? 그래서 59초인지 아닌지로 판단하게 했다.
  static DateTime getEndOfThisDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  }

  /// (년) 월 일 요일 String 반환
  /// 올해가 2020년이고 매개변수로 들어온 DateTime의 year이
  /// 2020이면 년은 생략
  static String formatDateStringExceptHourMinute(DateTime dateTime) {
    String dayOfWeek = getKoreanDayOfWeek(DateFormat('E').format(dateTime));
    dayOfWeek += '요일';

    String year = dateTime.year == getNow().year ? '' : '${dateTime.year}년 ';

    return '$year${dateTime.month}월 ${dateTime.day}일 $dayOfWeek';
  }

  /// [yearMonthDay]는 년 월 일을 추출할 매개변수.
  /// [hourMinute]은 시 분을 추출할 매개변수.
  /// DateTime(yearMonthDay.year, yearMonthDay.month, yearMonthDay.day, hourMinute.hour, hourMinute.minute)
  /// 를 반환한다.
  static DateTime combineYearMonthDayAndHourMinute(
      DateTime yearMonthDay, DateTime hourMinute) {
    return DateTime(yearMonthDay.year, yearMonthDay.month, yearMonthDay.day,
        hourMinute.hour, hourMinute.minute);
  }
}

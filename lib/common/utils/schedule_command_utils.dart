import 'package:calendar/common/utils/custom_date_utils.dart';

enum Ampm { am, pm }

class ScheduleCommandUtils {
  static String trimSpace(String command) {
    return command.replaceAll(' ', '');
  }

  /// 추출된 날짜 시간 String을 - . / 년 월 일 시 : 로 나뉜 List<String> 반환
  static List<String> _getDateTimeStringList(String dateTimeString) {
    List<String> dateTimeStringList =
        dateTimeString.split(RegExp(r'부터 ?|~|-|\.|\/|년 ?|월 ?|일 ?|시 ?|:| '));
    dateTimeStringList.removeWhere((e) => e.isEmpty);

    return dateTimeStringList;
  }

  /// am 반환하면 오전, pm 반환하면 오후, null 반환하면 am pm 관련 문자 없음
  static Ampm? isContainAmPm(String dateTimeString) {
    if (dateTimeString.contains(RegExp(r'am|AM|오전'))) {
      return Ampm.am;
    } else if (dateTimeString.contains(RegExp(r'pm|PM|오후'))) {
      return Ampm.pm;
    }
    return null;
  }

  static String removeAmPm(String dateTimeString) {
    return dateTimeString.replaceAll(
        RegExp(r' ?am| ?pm| ?AM| ?PM|오전 ?|오후 ?'), '');
  }

  static DateTime convertDateTimeStringListToDateTime(
      List<String> dateTimeStringList, Ampm? ampm, {bool isEndAllDay = false}) {
    List<int> dateTimeIntList = [];
    for (var item in dateTimeStringList) {
      dateTimeIntList.add(int.parse(item));
    }

    if (ampm == Ampm.pm) {
      dateTimeIntList[3] += 12;
    }

    DateTime result = DateTime(
      dateTimeIntList[0],
      dateTimeIntList[1],
      dateTimeIntList[2],
      dateTimeIntList[3],
      dateTimeIntList[4],
      isEndAllDay ? 59 : 0
    );

    return result;
  }

  static DateTime? getStartDateTime(String command) {
    DateTime? startDateTime;

    startDateTime = getStartDateTimeWithNumberAndBlank(command);
    startDateTime ??= getStartDateTimeWithFullForm(command);
    startDateTime ??= getStartDateTimeWithoutYear(command);
    startDateTime ??= getStartDateTimeWithoutYearAndMonth(command);

    return startDateTime;
  }

  static String? getStartDateTimeString(String command) {
    String? startDateTimeString;

    startDateTimeString = getDateTimeStringWithNumberAndBlank(command);
    startDateTimeString ??= getDateTimeStringWithFullForm(command);
    startDateTimeString ??= getDateTimeStringWithoutYear(command);
    startDateTimeString ??= getDateTimeStringWithoutYearAndMonth(command);

    return startDateTimeString;
  }

  //TODO 이거 쓰기
  static bool isEndWithRangeSymbol(String command) {
    String? rangeForm;

    rangeForm = getStartDateTimeString(command);

    if (rangeForm == null) {
      return false;
    }
    String? rangeSymbol =
        RegExp(r'(-|~|\.|부터 ?)$').firstMatch(rangeForm)?.group(0);
    if (rangeSymbol != null && rangeForm.endsWith(rangeSymbol)) {
      return true;
    }
    return false;
  }

  static String? getDateTimeStringWithFullForm(String command) {
    return RegExp(
            r'(20\d\d(-|\/|\.|년 ?))(0?[1-9]|1[012])(-|\/|\.|월 ?)([12][0-9]|3[01]|0?[1-9])일?(( (오전|오후)? ?[0-2]?[0-9](시|:)) ?([0-5]?[0-9]분?)?( ?(am|pm|AM|PM))?)?(-|~|부터 ?)?')
        .firstMatch(command)
        ?.group(0);
  }

  static String? getDateTimeStringWithoutYear(String command) {
    return RegExp(
            r'(0?[1-9]|1[012])(-|\/|\.|월 ?)([12][0-9]|3[01]|0?[1-9])일?(( (오전|오후)? ?[0-2]?[0-9](시|:)) ?([0-5]?[0-9]분?)?( ?(am|pm|AM|PM))?)?(-|~|부터 ?)?')
        .firstMatch(command)
        ?.group(0);
  }

  static String? getDateTimeStringWithoutYearAndMonth(String command) {
    return RegExp(
            r'([12][0-9]|3[01]|0?[1-9])일(( (오전|오후)? ?[0-2]?[0-9](시|:)) ?([0-5]?[0-9]분?)?( ?(am|pm|AM|PM))?)?(-|~|부터 ?)?')
        .firstMatch(command)
        ?.group(0);
  }

  static String? getDateTimeStringWithNumberAndBlank(String command) {
    return RegExp(
            r'20\d\d (0?[1-9]|1[012]) ([12][0-9]|3[01]|0?[1-9])(( (오전|오후)? ?[0-2]?[0-9](시|:)) ?([0-5]?[0-9]분?)?( ?(am|pm|AM|PM))?)?(-|~|부터 ?)?')
        .firstMatch(command)
        ?.group(0);
  }

  static DateTime? getStartDateTimeWithFullForm(String command) {
    String? dateTimeString = getDateTimeStringWithFullForm(command);
    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);

    switch (dateTimeStringList.length) {
      case 3:
        dateTimeStringList.add('0');
        dateTimeStringList.add('0');
        break;
      case 4:
        dateTimeStringList.add('0');
        break;
      case 5:
        break;
      default:
        assert(false,
            'getStartDateTimeWithFullForm error: dateTime.length must be more than 2 and less than 6.');
    }

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm);

    return result;
  }

  static DateTime? getStartDateTimeWithoutYear(String command) {
    String? dateTimeString = getDateTimeStringWithoutYear(command);
    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);

    switch (dateTimeStringList.length) {
      case 2:
        dateTimeStringList.add('0');
        dateTimeStringList.add('0');
        break;
      case 3:
        dateTimeStringList.add('0');
        break;
      case 4:
        break;
      default:
        assert(false,
            'getStartDateTimeWithoutYear error: dateTime.length must be more than 1 and less than 5.');
    }

    dateTimeStringList.insert(0, CustomDateUtils.getNow().year.toString());

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm);

    if (result.isBefore(CustomDateUtils.getNow())) {
      result = DateTime(result.year + 1, result.month, result.day, result.hour,
          result.minute);
    }

    return result;
  }

  static DateTime? getStartDateTimeWithoutYearAndMonth(String command) {
    String? dateTimeString = getDateTimeStringWithoutYearAndMonth(command);
    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);

    switch (dateTimeStringList.length) {
      case 1:
        dateTimeStringList.add('0');
        dateTimeStringList.add('0');
        break;
      case 2:
        dateTimeStringList.add('0');
        break;
      case 3:
        break;
      default:
        assert(false,
            'getStartDateTimeWithoutYearAndMonth error: dateTime.length must be more than 0 and less than 4.');
    }

    dateTimeStringList.insert(0, CustomDateUtils.getNow().year.toString());
    dateTimeStringList.insert(1, CustomDateUtils.getNow().month.toString());

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm);

    if (result.isBefore(CustomDateUtils.getNow())) {
      result = DateTime(result.year, result.month + 1, result.day, result.hour,
          result.minute);
    }

    return result;
  }

  /// 년월일 다 갖춰야 한다.
  static DateTime? getStartDateTimeWithNumberAndBlank(String command) {
    String? dateTimeString = getDateTimeStringWithNumberAndBlank(command);

    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);

    switch (dateTimeStringList.length) {
      case 3:
        dateTimeStringList.add('0');
        dateTimeStringList.add('0');
        break;
      case 4:
        dateTimeStringList.add('0');
        break;
      case 5:
        break;
      default:
        assert(false,
        'getStartDateTimeWithNumberAndBlank error: dateTime.length must be more than 2 and less than 6.');
    }

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm);

    return result;
  }




  //앞뒤가 같은 시간이면 무시
  static DateTime getEndDateTime(
      String command, DateTime startDateTime, String startString) {
    String suffixString = command.split(startString)[1];
    String? endDateTimeString;

    //스트링 찾고
    endDateTimeString = getStartDateTimeString(suffixString);
    endDateTimeString ??= getHourMinuteString(suffixString);

    //분리 기호 바로 뒤에 오는지 확인
    if(endDateTimeString == null || !suffixString.startsWith(endDateTimeString)){
      return CustomDateUtils.getEndOfThisDay(startDateTime);
    }

    //datetime 받기
    DateTime? end = getEndDateTimeWithNumberAndBlank(suffixString, startDateTime);
    end ??= getEndDateTimeWithFullForm(suffixString, startDateTime);
    end ??= getEndDateTimeWithoutYear(suffixString, startDateTime);
    end ??= getEndDateTimeWithoutYearAndMonth(suffixString, startDateTime);
    end ??= getEndDateTimeWithHourMinute(suffixString, startDateTime);

    if(end == null || end.isBefore(startDateTime) || end.isAtSameMomentAs(startDateTime)){
      return CustomDateUtils.getEndOfThisDay(startDateTime);
    }

    return end;
  }

  static DateTime? getEndDateTimeWithFullForm(String suffixString, DateTime start){
    String? dateTimeString = getDateTimeStringWithFullForm(suffixString);

    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);
    bool isEndAllDay = false;

    switch (dateTimeStringList.length) {
      case 3:
        dateTimeStringList.add('23');
        dateTimeStringList.add('59');
        isEndAllDay = true;
        break;
      case 4:
        dateTimeStringList.add('0');
        break;
      case 5:
        break;
      default:
        assert(false,
        'getEndDateTimeWithFullForm error: dateTime.length must be more than 2 and less than 6.');
    }

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm, isEndAllDay: isEndAllDay);

    if(result.isBefore(start)){
      return null;
    }

    return result;
  }

  static DateTime? getEndDateTimeWithoutYear(String suffixString, DateTime start) {
    String? dateTimeString = getDateTimeStringWithoutYear(suffixString);
    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);
    bool isEndAllDay = false;

    switch (dateTimeStringList.length) {
      case 2:
        dateTimeStringList.add('23');
        dateTimeStringList.add('59');
        isEndAllDay = true;
        break;
      case 3:
        dateTimeStringList.add('0');
        break;
      case 4:
        break;
      default:
        assert(false,
        'getEndDateTimeWithoutYear error: dateTime.length must be more than 1 and less than 5.');
    }

    dateTimeStringList.insert(0, start.year.toString());

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm, isEndAllDay: isEndAllDay);

    if (result.isBefore(start)) {
      result = DateTime(result.year + 1, result.month, result.day, result.hour,
          result.minute);
    }

    return result;
  }

  static DateTime? getEndDateTimeWithoutYearAndMonth(String suffixString, DateTime start) {
    String? dateTimeString = getDateTimeStringWithoutYearAndMonth(suffixString);
    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);
    bool isEndAllDay = false;

    switch (dateTimeStringList.length) {
      case 1:
        dateTimeStringList.add('23');
        dateTimeStringList.add('59');
        isEndAllDay = true;
        break;
      case 2:
        dateTimeStringList.add('0');
        break;
      case 3:
        break;
      default:
        assert(false,
        'getEndDateTimeWithoutYearAndMonth error: dateTime.length must be more than 0 and less than 4.');
    }

    dateTimeStringList.insert(0, start.year.toString());
    dateTimeStringList.insert(1, start.month.toString());

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm, isEndAllDay: isEndAllDay);

    if (result.isBefore(start)) {
      result = DateTime(result.year, result.month + 1, result.day, result.hour,
          result.minute);
    }

    return result;
  }

  static DateTime? getEndDateTimeWithHourMinute(String suffixString, DateTime start) {
    String? dateTimeString = getHourMinuteString(suffixString);
    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);
    bool isEndAllDay = false;

    switch (dateTimeStringList.length) {
      case 1:
        dateTimeStringList.add('0');
        isEndAllDay = true;
        break;
      case 2:
        break;
      default:
        assert(false,
        'getEndDateTimeWithHourMinute error: dateTime.length must be more than 0 and less than 3.');
    }

    dateTimeStringList.insert(0, start.year.toString());
    dateTimeStringList.insert(1, start.month.toString());
    dateTimeStringList.insert(2, start.day.toString());

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm, isEndAllDay: isEndAllDay);

    if (result.isBefore(start)) {
      result = DateTime(result.year, result.month, result.day + 1, result.hour,
          result.minute);
    }

    return result;
  }

  /// 년월일 다 갖춰야 한다.
  static DateTime? getEndDateTimeWithNumberAndBlank(String suffixString, DateTime start) {
    String? dateTimeString = getDateTimeStringWithNumberAndBlank(suffixString);

    if (dateTimeString == null) {
      return null;
    }

    Ampm? ampm = isContainAmPm(dateTimeString);
    if(ampm != null){
      dateTimeString = removeAmPm(dateTimeString);
    }

    List<String> dateTimeStringList = _getDateTimeStringList(dateTimeString);
    bool isEndAllDay = false;

    switch (dateTimeStringList.length) {
      case 3:
        dateTimeStringList.add('23');
        dateTimeStringList.add('59');
        isEndAllDay = true;
        break;
      case 4:
        dateTimeStringList.add('0');
        break;
      case 5:
        break;
      default:
        assert(false,
        'getEndDateTimeWithNumberAndBlank error: dateTime.length must be more than 2 and less than 6.');
    }

    DateTime result = convertDateTimeStringListToDateTime(
        dateTimeStringList, ampm, isEndAllDay: isEndAllDay);

    if(result.isBefore(start)){
      return null;
    }

    return result;
  }

  static String? getHourMinuteString(String command) {
    return RegExp(r'(오전|오후)? ?[0-2]?[0-9](시|:) ?([0-5]?[0-9]분?)?( ?(am|pm|AM|PM))?')
        .firstMatch(command)
        ?.group(0);
  }


  static String? getTitle(String command) {
    String? start = getStartDateTimeString(command);
    String? result = command;
    if (start != null) {
      result = result.replaceFirst(start, '');
    }
    String? end = getStartDateTimeString(result);
    if (end != null) {
      result = result.replaceFirst(end, '');
    }
    return result;
  }
}

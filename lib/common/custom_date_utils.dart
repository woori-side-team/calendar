class CustomDateUtils {
  static DateTime getFirstDayOfMonth(DateTime monthDate) {
    return DateTime(monthDate.year, monthDate.month, 1);
  }

  static int getMonthSize(DateTime monthDate) {
    return DateTime(monthDate.year, monthDate.month + 1, 0).day;
  }

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
}

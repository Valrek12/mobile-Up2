import 'dart:core';

class DateConverter {
  static int dayOfMonthDayOfWeek(DateTime day) {
    final DateTime theDate = day;
    return theDate.weekday - 1;
  }

  static String firstDayOfMonthDayOfWeek() {
    DateTime theDate = new DateTime.now();
    var newDate = new DateTime(
        theDate.year, theDate.month, theDate.day - theDate.weekday + 1);
    String day =
        "${newDate.day.toString().padLeft(2, '0')}.${newDate.month.toString().padLeft(2, '0')}.${newDate.year.toString().padLeft(2, '0')}";
    return day;
  }

  static String firstDayOfMonthDayOfWeekDef() {
    DateTime theDate = new DateTime.now();
    var newDate = new DateTime(
        theDate.year, theDate.month, theDate.day - theDate.weekday + 1);
    String day =
        "${newDate.year.toString().padLeft(2, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
    return day;
  }

  static String selectDay(DateTime datetime) {
    String day =
        "${datetime.year.toString().padLeft(2, '0')}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
    return day;
  }
}

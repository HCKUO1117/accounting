import 'package:intl/intl.dart';

class Utils {
  static String toDateTimeString(DateTime time, {String? format}) {
    return DateFormat(format ?? 'yyyy-MM-dd HH:mm:ss').format(time);
  }

  static String toDateString(DateTime time, {String? format}) {
    return DateFormat(format ?? 'yyyy/MM/dd').format(time);
  }

  static String dateStringByType(DateTime time, int scale) {
    switch(scale){
      case 0:
        return DateFormat('yyyy/MM/dd').format(time);
      case 1:
        return DateFormat('yyyy/MM').format(time);
      case 2:
        return DateFormat('yyyy').format(time);
    }
    return DateFormat('yyyy/MM/dd').format(time);
  }

  static bool checkIsSameDay(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return true;
    }
    return false;
  }

  static bool checkIsSameMonth(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month) {
      return true;
    }
    return false;
  }

  static bool checkIsSameYear(DateTime start, DateTime end) {
    if (start.year == end.year) {
      return true;
    }
    return false;
  }
}

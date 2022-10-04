import 'package:intl/intl.dart';

class Utils {
  static String toDateString(DateTime time, {String? format}) {
    return DateFormat(format ?? 'yyyy/MM/dd').format(time);
  }

  static bool checkIsSameDay(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return true;
    }
    return false;
  }
}

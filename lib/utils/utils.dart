import 'package:intl/intl.dart';

class Utils {
  static String toDateString(DateTime time, {String? format}) {
    return DateFormat(format ?? 'yyyy/MM/dd').format(time);
  }
}

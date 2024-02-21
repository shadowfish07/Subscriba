import 'package:intl/intl.dart';

class DateFormatHelper {
  static String fromMicrosecondsSinceEpoch(int timestamp) {
    if (timestamp == 0) return "";
    return DateFormat.yMd()
        .format(DateTime.fromMicrosecondsSinceEpoch(timestamp));
  }
}

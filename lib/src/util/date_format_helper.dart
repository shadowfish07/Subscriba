import 'package:intl/intl.dart';

class DateFormatHelper {
  static String fromMicrosecondsSinceEpoch(int timestamp) {
    return DateFormat.yMd()
        .format(DateTime.fromMicrosecondsSinceEpoch(timestamp));
  }
}

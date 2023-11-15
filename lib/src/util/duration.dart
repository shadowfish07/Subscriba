import 'package:intl/intl.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

int getDateDuration(int startDate, int endDate) {
  return DateTime.fromMicrosecondsSinceEpoch(endDate)
          .difference(DateTime.fromMicrosecondsSinceEpoch(startDate))
          .inDays +
      1;
}

class DurationHelper {
  const DurationHelper({required this.duration, required this.unit});

  factory DurationHelper.fromDate(
      int startDate, int endDate, PaymentCycleType unit) {
    final diff = DateTime.fromMicrosecondsSinceEpoch(endDate)
        .difference(DateTime.fromMicrosecondsSinceEpoch(startDate));

    return DurationHelper(
      duration: diff.inDays + 1,
      unit: unit,
    );
  }

  final int duration;
  final PaymentCycleType unit;

  // 每个月都视为31天，每年都视为365天（对于付款周期来说）
  static const double dayPerMonth = 31; //dayPerYear / 12;
  static const double dayPerYear = 365;

  double toDays() {
    if (unit == PaymentCycleType.daily) {
      return duration.toDouble();
    }

    if (unit == PaymentCycleType.monthly) {
      return duration * dayPerMonth;
    }

    if (unit == PaymentCycleType.yearly) {
      return duration * dayPerYear;
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }

  double toMonths() {
    if (unit == PaymentCycleType.daily) {
      return duration / dayPerMonth;
    }

    if (unit == PaymentCycleType.monthly) {
      return duration * dayPerMonth;
    }

    if (unit == PaymentCycleType.yearly) {
      return duration * 12;
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }

  double toYears() {
    if (unit == PaymentCycleType.daily) {
      return duration / dayPerYear;
    }

    if (unit == PaymentCycleType.monthly) {
      return duration / 12;
    }

    if (unit == PaymentCycleType.yearly) {
      return duration.toDouble();
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }
}

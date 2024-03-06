import 'package:subscriba/src/database/order.dart';

int getDateDuration(int startDate, int endDate) {
  return DateTime.fromMicrosecondsSinceEpoch(endDate)
          .difference(DateTime.fromMicrosecondsSinceEpoch(startDate))
          .inDays +
      1;
}

class DurationHelper {
  const DurationHelper({required this.duration, required this.unit});

  factory DurationHelper.fromDate(
      int startDate, int endDate, PaymentFrequency unit) {
    final diff = DateTime.fromMicrosecondsSinceEpoch(endDate)
        .difference(DateTime.fromMicrosecondsSinceEpoch(startDate));

    return DurationHelper(
      duration: diff.inDays + 1,
      unit: unit,
    );
  }

  final int duration;
  final PaymentFrequency unit;

  // 每个月都视为31天，每年都视为365天（对于付款周期来说）
  static const double dayPerMonth = 31; //dayPerYear / 12;
  static const double dayPerYear = 365;

  static const paymentCycle2Days = {
    PaymentFrequency.daily: 1.0,
    PaymentFrequency.monthly: DurationHelper.dayPerMonth,
    PaymentFrequency.yearly: DurationHelper.dayPerYear
  };

  double toDays() {
    if (unit == PaymentFrequency.daily) {
      return duration.toDouble();
    }

    if (unit == PaymentFrequency.monthly) {
      return duration * dayPerMonth;
    }

    if (unit == PaymentFrequency.yearly) {
      return duration * dayPerYear;
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }

  double toMonths() {
    if (unit == PaymentFrequency.daily) {
      return duration / dayPerMonth;
    }

    if (unit == PaymentFrequency.monthly) {
      return duration * dayPerMonth;
    }

    if (unit == PaymentFrequency.yearly) {
      return duration * 12;
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }

  double toYears() {
    if (unit == PaymentFrequency.daily) {
      return duration / dayPerYear;
    }

    if (unit == PaymentFrequency.monthly) {
      return duration / 12;
    }

    if (unit == PaymentFrequency.yearly) {
      return duration.toDouble();
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }
}

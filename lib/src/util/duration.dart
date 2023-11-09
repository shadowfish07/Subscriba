import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

class Duration {
  const Duration({required this.duration, required this.unit});

  final int duration;
  final PaymentCycleHelper unit;

  // 每个月都视为31天，每年都视为365天（对于付款周期来说）
  static const double dayPerMonth = 31; //dayPerYear / 12;
  static const double dayPerYear = 365;

  double toDays() {
    if (unit.paymentCycle == PaymentCycleType.daily) {
      return duration.toDouble();
    }

    if (unit.paymentCycle == PaymentCycleType.monthly) {
      return duration * dayPerMonth;
    }

    if (unit.paymentCycle == PaymentCycleType.yearly) {
      return duration * dayPerYear;
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }

  double toMonths() {
    if (unit.paymentCycle == PaymentCycleType.daily) {
      return duration / dayPerMonth;
    }

    if (unit.paymentCycle == PaymentCycleType.monthly) {
      return duration * dayPerMonth;
    }

    if (unit.paymentCycle == PaymentCycleType.yearly) {
      return duration * 12;
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }

  double toYears() {
    if (unit.paymentCycle == PaymentCycleType.daily) {
      return duration / dayPerYear;
    }

    if (unit.paymentCycle == PaymentCycleType.monthly) {
      return duration / 12;
    }

    if (unit.paymentCycle == PaymentCycleType.yearly) {
      return duration.toDouble();
    }

    throw ArgumentError('unit must be one of d, m, or y');
  }
}

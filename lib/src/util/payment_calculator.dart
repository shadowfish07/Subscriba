import 'package:subscriba/src/database/order.dart';

import 'duration.dart';

class PaymentCalculator {
  const PaymentCalculator({required this.duration, required this.paymentCycle});

  final DurationHelper duration;
  final PaymentCycleType paymentCycle;

  double getPaymentPerPeriod(double totalPaymentAmount) {
    if (paymentCycle == PaymentCycleType.daily) {
      return totalPaymentAmount / duration.toDays();
    }

    if (paymentCycle == PaymentCycleType.monthly) {
      return totalPaymentAmount / duration.toMonths();
    }

    if (paymentCycle == PaymentCycleType.yearly) {
      return totalPaymentAmount / duration.toYears();
    }

    throw ArgumentError('paymentCycle must be one of d, m, or y');
  }

  double getTotalPaymentAmount(double paymentPerPeriod) {
    if (paymentCycle == PaymentCycleType.daily) {
      return paymentPerPeriod * duration.toDays();
    }

    if (paymentCycle == PaymentCycleType.monthly) {
      return paymentPerPeriod * duration.toMonths();
    }

    if (paymentCycle == PaymentCycleType.yearly) {
      return paymentPerPeriod * duration.toYears();
    }

    throw ArgumentError('paymentCycle must be one of d, m, or y');
  }
}

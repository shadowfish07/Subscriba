import 'package:subscriba/src/database/order.dart';

import 'duration.dart';

class PaymentCalculator {
  const PaymentCalculator({required this.duration, required this.paymentCycle});

  final DurationHelper duration;
  final PaymentFrequency paymentCycle;

  double getPaymentPerPeriod(double totalPaymentAmount) {
    if (paymentCycle == PaymentFrequency.daily) {
      return totalPaymentAmount / duration.toDays();
    }

    if (paymentCycle == PaymentFrequency.monthly) {
      return totalPaymentAmount / duration.toMonths();
    }

    if (paymentCycle == PaymentFrequency.yearly) {
      return totalPaymentAmount / duration.toYears();
    }

    throw ArgumentError('paymentCycle must be one of d, m, or y');
  }

  double getTotalPaymentAmount(double paymentPerPeriod) {
    if (paymentCycle == PaymentFrequency.daily) {
      return paymentPerPeriod * duration.toDays();
    }

    if (paymentCycle == PaymentFrequency.monthly) {
      return paymentPerPeriod * duration.toMonths();
    }

    if (paymentCycle == PaymentFrequency.yearly) {
      return paymentPerPeriod * duration.toYears();
    }

    throw ArgumentError('paymentCycle must be one of d, m, or y');
  }
}

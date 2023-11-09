import 'package:subscriba/src/database/order.dart';

class PaymentCycleHelper {
  static const paymentCycleMap = {
    'Daily': PaymentCycleType.daily,
    'Monthly': PaymentCycleType.monthly,
    'Yearly': PaymentCycleType.yearly,
    "Day": PaymentCycleType.daily,
    "Month": PaymentCycleType.monthly,
    "Year": PaymentCycleType.yearly
  };

  PaymentCycleHelper({required String timeUnit}) {
    final PaymentCycleType? p = paymentCycleMap[timeUnit];
    if (p == null) {
      throw ArgumentError(
          'paymentCycle must be one of Daily, Monthly, or Yearly');
    }
    paymentCycle = p;
  }

  late PaymentCycleType paymentCycle;
}

import 'package:subscriba/src/database/order.dart';

class PaymentCycleHelper {
  static const str2Enum = {
    'Daily': PaymentCycleType.daily,
    'Monthly': PaymentCycleType.monthly,
    'Yearly': PaymentCycleType.yearly,
    "Day": PaymentCycleType.daily,
    "Month": PaymentCycleType.monthly,
    "Year": PaymentCycleType.yearly
  };

  static const enum2Str = {
    PaymentCycleType.daily: 'Daily',
    PaymentCycleType.monthly: 'Monthly',
    PaymentCycleType.yearly: 'Yearly'
  };

  PaymentCycleHelper({required String timeUnit}) {
    final PaymentCycleType? p = str2Enum[timeUnit];
    if (p == null) {
      throw ArgumentError(
          'paymentCycle must be one of Daily, Monthly, or Yearly');
    }
    paymentCycle = p;
  }

  late PaymentCycleType paymentCycle;
}

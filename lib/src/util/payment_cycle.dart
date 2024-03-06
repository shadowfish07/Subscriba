import 'package:subscriba/src/database/order.dart';

class PaymentCycleHelper {
  static const str2Enum = {
    'Daily': PaymentFrequency.daily,
    'Monthly': PaymentFrequency.monthly,
    'Yearly': PaymentFrequency.yearly,
    "Day": PaymentFrequency.daily,
    "Month": PaymentFrequency.monthly,
    "Year": PaymentFrequency.yearly
  };

  static const enum2FormalStr = {
    PaymentFrequency.daily: 'Daily',
    PaymentFrequency.monthly: 'Monthly',
    PaymentFrequency.yearly: 'Annually'
  };

  static const enum2PerUnitStr = {
    PaymentFrequency.daily: 'day',
    PaymentFrequency.monthly: 'month',
    PaymentFrequency.yearly: 'year'
  };

  PaymentCycleHelper({required String timeUnit}) {
    final PaymentFrequency? p = str2Enum[timeUnit];
    if (p == null) {
      throw ArgumentError(
          'paymentCycle must be one of Daily, Monthly, or Yearly');
    }
    paymentCycle = p;
  }

  late PaymentFrequency paymentCycle;
}

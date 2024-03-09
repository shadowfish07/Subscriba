import 'package:subscriba/src/database/order.dart';

class PaymentFrequencyHelper {
  static const str2Enum = {
    'Daily': PaymentFrequency.daily,
    'Monthly': PaymentFrequency.monthly,
    'Annually': PaymentFrequency.yearly,
    "One-Time": PaymentFrequency.oneTime,
    "Day": PaymentFrequency.daily,
    "Month": PaymentFrequency.monthly,
    "Year": PaymentFrequency.yearly
  };

  static const enum2FormalStr = {
    PaymentFrequency.daily: 'Daily',
    PaymentFrequency.monthly: 'Monthly',
    PaymentFrequency.yearly: 'Annually',
    PaymentFrequency.oneTime: 'One-Time'
  };

  static const enum2PerUnitStr = {
    PaymentFrequency.daily: 'day',
    PaymentFrequency.monthly: 'month',
    PaymentFrequency.yearly: 'year',
    PaymentFrequency.oneTime: ''
  };

  static PaymentFrequency dayAmountToPaymentFrequency(int dayAmount) {
    if (dayAmount == 1) {
      return PaymentFrequency.daily;
    }

    if (dayAmount >= 28 && dayAmount <= 32) {
      return PaymentFrequency.monthly;
    }

    // 可能有厂商以31*12=372来计算年订阅时长
    if (dayAmount >= 365 && dayAmount <= 372) {
      return PaymentFrequency.yearly;
    }

    return PaymentFrequency.oneTime;
  }
}

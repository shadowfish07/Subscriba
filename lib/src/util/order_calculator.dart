import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/duration.dart';
import 'package:subscriba/src/util/payment_calculator.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

const paymentCycle2Days = {
  PaymentCycleType.daily: 1,
  PaymentCycleType.monthly: Duration.dayPerMonth,
  PaymentCycleType.yearly: Duration.dayPerYear
};

double getDailyPaymentPerPeriod(
    PaymentCycleType paymentCycle, double paymentPerPeriod) {
  if (paymentCycle == PaymentCycleType.daily) {
    return paymentPerPeriod;
  }

  if (paymentCycle == PaymentCycleType.monthly) {
    return paymentPerPeriod / Duration.dayPerMonth;
  }

  if (paymentCycle == PaymentCycleType.yearly) {
    return paymentPerPeriod / Duration.dayPerYear;
  }

  throw ArgumentError('paymentCycle must be one of d, m, or y');
}

class OrderCalculator {
  const OrderCalculator({required this.orders});

  final List<Order> orders;

  // 待重写
  get totalPrize {
    return orders.where((e) => e.paymentType == PaymentType.recurring).map((e) {
      final duration =
          Duration.fromDate(e.startDate, e.endDate!, e.paymentCycleType!);

      return PaymentCalculator(
              duration: duration, paymentCycle: e.paymentCycleType!)
          .getTotalPaymentAmount(e.paymentPerPeriod!);
    }).reduce((value, element) => value + element);
  }

  double perPrize(PaymentCycleType paymentCycleType) {
    return orders.map((e) {
          /**
       * 
均值花费算法：
订阅周期 1月视为31天
1年视为365天
计算月均、年均花费时，均会将订阅费用以上述单位均分到日均后再计算周期金额。

比如设置了10元/月的订阅，
在计算年均花费时，算法为：
perYear = 10 / 31 * 365 = 117.74..
这和普通预期中的10 * 12 不匹配，但更灵活普适。
       */
          return getDailyPaymentPerPeriod(
                  e.paymentCycleType!, e.paymentPerPeriod!) *
              paymentCycle2Days[paymentCycleType]!;
        }).reduce((value, element) => value + element) /
        orders.length;
  }
}

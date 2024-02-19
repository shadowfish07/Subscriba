import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/duration.dart' as my;
import 'package:subscriba/src/util/payment_calculator.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

const paymentCycle2Days = {
  PaymentCycleType.daily: 1,
  PaymentCycleType.monthly: my.DurationHelper.dayPerMonth,
  PaymentCycleType.yearly: my.DurationHelper.dayPerYear
};

double getDailyPaymentPerPeriod(
    PaymentCycleType paymentCycle, double paymentPerPeriod) {
  if (paymentCycle == PaymentCycleType.daily) {
    return paymentPerPeriod;
  }

  if (paymentCycle == PaymentCycleType.monthly) {
    return paymentPerPeriod / my.DurationHelper.dayPerMonth;
  }

  if (paymentCycle == PaymentCycleType.yearly) {
    return paymentPerPeriod / my.DurationHelper.dayPerYear;
  }

  throw ArgumentError('paymentCycle must be one of d, m, or y');
}

class OrderCalculator {
  const OrderCalculator({required this.orders});

  final List<Order> orders;

  List<Order> get availableOrders {
    final result =
        orders.where((element) => element.deletedAt == null).toList();
    result.sort((a, b) => a.startDate.compareTo(b.startDate));
    return result;
  }

  double get totalPrize {
    return availableOrders.map((e) {
      return e.paymentPerPeriod;
    }).fold(0.0, (value, element) => value + element);
  }

  double perPrize(PaymentCycleType paymentCycleType) {
    return availableOrders.map((e) {
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
                  e.paymentCycleType!, e.paymentPerPeriod) *
              paymentCycle2Days[paymentCycleType]!;
        }).fold(0.0, (value, element) => value + element) /
        orders.length;
  }

  bool get includeLifetimeOrder {
    return availableOrders.firstWhereOrNull(
            (element) => element.paymentType == PaymentType.lifetime) !=
        null;
  }

  /// -1 则是买断
  int get subscribingDays {
    if (includeLifetimeOrder) {
      return -1;
    }

    return availableOrders
        .map((e) => my.DurationHelper.fromDate(
                e.startDate, e.endDate!, e.paymentCycleType!)
            .duration)
        .fold(0, (value, element) => value + element);
  }

  /// 无买断返回-1
  int get daysAfterLifetimeSubscription {
    if (!includeLifetimeOrder) {
      return -1;
    }

    final order = availableOrders
        .firstWhere((element) => element.paymentType == PaymentType.lifetime);

    return DateTime.fromMicrosecondsSinceEpoch(order.startDate)
        .difference(DateTime.now())
        .inDays;
  }

  /// 计算最后一次连续订阅的开始时间
  /// 遇到买断则直接返回买断时间
  int get lastContinuousSubscriptionDate {
    if (availableOrders.isEmpty) return 0;

    for (var i = availableOrders.length - 1; i > 0; i--) {
      final order = availableOrders[i];
      final prevOrder = availableOrders[i - 1];

      if (order.paymentType == PaymentType.lifetime) {
        return order.startDate;
      }

      if (DateTime.fromMicrosecondsSinceEpoch(prevOrder.endDate!)
              .difference(DateTime.fromMicrosecondsSinceEpoch(order.startDate))
              .inDays !=
          1) {
        return order.startDate;
      }
    }

    return availableOrders[0].startDate;
  }

  /// -1 则是买断
  int get latestSubscriptionDate {
    if (includeLifetimeOrder) {
      return -1;
    }

    if (availableOrders.isEmpty) return 0;

    return availableOrders[availableOrders.length - 1].endDate!;
  }

  /// null 则是买断
  Duration? get expiresIn {
    if (includeLifetimeOrder) {
      return null;
    }

    DateTime now = DateTime.now();
    DateTime nowDate = DateTime(now.year, now.month, now.day);

    return DateTime.fromMicrosecondsSinceEpoch(latestSubscriptionDate)
        .difference(nowDate);
  }

  Order? get nextPaymentTemplate {
    if (includeLifetimeOrder || availableOrders.isEmpty) {
      return null;
    }

    return availableOrders[availableOrders.length - 1];
  }
}

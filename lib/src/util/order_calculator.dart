import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/currency.dart';
import 'package:subscriba/src/util/currency_amount.dart';
import 'package:subscriba/src/util/duration.dart' as my;

CurrencyAmount getDailyCostPerPeriod(
    PaymentFrequency paymentCycle, CurrencyAmount paymentPerPeriod) {
  if (paymentCycle == PaymentFrequency.daily) {
    return paymentPerPeriod;
  }

  if (paymentCycle == PaymentFrequency.monthly) {
    return paymentPerPeriod / my.DurationHelper.dayPerMonth;
  }

  if (paymentCycle == PaymentFrequency.yearly) {
    return paymentPerPeriod / my.DurationHelper.dayPerYear;
  }

  throw ArgumentError('paymentCycle must be one of d, m, or y');
}

class OrderCalculator {
  const OrderCalculator({required this.orders, required this.targetCurrency});

  final List<Order> orders;
  final Currency targetCurrency;

  List<Order> get availableOrders {
    final result =
        orders.where((element) => element.deletedAt == null).toList();
    result.sort((a, b) => a.startDate.compareTo(b.startDate));
    return result;
  }

  CurrencyAmount get totalCost {
    return availableOrders.map((e) {
      return e.paymentPerPeriod;
    }).fold(CurrencyAmount.zero(targetCurrency),
        (value, element) => value + element);
  }

  /// 目前暂时不会有多个lifetime订单，后续看规划
  CurrencyAmount get lifetimeCost {
    return availableOrders
        .where((element) => element.paymentType == PaymentType.lifetime)
        .map((e) => e.paymentPerPeriod)
        .fold(CurrencyAmount.zero(targetCurrency),
            (value, element) => value + element);
  }

  CurrencyAmount oneTimeOrdersCost(PaymentFrequency paymentFrequency) {
    if (availableOrders.isEmpty) return CurrencyAmount.zero(targetCurrency);
    if (!isIncludeOneTimeOrder) return CurrencyAmount.zero(targetCurrency);

    debugPrint(
        "dailyCost ${paymentFrequency} oneTimeOrdersCost ${CurrencyAmount.zero(targetCurrency)}");

    final oneTimeOrders = availableOrders.where(
        (element) => element.paymentFrequency == PaymentFrequency.oneTime);

    return oneTimeOrders.map((e) {
          final duration = my.DurationHelper.fromDate(
                  e.startDate, e.endDate!, PaymentFrequency.daily)
              .toDays();
          final dailyCost = e.paymentPerPeriod / duration;
          return dailyCost *
              my.DurationHelper.paymentCycle2Days[paymentFrequency]!;
        }).fold(CurrencyAmount.zero(targetCurrency),
            (value, element) => value + element) /
        oneTimeOrders.length;
  }

  /// 协议均值花费算法，计算按协议价格计算的花费：
  /// 订阅周期 1月视为31天
  /// 1年视为365天
  /// 计算月均、年均花费时，均会将订阅费用以上述单位均分到日均后再计算周期金额。
  ///
  /// 比如设置了10元/月的订阅，
  /// 在计算年均花费时，算法为：
  /// perYear = 10 / 31 * 365 = 117.74..
  /// 这和普通预期中的10 * 12 不匹配，但更灵活普适。
  ///
  /// 如果订单中包含Lifetime订单，则返回-1
  CurrencyAmount perCostByProtocol(PaymentFrequency paymentFrequency) {
    if (availableOrders.isEmpty) return CurrencyAmount.zero(targetCurrency);
    if (isIncludeLifetimeOrder) return CurrencyAmount.NaN(targetCurrency);
    debugPrint("dailyCost ${paymentFrequency} targetCurrency $targetCurrency");
    final ordersWithoutOneTime = availableOrders.where(
        (element) => element.paymentFrequency != PaymentFrequency.oneTime);
    final costWithoutOneTimeOrders = ordersWithoutOneTime.map((e) {
          return getDailyCostPerPeriod(
                  e.paymentFrequency!, e.paymentPerPeriod) *
              my.DurationHelper.paymentCycle2Days[paymentFrequency]!;
        }).fold(CurrencyAmount.zero(targetCurrency),
            (value, element) => value + element) /
        ordersWithoutOneTime.length;

    return costWithoutOneTimeOrders.ensureAmount() +
        oneTimeOrdersCost(paymentFrequency).ensureAmount();
  }

  /// 实际均值花费算法，计算实际使用时长折算到每天的花费
  /// 如果使用时间不足31天/365天，则月均/年均花费为-1（没有意义）
  CurrencyAmount perCostByActual(PaymentFrequency paymentFrequency) {
    if (availableOrders.isEmpty || subscribingDaysByActual == 0) {
      return CurrencyAmount.zero(targetCurrency);
    }
    if (paymentFrequency != PaymentFrequency.daily &&
        subscribingDaysByActual <
            my.DurationHelper.paymentCycle2Days[paymentFrequency]!) {
      return CurrencyAmount.NaN(targetCurrency);
    }

    return availableOrders.map((e) => e.paymentPerPeriod).fold(
            CurrencyAmount.zero(targetCurrency),
            (value, element) => value + element) /
        subscribingDaysByActual *
        my.DurationHelper.paymentCycle2Days[paymentFrequency]!;
  }

  bool get isIncludeLifetimeOrder {
    return availableOrders.firstWhereOrNull(
            (element) => element.paymentType == PaymentType.lifetime) !=
        null;
  }

  bool get isIncludeOneTimeOrder {
    return availableOrders.firstWhereOrNull((element) =>
            element.paymentFrequency == PaymentFrequency.oneTime) !=
        null;
  }

  /// 已使用订阅总天数
  /// -1 则是买断
  int get subscribingDaysByActual {
    int result = 0;
    for (var order in availableOrders) {
      if (order.startDate > DateTime.now().microsecondsSinceEpoch) {
        return result;
      }
      if (order.paymentType == PaymentType.lifetime ||
          order.endDate! > DateTime.now().microsecondsSinceEpoch) {
        result += DateTime.now()
            .difference(DateTime.fromMicrosecondsSinceEpoch(order.startDate))
            .inDays;
        return result;
      }

      result += my.DurationHelper.fromDate(
              order.startDate, order.endDate!, order.paymentFrequency!)
          .duration;
    }

    return result;
  }

  /// 协议订阅总天数
  /// -1 则是买断
  int get subscribingDaysByProtocol {
    if (isIncludeLifetimeOrder) {
      return -1;
    }

    return availableOrders
        .map((e) => my.DurationHelper.fromDate(
                e.startDate, e.endDate!, e.paymentFrequency!)
            .duration)
        .fold(0, (value, element) => value + element);
  }

  /// 无买断返回-1
  int get daysAfterLifetimeSubscription {
    if (!isIncludeLifetimeOrder) {
      return -1;
    }

    final order = availableOrders
        .firstWhere((element) => element.paymentType == PaymentType.lifetime);

    return DateTime.fromMicrosecondsSinceEpoch(order.startDate)
            .difference(DateTime.now())
            .inDays +
        1;
  }

  bool get isLastOrderOneTime {
    if (availableOrders.isEmpty) return false;
    return availableOrders.last.paymentFrequency == PaymentFrequency.oneTime;
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
    if (isIncludeLifetimeOrder) {
      return -1;
    }

    if (availableOrders.isEmpty) return 0;

    return availableOrders[availableOrders.length - 1].endDate!;
  }

  /// null 则是买断
  /// 0 则今天将过期
  /// >0 则还有多少天过期
  /// <0 则已经过期几天
  Duration? get expiresIn {
    if (isIncludeLifetimeOrder) {
      return null;
    }

    DateTime now = DateTime.now();
    DateTime nowDate = DateTime(now.year, now.month, now.day);

    return DateTime.fromMicrosecondsSinceEpoch(latestSubscriptionDate)
        .difference(nowDate);
  }

  bool get isExpired {
    return expiresIn != null && expiresIn!.inDays < 0;
  }

  /// 获取用于自动续订的订单模板（以最后一次订单为准）
  Order? get nextPaymentTemplate {
    if (isIncludeLifetimeOrder || availableOrders.isEmpty) {
      return null;
    }

    if (availableOrders[availableOrders.length - 1].paymentFrequency ==
        PaymentFrequency.oneTime) {
      return null;
    }

    return availableOrders[availableOrders.length - 1];
  }
}

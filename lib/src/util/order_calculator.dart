import 'package:collection/collection.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/duration.dart' as my;

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

  /// 协议均值花费算法，计算按协议价格计算的花费：
  /// 订阅周期 1月视为31天
  /// 1年视为365天
  /// 计算月均、年均花费时，均会将订阅费用以上述单位均分到日均后再计算周期金额。
  ///
  /// 比如设置了10元/月的订阅，
  /// 在计算年均花费时，算法为：
  /// perYear = 10 / 31 * 365 = 117.74..
  /// 这和普通预期中的10 * 12 不匹配，但更灵活普适。
  double perPrizeByProtocol(PaymentCycleType paymentCycleType) {
    if (availableOrders.isEmpty) return 0;

    return availableOrders.map((e) {
          return getDailyPaymentPerPeriod(
                  e.paymentCycleType!, e.paymentPerPeriod) *
              my.DurationHelper.paymentCycle2Days[paymentCycleType]!;
        }).fold(0.0, (value, element) => value + element) /
        availableOrders.length;
  }

  /// 实际均值花费算法，计算实际使用时长折算到每天的花费
  /// 如果使用时间不足31天/365天，则月均/年均花费为-1（没有意义）
  double perPrizeByActual(PaymentCycleType paymentCycleType) {
    if (availableOrders.isEmpty || subscribingDaysByActual == 0) return 0;
    if (paymentCycleType != PaymentCycleType.daily &&
        subscribingDaysByActual <
            my.DurationHelper.paymentCycle2Days[paymentCycleType]!) {
      return -1;
    }

    return availableOrders
            .map((e) => e.paymentPerPeriod)
            .fold(0.0, (value, element) => value + element) /
        subscribingDaysByActual *
        my.DurationHelper.paymentCycle2Days[paymentCycleType]!;
  }

  bool get includeLifetimeOrder {
    return availableOrders.firstWhereOrNull(
            (element) => element.paymentType == PaymentType.lifetime) !=
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
              order.startDate, order.endDate!, order.paymentCycleType!)
          .duration;
    }

    return result;
  }

  /// 协议订阅总天数
  /// -1 则是买断
  int get subscribingDaysByProtocol {
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
            .inDays +
        1;
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
  /// 0 则今天将过期
  /// >0 则还有多少天过期
  /// <0 则已经过期几天
  Duration? get expiresIn {
    if (includeLifetimeOrder) {
      return null;
    }

    DateTime now = DateTime.now();
    DateTime nowDate = DateTime(now.year, now.month, now.day);

    return DateTime.fromMicrosecondsSinceEpoch(latestSubscriptionDate)
        .difference(nowDate);
  }

  /// 获取用于自动续订的订单模板（以最后一次订单为准）
  Order? get nextPaymentTemplate {
    if (includeLifetimeOrder || availableOrders.isEmpty) {
      return null;
    }

    return availableOrders[availableOrders.length - 1];
  }
}

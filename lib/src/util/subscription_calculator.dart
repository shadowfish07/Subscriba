import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/util/currency_amount.dart';
import 'package:subscriba/src/util/order_calculator.dart';

class SubscriptionCalculator {
  const SubscriptionCalculator({required this.subscriptions});

  final List<Subscription> subscriptions;

  List<Subscription> get availableSubscriptions {
    final result =
        subscriptions.where((element) => element.deletedAt == null).toList();
    return result;
  }

  /// 协议均值算法，累加每个subscription的均值
  /// lifetime订单会被忽略
  /// 已经过期的订单会被忽略
  CurrencyAmount perPrizeByProtocol(PaymentFrequency paymentFrequency) {
    if (availableSubscriptions.isEmpty) return CurrencyAmount(amount: 0);

    return availableSubscriptions
        .where((element) => !OrderCalculator(orders: element.orders).isExpired)
        .map((e) {
          return OrderCalculator(orders: e.orders)
              .perCostByProtocol(paymentFrequency);
        })
        .where((element) => element.amount != -1)
        .fold(CurrencyAmount(amount: 0),
            (previousValue, element) => previousValue + element);
  }
}

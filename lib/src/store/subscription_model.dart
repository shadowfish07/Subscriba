import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/util/duration.dart';
import 'package:subscriba/src/util/order_calculator.dart';

part 'subscription_model.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionModel = _SubscriptionModel with _$SubscriptionModel;

abstract class _SubscriptionModel with Store {
  @observable
  Subscription instance;

  _SubscriptionModel(this.instance);

  @action
  Future<void> reload() async {
    instance = (await SubscriptionProvider().getSubscription(instance.id))!;
  }

  @action
  Future<void> toggleRenew() async {
    await SubscriptionProvider().setIsRenew(instance.id, !instance.isRenew);
    reload();
  }

  @action
  Future<void> deleteOrder(int id) async {
    await OrderProvider().delete(id);
    reload();
  }

  /// 目前是在订阅将结束的当天或已经结束的时候进行自动续费
  /// 新的订单会按设置的周期类型进行续费，分别对应1/31/365天（这里后期可以允许配置）
  @action
  Future<bool> tryRenew() async {
    if (instance.orders.isEmpty) return false;
    var orderCalculator = OrderCalculator(orders: instance.orders);
    final expiresIn = orderCalculator.expiresIn;
    if (!instance.isRenew || expiresIn == null || expiresIn.inDays > 0) {
      return false;
    }

    while (orderCalculator.expiresIn!.inDays <= 0) {
      final nextPaymentTemplate = orderCalculator.nextPaymentTemplate!;
      final startDate =
          DateTime.fromMicrosecondsSinceEpoch(nextPaymentTemplate.endDate!)
              .add(const Duration(days: 1))
              .microsecondsSinceEpoch;
      final endDate = DateTime.fromMicrosecondsSinceEpoch(startDate)
          .add(Duration(
              days: DurationHelper
                      .paymentCycle2Days[nextPaymentTemplate.paymentCycleType]!
                      .toInt() -
                  1))
          .microsecondsSinceEpoch;

      await OrderProvider().insert(
        Order.create(
          orderDate: startDate,
          paymentType: nextPaymentTemplate.paymentType,
          startDate: startDate,
          endDate: endDate,
          subscriptionId: instance.id,
          paymentPerPeriodUnit: nextPaymentTemplate.paymentPerPeriodUnit,
          paymentCycleType: nextPaymentTemplate.paymentCycleType,
          paymentPerPeriod: nextPaymentTemplate.paymentPerPeriod,
        ),
      );
      await reload();
      orderCalculator = OrderCalculator(orders: instance.orders);
    }
    return true;
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/component/section.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/subscription/subscription_card.dart';
import 'package:subscriba/src/util/order_calculator.dart';

/// 按均值价格从高到底排序，取前3个
/// lifetime、已过期订单不会出现
class MostExpensiveSubscriptionSection extends StatelessWidget {
  const MostExpensiveSubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionModel = Provider.of<SubscriptionsModel>(context);

    return Observer(builder: (context) {
      final filteredList = subscriptionModel.subscriptions.where((element) {
        final orderCalculator =
            OrderCalculator(orders: element.instance.orders);
        return !orderCalculator.isIncludeLifetimeOrder &&
            !orderCalculator.isExpired;
      }).toList();
      final renderingSublist =
          filteredList.sublist(0, min(3, filteredList.length));

      return Section(
        title: "Most Expensive",
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: renderingSublist.length,
          itemBuilder: (context, index) {
            final sortedSubscriptions = List.from(renderingSublist)
              ..sort(((a, b) {
                return OrderCalculator(orders: b.instance.orders)
                    .perCostByProtocol(PaymentFrequency.daily)
                    .compareTo(OrderCalculator(orders: a.instance.orders)
                        .perCostByProtocol(PaymentFrequency.daily));
              }));
            return SubscriptionCard(
              subscription: sortedSubscriptions[index],
              paymentFrequency: PaymentFrequency.yearly,
            );
          },
        ),
      );
    });
  }
}

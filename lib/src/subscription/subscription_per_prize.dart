import 'package:flutter/material.dart';
import 'package:subscriba/src/component/money_text.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/util/order_calculator.dart';

const paymentCycleType2Display = {
  PaymentCycleType.daily: "d",
  PaymentCycleType.monthly: "m",
  PaymentCycleType.yearly: "y"
};

class SubscriptionPerPrize extends StatelessWidget {
  const SubscriptionPerPrize(
      {super.key,
      required this.subscription,
      required this.mainPaymentCycleType});

  final PaymentCycleType mainPaymentCycleType;
  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    final orderCalculator =
        OrderCalculator(orders: subscription.instance.orders);
    final perMainPaymentCyclePrize = orderCalculator.isIncludeLifetimeOrder
        ? orderCalculator.lifetimeCost
        : orderCalculator.perCostByProtocol(mainPaymentCycleType);
    final perDayPaymentCyclePrize =
        orderCalculator.perCostByProtocol(PaymentCycleType.daily);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(children: [
          MoneyText(
            money: perMainPaymentCyclePrize,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          !orderCalculator.isIncludeLifetimeOrder
              ? Text(
                  "/${paymentCycleType2Display[mainPaymentCycleType]}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                )
              : const SizedBox.shrink()
        ]),
        orderCalculator.isIncludeLifetimeOrder
            ? Text("lifetime",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ))
            : mainPaymentCycleType != PaymentCycleType.daily
                ? MoneyText(
                    money: perDayPaymentCyclePrize,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    suffix: "/day",
                  )
                : Container()
      ],
    );
  }
}

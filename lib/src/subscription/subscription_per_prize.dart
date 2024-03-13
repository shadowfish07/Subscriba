import 'package:flutter/material.dart';
import 'package:subscriba/src/component/money_text.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/util/order_calculator.dart';

const paymentFrequency2Display = {
  PaymentFrequency.daily: "d",
  PaymentFrequency.monthly: "m",
  PaymentFrequency.yearly: "y"
};

class SubscriptionPerPrize extends StatelessWidget {
  const SubscriptionPerPrize(
      {super.key,
      required this.subscription,
      required this.mainPaymentFrequency});

  final PaymentFrequency mainPaymentFrequency;
  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    final orderCalculator =
        OrderCalculator(orders: subscription.instance.orders);
    final perMainPaymentCyclePrize = orderCalculator.isIncludeLifetimeOrder
        ? orderCalculator.lifetimeCost
        : orderCalculator.perCostByProtocol(mainPaymentFrequency);
    final perDayPaymentCyclePrize =
        orderCalculator.perCostByProtocol(PaymentFrequency.daily);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        orderCalculator.isExpired
            ? Text(
                "Expired",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              )
            : Row(children: [
                MoneyText(
                  money: perMainPaymentCyclePrize,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                ),
                !orderCalculator.isIncludeLifetimeOrder
                    ? Text(
                        "/${paymentFrequency2Display[mainPaymentFrequency]}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      )
                    : const SizedBox.shrink()
              ]),
        orderCalculator.isIncludeLifetimeOrder
            ? Text("lifetime",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ))
            : mainPaymentFrequency != PaymentFrequency.daily
                ? MoneyText(
                    money: perDayPaymentCyclePrize,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    suffix: "/day",
                    showLineThrough: orderCalculator.isExpired,
                  )
                : Container()
      ],
    );
  }
}

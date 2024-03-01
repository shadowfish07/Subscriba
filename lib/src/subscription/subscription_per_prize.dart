import 'package:flutter/material.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
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
    final perMainPaymentCyclePrize =
        OrderCalculator(orders: subscription.instance.orders)
            .perPrizeByProtocol(mainPaymentCycleType);
    final perDayPaymentCyclePrize =
        OrderCalculator(orders: subscription.instance.orders)
            .perPrizeByProtocol(PaymentCycleType.daily);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(children: [
          Text(
            "\$${perMainPaymentCyclePrize.toStringAsFixed(2)}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: "Alibaba"),
          ),
          Text(
            "/${paymentCycleType2Display[mainPaymentCycleType]}",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          )
        ]),
        mainPaymentCycleType != PaymentCycleType.daily
            ? Text(
                "\$${perDayPaymentCyclePrize.toStringAsFixed(2)}/day",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontFamily: "Alibaba"),
              )
            : Container()
      ],
    );
  }
}

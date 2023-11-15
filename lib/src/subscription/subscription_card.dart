import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/subsciption_detail/subsciption_detail_view.dart';
import 'package:subscriba/src/subscription/subscription_per_prize.dart';
import 'package:subscriba/src/subscriptions/subscriptions_page_model.dart';
import 'package:subscriba/src/util/order_calculator.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard(
      {super.key, required this.subscription, required this.paymentCycleType});

  final SubscriptionModel subscription;
  final PaymentCycleType paymentCycleType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubscriptionDetailView(
                    subscription: subscription,
                  )),
        );
      },
      child: Card(
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Observer(builder: (context) {
                  return Text(subscription.instance.title,
                      style: Theme.of(context).textTheme.titleMedium);
                }),
                SubscriptionPerPrize(
                  subscription: subscription,
                  mainPaymentCycleType: paymentCycleType,
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}

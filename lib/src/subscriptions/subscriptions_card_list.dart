import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/styles/styles.dart';
import 'package:subscriba/src/subscription/subscription_card.dart';
import 'package:subscriba/src/subscriptions/subscriptions_page_model.dart';

class SubscriptionsCardList extends StatelessWidget {
  const SubscriptionsCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final subscriptionModel = Provider.of<SubscriptionModel>(context);
        final subscriptionPageModel =
            Provider.of<SubscriptionPageModel>(context);

        return ListView.builder(
            padding:
                defaultCenterPadding.add(const EdgeInsets.only(bottom: 48)),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subscriptionModel.subscriptions.length,
            itemBuilder: (context, index) {
              final subscription = subscriptionModel.subscriptions[index];
              return Observer(
                  builder: (_) => SubscriptionCard(
                        subscription: subscription,
                        paymentCycleType:
                            subscriptionPageModel.paymentCycleType,
                      ));
            });
      },
    );
  }
}

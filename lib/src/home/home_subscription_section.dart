import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/home/home_section.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/subscription/subscription_card.dart';

class HomeSubscriptionSection extends StatelessWidget {
  const HomeSubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionModel = Provider.of<SubscriptionModel>(context);

    return Observer(builder: (context) {
      return HomeSection(
        title: "Most Expensive",
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: subscriptionModel.subscriptions.length,
          itemBuilder: (context, index) {
            final subscription = subscriptionModel.subscriptions[index];
            return SubscriptionCard(
              subscription: subscription,
              paymentCycleType: PaymentCycleType.yearly,
            );
          },
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:subscriba/src/add_subscription/add_subscription_view.dart';
import 'package:subscriba/src/subscriptions/subscriptions_app_bar.dart';
import 'package:subscriba/src/subscriptions/subscriptions_body.dart';

class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressCreateSubscriptionFAB() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddSubscriptionView()),
      );
    }

    return Scaffold(
      appBar: const SubscriptionAppBar(),
      body: const SubscriptionsBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressCreateSubscriptionFAB,
        child: const Icon(Icons.add),
      ),
    );
  }
}

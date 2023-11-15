import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/add_subscription_form.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

class AddSubscriptionView extends StatelessWidget {
  static const routeName = '/subscription/add';

  const AddSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Subscription"),
      ),
      body: Provider(
        create: (_) => FormModel(),
        builder: (context, child) => const AddSubscriptionForm(),
      ),
    );
  }
}

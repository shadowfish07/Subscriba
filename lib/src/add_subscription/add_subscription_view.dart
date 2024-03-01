import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/add_subscription_form.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';

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

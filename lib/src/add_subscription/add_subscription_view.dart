import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/add_subscription_form.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

class AddSubscriptionView extends StatefulWidget {
  static const routeName = '/subscription/add';

  const AddSubscriptionView({super.key});

  @override
  State<StatefulWidget> createState() => _AddSubscriptionView();
}

class _AddSubscriptionView extends State<AddSubscriptionView> {
  final GlobalKey<FormState> subscriptionFormKey = GlobalKey();
  final GlobalKey<FormState> recurringFormKey = GlobalKey();
  final TextEditingController subscriptionNameController =
      TextEditingController();
  final TextEditingController subscriptionDescriptionController =
      TextEditingController();
  final TextEditingController startTimeDateController = TextEditingController();
  final TextEditingController endTimeDateController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController totalPaymentAmountController =
      TextEditingController();
  final TextEditingController paymentPerPeriodController =
      TextEditingController();

  late SubscriptionsModel subscriptionModel;
  final formModel = FormModel();

  @override
  void initState() {
    super.initState();
    formModel.setupValidations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      subscriptionModel =
          Provider.of<SubscriptionsModel>(context, listen: false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    formModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Subscription"),
      ),
      body: Provider(
        create: (_) => formModel,
        builder: (context, child) => AddSubscriptionForm(
          subscriptionFormKey: subscriptionFormKey,
          recurringFormKey: recurringFormKey,
          subscriptionNameController: subscriptionNameController,
          subscriptionDescriptionController: subscriptionDescriptionController,
          startTimeDateController: startTimeDateController,
          endTimeDateController: endTimeDateController,
          durationController: durationController,
          totalPaymentAmountController: totalPaymentAmountController,
          paymentPerPeriodController: paymentPerPeriodController,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/add_subscription_form.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

final formModel = FormModel();

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

  late SubscriptionModel subscriptionModel;

  @override
  void initState() {
    super.initState();
    formModel.setupValidations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      subscriptionModel =
          Provider.of<SubscriptionModel>(context, listen: false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    formModel.dispose();
  }

  Future<void> saveSubscription() async {
    formModel.validateAll();

    if (!formModel.error.hasErrors) {
      final subscriptionId = await SubscriptionProvider().insert(
          Subscription.create(
              title: formModel.subscriptionName!,
              description: formModel.subscriptionDescription));

      await OrderProvider().insert(
        Order.create(
            orderDate: formModel.startTimeTimestamp!,
            paymentType: formModel.paymentType,
            startDate: formModel.startTimeTimestamp!,
            endDate: formModel.endTimeTimestamp!,
            subscriptionId: subscriptionId,
            paymentPerPeriodUnit: "\$",
            paymentCycleType: formModel.paymentCycleType,
            paymentPerPeriod: formModel.paymentPerPeriod),
      );

      subscriptionModel.loadSubscriptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Subscription"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Provider(
              create: (_) => formModel,
              builder: (context, child) => AddSubscriptionForm(
                subscriptionFormKey: subscriptionFormKey,
                recurringFormKey: recurringFormKey,
                subscriptionNameController: subscriptionNameController,
                subscriptionDescriptionController:
                    subscriptionDescriptionController,
                startTimeDateController: startTimeDateController,
                endTimeDateController: endTimeDateController,
                durationController: durationController,
                totalPaymentAmountController: totalPaymentAmountController,
                paymentPerPeriodController: paymentPerPeriodController,
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveSubscription().then((_) {
            Navigator.pop(context);
          });
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

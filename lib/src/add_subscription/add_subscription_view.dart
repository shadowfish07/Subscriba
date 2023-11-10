import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscriba/src/add_subscription/add_subscription_form.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

class AddSubscriptionView extends StatefulWidget {
  static const routeName = '/subscription/add';

  const AddSubscriptionView({super.key});

  @override
  State<StatefulWidget> createState() => _AddSubscriptionView();
}

class _AddSubscriptionView extends State<AddSubscriptionView>
    with TickerProviderStateMixin {
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
  late final TabController paymentTypeTabController;

  @override
  void initState() {
    super.initState();
    paymentTypeTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    paymentTypeTabController.dispose();
  }

  void saveSubscription() async {
    final subscriptionFormValidation =
        subscriptionFormKey.currentState?.validate();
    final recurringFormValidation = paymentTypeTabController.index == 0
        ? recurringFormKey.currentState?.validate()
        : true;

    if (subscriptionFormValidation == true && recurringFormValidation == true) {
      final subscriptionId = await SubscriptionProvider().insert(
          Subscription.create(
              title: subscriptionNameController.text,
              description: subscriptionDescriptionController.text));

      await OrderProvider().insert(
        Order.create(
          orderDate: DateFormat.yMd()
              .parseLoose(startTimeDateController.text)
              .microsecondsSinceEpoch,
          paymentType: paymentTypeTabController.index == 0
              ? PaymentType.recurring
              : PaymentType.onetime,
          startDate: DateFormat.yMd()
              .parseLoose(startTimeDateController.text)
              .microsecondsSinceEpoch,
          endDate: DateFormat.yMd()
              .parseLoose(endTimeDateController.text)
              .microsecondsSinceEpoch,
          subscriptionId: subscriptionId,
          paymentPerPeriodUnit: "\$",
          // paymentCycleType: PaymentCycleHelper(timeUnit: paymentc)
        ),
      );
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
            child: AddSubscriptionForm(
              subscriptionFormKey: subscriptionFormKey,
              recurringFormKey: recurringFormKey,
              paymentTypeTabController: paymentTypeTabController,
              subscriptionNameController: subscriptionNameController,
              subscriptionDescriptionController:
                  subscriptionDescriptionController,
              startTimeDateController: startTimeDateController,
              endTimeDateController: endTimeDateController,
              durationController: durationController,
              totalPaymentAmountController: totalPaymentAmountController,
              paymentPerPeriodController: paymentPerPeriodController,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveSubscription,
        child: const Icon(Icons.save),
      ),
    );
  }
}

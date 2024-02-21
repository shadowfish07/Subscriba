import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/add_subscription/lifetime_tab.dart';
import 'package:subscriba/src/add_subscription/recurring_tab.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/order/order_form.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/styles/styles.dart';

class OrderAdd extends StatelessWidget {
  static const routeName = '/order/add';
  final int subscriptionId;

  const OrderAdd({super.key, required this.subscriptionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Order"),
      ),
      body: _Form(subscriptionId: subscriptionId),
    );
  }
}

class _Form extends StatefulWidget {
  final int subscriptionId;

  const _Form({super.key, required this.subscriptionId});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> with TickerProviderStateMixin {
  late final TabController paymentTypeTabController;
  final formModel = FormModel();

  @override
  void initState() {
    super.initState();
    paymentTypeTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionsModel = Provider.of<SubscriptionsModel>(context);

    Future<bool> saveOrder() async {
      formModel.validateAll(true);

      if (!formModel.error.hasErrors) {
        await OrderProvider().insert(
          Order.create(
              subscriptionId: widget.subscriptionId,
              orderDate: formModel.startTimeTimestamp!,
              paymentType: formModel.paymentType,
              startDate: formModel.startTimeTimestamp!,
              endDate: formModel.endTimeTimestamp,
              paymentPerPeriodUnit: "\$",
              paymentCycleType: formModel.paymentCycleType,
              paymentPerPeriod: formModel.paymentPerPeriod),
        );

        subscriptionsModel.loadSubscriptions();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully Created'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        return true;
      }

      return false;
    }

    return ListView(children: [
      Padding(
        padding: defaultCenterPadding.add(const EdgeInsets.only(top: 16)),
        child: OrderForm(
          formModel: formModel,
          onSave: saveOrder,
        ),
      ),
    ]);
  }
}

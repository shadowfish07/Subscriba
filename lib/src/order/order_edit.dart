import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/order/order_form.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/styles/styles.dart';

class OrderEdit extends StatelessWidget {
  static const routeName = '/order/edit';
  final int orderId;

  const OrderEdit({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Order"),
      ),
      body: _Form(orderId: orderId),
    );
  }
}

class _Form extends StatefulWidget {
  final int orderId;

  const _Form({required this.orderId});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> with TickerProviderStateMixin {
  late final TabController paymentTypeTabController;
  final formModel = FormModel();
  late Order originOrder;

  Future<void> init() async {
    originOrder = (await OrderProvider().getOrder(widget.orderId))!;
    formModel.fromOrder(originOrder);
  }

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
        await OrderProvider().update(
          Order.create(
              id: originOrder.id,
              subscriptionId: originOrder.subscriptionId,
              orderDate: formModel.startTimeTimestamp!,
              paymentType: formModel.paymentType,
              startDate: formModel.startTimeTimestamp!,
              endDate: formModel.endTimeTimestamp,
              paymentFrequency: formModel.paymentFrequency,
              paymentPerPeriod: formModel.paymentPerPeriod!),
        );

        subscriptionsModel.loadSubscriptions();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully Updated'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        return true;
      }

      return false;
    }

    return FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
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
        });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/add_subscription/lifetime_tab.dart';
import 'package:subscriba/src/add_subscription/recurring_tab.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/order/order_edit.dart';

typedef OnSave = Future<bool> Function();

class OrderForm extends StatelessWidget {
  const OrderForm({
    super.key,
    required this.formModel,
    required this.onSave,
  });

  final FormModel formModel;
  final OnSave onSave;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Observer(builder: (context) {
              return SegmentedButton<PaymentType>(
                selected: <PaymentType>{formModel.paymentType},
                segments: const [
                  ButtonSegment(
                      value: PaymentType.recurring, label: Text("Recurring")),
                  ButtonSegment(
                      value: PaymentType.lifetime, label: Text("Lifetime"))
                ],
                onSelectionChanged: (value) {
                  formModel.setPaymentType(value.first);
                },
              );
            }),
          ),
          const SizedBox(
            height: 16,
          ),
          Provider(
            create: (_) => formModel,
            child: Observer(builder: (_) {
              return formModel.paymentType == PaymentType.recurring
                  ? const RecurringTab()
                  : const LifetimeTab();
            }),
          ),
          SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: () {
                    onSave().then((isSuccess) {
                      if (!isSuccess) return;
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text("Save"))),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/component/section.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/subscription_detail/per_period_cost_cards_row.dart';
import 'package:subscriba/src/util/order_calculator.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

class RecurringTab extends StatelessWidget {
  const RecurringTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context);
    final startDateController =
        TextEditingController(text: formModel.startTimeDate);
    final endDateController =
        TextEditingController(text: formModel.endTimeDate);
    final paymentPerPeriodController =
        TextEditingController(text: formModel.paymentPerPeriodText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Section.subSectionH2(
            title: "Duration",
            child: Column(
              children: [
                Observer(builder: (context) {
                  return TextField(
                    controller: startDateController,
                    keyboardType: TextInputType.none,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Start Date',
                        errorText: formModel.error.startTimeDate),
                    readOnly: true,
                    showCursor: false,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: formModel.startTimeDate == null
                                  ? DateTime.now()
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                      formModel.startTimeTimestamp!),
                              firstDate: DateTime.utc(2000, 1, 1),
                              lastDate: DateTime.utc(2100, 1, 1))
                          .then((value) {
                        if (value != null) {
                          formModel.startTimeDate =
                              DateFormat.yMd().format(value);
                          startDateController.text = formModel.startTimeDate!;
                        }
                      });
                    },
                  );
                }),
                const SizedBox(
                  height: 16,
                ),
                Observer(builder: (context) {
                  return TextField(
                    controller: endDateController,
                    keyboardType: TextInputType.none,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'End Date',
                        helperText: formModel.duration == null
                            ? " "
                            : "Subscribed for ${formModel.duration} days",
                        errorText: formModel.error.endTimeDate),
                    readOnly: true,
                    showCursor: false,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: formModel.endTimeDate == null
                                  ? DateTime.now()
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                      formModel.endTimeTimestamp!),
                              firstDate: DateTime.utc(2000, 1, 1),
                              lastDate: DateTime.utc(2100, 1, 1))
                          .then((value) {
                        if (value != null) {
                          formModel.endTimeDate =
                              DateFormat.yMd().format(value);
                          endDateController.text = formModel.endTimeDate!;
                        }
                      });
                    },
                  );
                })
              ],
            )),
        Section.subSectionH2(
            title: "Payment",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Observer(builder: (context) {
                  return DropdownButtonFormField(
                    value: formModel.paymentCycleType,
                    decoration: const InputDecoration(
                      labelText: 'Payment Cycle',
                      border: OutlineInputBorder(),
                    ),
                    items: PaymentCycleType.values
                        .map<DropdownMenuItem<PaymentCycleType>>(
                            (PaymentCycleType value) {
                      return DropdownMenuItem<PaymentCycleType>(
                        value: value,
                        child: Text(PaymentCycleHelper.enum2FormalStr[value]!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue == null) return;
                      formModel.paymentCycleType = newValue;
                    },
                  );
                }),
                const SizedBox(
                  height: 16,
                ),
                Observer(builder: (context) {
                  return TextField(
                    style: const TextStyle(fontFamily: "Alibaba"),
                    controller: paymentPerPeriodController,
                    onChanged: (value) {
                      formModel.paymentPerPeriodText = value;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[1-9][0-9]*\.{0,1}\d*$')), // 只允许输入0到9的数字
                    ],
                    decoration: InputDecoration(
                        prefixStyle: const TextStyle(fontFamily: "Alibaba"),
                        border: const OutlineInputBorder(),
                        labelText: 'Payment Per Period',
                        prefix: const Text("\$"),
                        errorText: formModel.error.paymentPerPeriod),
                  );
                }),
                const SizedBox(
                  height: 16,
                ),
                Observer(builder: (context) {
                  final tempOrder = Order(
                      id: 0,
                      createdAt: 0,
                      updatedAt: 0,
                      subscriptionId: 0,
                      orderDate: 0,
                      paymentType: PaymentType.recurring,
                      startDate: formModel.startTimeTimestamp ?? 0,
                      endDate: formModel.endTimeTimestamp,
                      paymentPerPeriod: formModel.paymentPerPeriod,
                      paymentCycleType: formModel.paymentCycleType);

                  final orderCalculator = OrderCalculator(orders: [tempOrder]);
                  final dailyCost = formModel.paymentPerPeriodText == null
                      ? 0.0
                      : orderCalculator
                          .perCostByProtocol(PaymentCycleType.daily);
                  final monthlyCost = formModel.paymentPerPeriodText == null
                      ? 0.0
                      : orderCalculator
                          .perCostByProtocol(PaymentCycleType.monthly);
                  final annuallyCost = formModel.paymentPerPeriodText == null
                      ? 0.0
                      : orderCalculator
                          .perCostByProtocol(PaymentCycleType.yearly);
                  return PerPeriodCostCardsRow(
                      dailyCost: dailyCost,
                      monthlyCost: monthlyCost,
                      annuallyCost: annuallyCost);
                }),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "*The calculated average does not meet expectations?",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            )),
      ],
    );
  }
}

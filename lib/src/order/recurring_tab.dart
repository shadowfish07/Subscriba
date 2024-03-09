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
import 'package:subscriba/src/util/payment_frequency_helper.dart';

// TODO 这个信息再想想交互怎么做，可能考虑放在弹窗里展示
const onetimeCalculationHint = '''
Average Cost Calculation Rule: 
The daily average cost is determined by dividing the total cost amount by the subscription period. 
The daily, monthly, and annual average costs are then calculated by multiplying this value by 1, 31, and 365 respectively.
''';

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
                        helperText: formModel.paymentFrequency == null
                            ? ''
                            : "${PaymentFrequencyHelper.enum2FormalStr[formModel.paymentFrequency]} payment",
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
                      paymentFrequency: formModel.paymentFrequency);

                  final orderCalculator = OrderCalculator(orders: [tempOrder]);
                  final dailyCost = formModel.paymentPerPeriodText == null
                      ? 0.0
                      : orderCalculator
                          .perCostByProtocol(PaymentFrequency.daily);
                  final monthlyCost = formModel.paymentPerPeriodText == null
                      ? 0.0
                      : orderCalculator
                          .perCostByProtocol(PaymentFrequency.monthly);
                  final annuallyCost = formModel.paymentPerPeriodText == null
                      ? 0.0
                      : orderCalculator
                          .perCostByProtocol(PaymentFrequency.yearly);
                  return PerPeriodCostCardsRow(
                      dailyCost: dailyCost,
                      monthlyCost: monthlyCost,
                      annuallyCost: annuallyCost);
                }),
                const SizedBox(
                  height: 8,
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

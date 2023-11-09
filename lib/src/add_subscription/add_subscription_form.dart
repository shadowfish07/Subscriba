import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriba/src/styles/styles.dart';
import 'package:subscriba/src/util/payment_calculator.dart';
import 'package:subscriba/src/util/duration.dart' as util;
import 'package:subscriba/src/util/payment_cycle.dart';
import 'package:intl/intl.dart';

import '../util/validator.dart';

class AddSubscriptionForm extends StatefulWidget {
  const AddSubscriptionForm(
      {super.key,
      required this.subscriptionFormKey,
      required this.recurringFormKey,
      required this.paymentTypeTabController,
      required this.subscriptionNameController,
      required this.subscriptionDescriptionController,
      required this.startTimeDateController,
      required this.endTimeDateController,
      required this.durationController,
      required this.totalPaymentAmountController,
      required this.paymentPerPeriodController});

  final GlobalKey<FormState> subscriptionFormKey;
  final GlobalKey<FormState> recurringFormKey;
  final TabController paymentTypeTabController;
  final TextEditingController subscriptionNameController;
  final TextEditingController subscriptionDescriptionController;
  final TextEditingController startTimeDateController;
  final TextEditingController endTimeDateController;
  final TextEditingController durationController;
  final TextEditingController totalPaymentAmountController;
  final TextEditingController paymentPerPeriodController;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _AddSubscriptionFormState(
      subscriptionFormKey: subscriptionFormKey,
      recurringFormKey: recurringFormKey,
      paymentTypeTabController: paymentTypeTabController,
      subscriptionNameController: subscriptionNameController,
      subscriptionDescriptionController: subscriptionDescriptionController,
      startTimeDateController: startTimeDateController,
      endTimeDateController: endTimeDateController,
      durationController: durationController,
      totalPaymentAmountController: totalPaymentAmountController,
      paymentPerPeriodController: paymentPerPeriodController);
}

class _AddSubscriptionFormState extends State<AddSubscriptionForm> {
  _AddSubscriptionFormState(
      {required this.subscriptionFormKey,
      required this.recurringFormKey,
      required this.paymentTypeTabController,
      required this.subscriptionNameController,
      required this.subscriptionDescriptionController,
      required this.startTimeDateController,
      required this.endTimeDateController,
      required this.durationController,
      required this.totalPaymentAmountController,
      required this.paymentPerPeriodController});

  final GlobalKey<FormState> subscriptionFormKey;
  final GlobalKey<FormState> recurringFormKey;
  final TabController paymentTypeTabController;
  final TextEditingController subscriptionNameController;
  final TextEditingController subscriptionDescriptionController;
  final TextEditingController startTimeDateController;
  final TextEditingController endTimeDateController;
  final TextEditingController durationController;
  final TextEditingController totalPaymentAmountController;
  final TextEditingController paymentPerPeriodController;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: subscriptionFormKey,
        child: Column(
          children: [
            Padding(
              padding: defaultCenterPadding
                  .add(const EdgeInsets.symmetric(vertical: 16)),
              child: TextFormField(
                  controller: subscriptionNameController,
                  validator: notEmptyValidator,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subscription Name',
                  )),
            ),
            Padding(
              padding: defaultCenterPadding,
              child: TextFormField(
                  controller: subscriptionDescriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subscription Description',
                  )),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: TabBar(controller: paymentTypeTabController, tabs: const [
                Tab(text: "recurring"),
                Tab(
                  text: "one-time",
                )
              ]),
            ),
            Expanded(
              child: Padding(
                padding:
                    defaultCenterPadding.add(const EdgeInsets.only(bottom: 16)),
                child: TabBarView(
                  controller: paymentTypeTabController,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        RecurringTab(
                            recurringFormKey: recurringFormKey,
                            startTimeDateController: startTimeDateController,
                            endTimeDateController: endTimeDateController,
                            durationController: durationController,
                            totalPaymentAmountController:
                                totalPaymentAmountController,
                            paymentPerPeriodController:
                                paymentPerPeriodController),
                      ],
                    ),
                    Text("1"),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class RecurringTab extends StatefulWidget {
  const RecurringTab(
      {super.key,
      required this.recurringFormKey,
      required this.startTimeDateController,
      required this.endTimeDateController,
      required this.durationController,
      required this.totalPaymentAmountController,
      required this.paymentPerPeriodController});

  final GlobalKey<FormState> recurringFormKey;
  final TextEditingController startTimeDateController;
  final TextEditingController endTimeDateController;
  final TextEditingController durationController;
  final TextEditingController totalPaymentAmountController;
  final TextEditingController paymentPerPeriodController;

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _RecurringTab(
          recurringFormKey: recurringFormKey,
          startTimeDateController: startTimeDateController,
          endTimeDateController: endTimeDateController,
          durationController: durationController,
          totalPaymentAmountController: totalPaymentAmountController,
          paymentPerPeriodController: paymentPerPeriodController);
}

class _RecurringTab extends State<RecurringTab> {
  _RecurringTab(
      {required this.recurringFormKey,
      required this.startTimeDateController,
      required this.endTimeDateController,
      required this.durationController,
      required this.totalPaymentAmountController,
      required this.paymentPerPeriodController});

  final GlobalKey<FormState> recurringFormKey;
  final TextEditingController startTimeDateController;
  final TextEditingController endTimeDateController;
  final TextEditingController durationController;
  final TextEditingController totalPaymentAmountController;
  final TextEditingController paymentPerPeriodController;
  final totalPaymentFocusNode = FocusNode();
  final paymentPerPeriodFocusNode = FocusNode();

  String paymentCycle = "Monthly";

  void updateTotalPaymentAmount() {
    if (paymentPerPeriodController.text != '' &&
        durationController.text != '') {
      final totalPaymentAmount = PaymentCalculator(
              duration: util.Duration(
                  duration: int.parse(durationController.text),
                  unit: PaymentCycleHelper(timeUnit: "Day")),
              paymentCycle: PaymentCycleHelper(timeUnit: paymentCycle))
          .getTotalPaymentAmount(double.parse(paymentPerPeriodController.text))
          .toStringAsFixed(2);

      if (totalPaymentAmount != totalPaymentAmountController.text &&
          !totalPaymentFocusNode.hasFocus) {
        totalPaymentAmountController.text = totalPaymentAmount;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    void updateDuration() {
      if (startTimeDateController.text != "" &&
          endTimeDateController.text != "") {
        final difference = DateFormat.yMd()
            .parseLoose(endTimeDateController.text)
            .difference(
                DateFormat.yMd().parseLoose(startTimeDateController.text));
        if (durationController.text != difference.inDays.toString() &&
            int.parse(difference.inDays.toString()) > 0) {
          durationController.text = difference.inDays.toString();
        }
      }
    }

    startTimeDateController.addListener(() {
      updateDuration();
      updateTotalPaymentAmount();
    });
    endTimeDateController.addListener(() {
      updateDuration();
      updateTotalPaymentAmount();
    });
    durationController.addListener(() {
      if (startTimeDateController.text != "" && durationController.text != "") {
        final newEndTime = DateFormat.yMd()
            .parseLoose(startTimeDateController.text)
            .add(Duration(days: int.parse(durationController.text)));
        final newEndTimeStr = DateFormat.yMd().format(newEndTime);

        if (newEndTimeStr != endTimeDateController.text) {
          endTimeDateController.text = newEndTimeStr;

          updateTotalPaymentAmount();
        }
      }
    });
    paymentPerPeriodController.addListener(updateTotalPaymentAmount);
    totalPaymentAmountController.addListener(() {
      if (totalPaymentAmountController.text != '' &&
          durationController.text != '') {
        final paymentPerPeriod = PaymentCalculator(
                duration: util.Duration(
                    duration: int.parse(durationController.text),
                    unit: PaymentCycleHelper(timeUnit: "Day")),
                paymentCycle: PaymentCycleHelper(timeUnit: paymentCycle))
            .getPaymentPerPeriod(
                double.parse(totalPaymentAmountController.text))
            .toStringAsFixed(2);

        if (paymentPerPeriod != paymentPerPeriodController.text &&
            !paymentPerPeriodFocusNode.hasFocus) {
          paymentPerPeriodController.text = paymentPerPeriod;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    startTimeDateController.dispose();
    endTimeDateController.dispose();
    durationController.dispose();
    totalPaymentAmountController.dispose();
    paymentPerPeriodController.dispose();
    totalPaymentFocusNode.dispose();
    paymentPerPeriodFocusNode.dispose();
  }

  bool validateForm() {
    return recurringFormKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: recurringFormKey,
        child: Column(
          children: [
            TextFormField(
              validator: notEmptyValidator,
              controller: startTimeDateController,
              keyboardType: TextInputType.none,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Start Date',
              ),
              readOnly: true,
              showCursor: false,
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: startTimeDateController.text == ""
                            ? DateTime.now()
                            : DateFormat.yMd()
                                .parseLoose(startTimeDateController.text),
                        firstDate: DateTime.utc(2000, 1, 1),
                        lastDate: DateTime.utc(2100, 1, 1))
                    .then((value) => {
                          if (value != null)
                            startTimeDateController.text =
                                DateFormat.yMd().format(value)
                        });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                      validator: notEmptyValidator,
                      keyboardType: TextInputType.none,
                      controller: endTimeDateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'End Date',
                      ),
                      showCursor: false,
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: endTimeDateController.text == ""
                                    ? DateTime.now()
                                    : DateFormat.yMd()
                                        .parseLoose(endTimeDateController.text),
                                firstDate: DateTime.utc(2000, 1, 1),
                                lastDate: DateTime.utc(2100, 1, 1))
                            .then((value) => {
                                  if (value != null)
                                    endTimeDateController.text =
                                        DateFormat.yMd().format(value)
                                });
                      }),
                ),
                const SizedBox(
                    width:
                        8), // Optional: to add some space between text fields.
                Expanded(
                  child: TextFormField(
                    validator: notEmptyValidator,
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[1-9][0-9]*')), // 只允许输入0到9的数字
                    ],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Duration',
                        suffix: Text("Day")),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: paymentCycle,
              decoration: const InputDecoration(
                  labelText: 'Payment Cycle', border: OutlineInputBorder()),
              items: ["Daily", "Monthly", "Yearly"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue == null) return;
                setState(() {
                  paymentCycle = newValue;
                  updateTotalPaymentAmount();
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  validator: notEmptyValidator,
                  controller: paymentPerPeriodController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[1-9][0-9]*\.{0,1}\d*$')), // 只允许输入0到9的数字
                  ],
                  focusNode: paymentPerPeriodFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Payment Per Period',
                      suffix: Text("\$")),
                )),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    validator: notEmptyValidator,
                    controller: totalPaymentAmountController,
                    keyboardType: TextInputType.number,
                    focusNode: totalPaymentFocusNode,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[1-9][0-9]*\.{0,1}\d*$')), // 只允许输入0到9的数字
                    ],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Total Payment Amount',
                        suffix: Text("\$")),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

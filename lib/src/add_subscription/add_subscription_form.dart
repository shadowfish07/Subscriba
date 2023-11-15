import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/add_subscription_view.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/add_subscription/recurring_tab.dart';
import 'package:subscriba/src/component/section.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/store/subscription_model.dart';
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
      required this.subscriptionNameController,
      required this.subscriptionDescriptionController,
      required this.startTimeDateController,
      required this.endTimeDateController,
      required this.durationController,
      required this.totalPaymentAmountController,
      required this.paymentPerPeriodController});

  final GlobalKey<FormState> subscriptionFormKey;
  final GlobalKey<FormState> recurringFormKey;
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
      subscriptionNameController: subscriptionNameController,
      subscriptionDescriptionController: subscriptionDescriptionController,
      startTimeDateController: startTimeDateController,
      endTimeDateController: endTimeDateController,
      durationController: durationController,
      totalPaymentAmountController: totalPaymentAmountController,
      paymentPerPeriodController: paymentPerPeriodController);
}

class _AddSubscriptionFormState extends State<AddSubscriptionForm>
    with TickerProviderStateMixin {
  _AddSubscriptionFormState(
      {required this.subscriptionFormKey,
      required this.recurringFormKey,
      required this.subscriptionNameController,
      required this.subscriptionDescriptionController,
      required this.startTimeDateController,
      required this.endTimeDateController,
      required this.durationController,
      required this.totalPaymentAmountController,
      required this.paymentPerPeriodController});

  final GlobalKey<FormState> subscriptionFormKey;
  final GlobalKey<FormState> recurringFormKey;
  late final TabController paymentTypeTabController;
  final TextEditingController subscriptionNameController;
  final TextEditingController subscriptionDescriptionController;
  final TextEditingController startTimeDateController;
  final TextEditingController endTimeDateController;
  final TextEditingController durationController;
  final TextEditingController totalPaymentAmountController;
  final TextEditingController paymentPerPeriodController;

  @override
  void initState() {
    super.initState();
    paymentTypeTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context);
    final subscriptionModel = Provider.of<SubscriptionModel>(context);

    Future<bool> saveSubscription() async {
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

        return true;
      }

      return false;
    }

    return ListView(
      children: [
        Padding(
          padding: defaultCenterPadding
              .add(const EdgeInsets.symmetric(vertical: 16)),
          child: Observer(builder: (context) {
            return TextField(
                onChanged: (value) => formModel.subscriptionName = value,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Subscription Name',
                    errorText: formModel.error.subscriptionName));
          }),
        ),
        Padding(
          padding: defaultCenterPadding.add(const EdgeInsets.only(bottom: 16)),
          child: TextField(
              onChanged: (value) => formModel.subscriptionDescription = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subscription Description',
              )),
        ),
        const SizedBox(height: 8),
        Section(
          title: "Add Order",
          child: SizedBox(
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
                            value: PaymentType.recurring,
                            label: Text("Recurring")),
                        ButtonSegment(
                            value: PaymentType.lifetime,
                            label: Text("Lifetime"))
                      ],
                      onSelectionChanged: (value) {
                        formModel.paymentType = value.first;
                      },
                    );
                  }),
                ),
                const SizedBox(
                  height: 16,
                ),
                Observer(
                    builder: (_) =>
                        formModel.paymentType == PaymentType.recurring
                            ? const RecurringTab()
                            : Container()),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {
                          saveSubscription().then((isSuccess) {
                            if (!isSuccess) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Subscription Added'),
                                width: 170.0, // Width of the SnackBar.
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          });
                        },
                        child: const Text("Save"))),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class _RecurringTab extends State<RecurringTab> {
//   _RecurringTab({
//     required this.recurringFormKey,
//   });

//   final GlobalKey<FormState> recurringFormKey;
//   final TextEditingController startTimeDateController = TextEditingController();
//   final TextEditingController endTimeDateController = TextEditingController();
//   final TextEditingController durationController = TextEditingController();
//   final TextEditingController totalPaymentAmountController =
//       TextEditingController();
//   final TextEditingController paymentPerPeriodController =
//       TextEditingController();
//   final totalPaymentFocusNode = FocusNode();
//   final paymentPerPeriodFocusNode = FocusNode();

//   void updateTotalPaymentAmount(FormModel formModel) {
//     if (paymentPerPeriodController.text != '' &&
//         durationController.text != '') {
//       final totalPaymentAmount = PaymentCalculator(
//               duration: util.Duration(
//                   duration: int.parse(durationController.text),
//                   unit: PaymentCycleHelper(timeUnit: "Day").paymentCycle),
//               paymentCycle: formModel.paymentCycleType)
//           .getTotalPaymentAmount(double.parse(paymentPerPeriodController.text))
//           .toStringAsFixed(2);

//       if (totalPaymentAmount != totalPaymentAmountController.text &&
//           !totalPaymentFocusNode.hasFocus) {
//         totalPaymentAmountController.text = totalPaymentAmount;
//         formModel.totalPaymentAmountText = totalPaymentAmount;
//       }
//     }
//   }

//   void updateDuration() {
//     if (startTimeDateController.text != "" &&
//         endTimeDateController.text != "") {
//       final difference = DateFormat.yMd()
//           .parseLoose(endTimeDateController.text)
//           .difference(
//               DateFormat.yMd().parseLoose(startTimeDateController.text));
//       final diffInDays = difference.inDays + 1;
//       if (durationController.text != diffInDays.toString() &&
//           int.parse(diffInDays.toString()) > 0) {
//         durationController.text = diffInDays.toString();
//         formModel.durationText = diffInDays.toString();
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final formModel = Provider.of<FormModel>(context, listen: false);
//       startTimeDateController.addListener(() {
//         updateDuration();
//         updateTotalPaymentAmount(formModel);
//       });
//       endTimeDateController.addListener(() {
//         updateDuration();
//         updateTotalPaymentAmount(formModel);
//       });
//       durationController.addListener(() {
//         if (startTimeDateController.text != "" &&
//             durationController.text != "") {
//           final newEndTime = DateFormat.yMd()
//               .parseLoose(startTimeDateController.text)
//               .add(Duration(days: int.parse(durationController.text) - 1));
//           final newEndTimeStr = DateFormat.yMd().format(newEndTime);

//           if (newEndTimeStr != endTimeDateController.text) {
//             endTimeDateController.text = newEndTimeStr;
//             formModel.endTimeDate = newEndTimeStr;

//             updateTotalPaymentAmount(formModel);
//           }
//         }
//       });
//       paymentPerPeriodController
//           .addListener(() => updateTotalPaymentAmount(formModel));
//       totalPaymentAmountController.addListener(() {
//         if (totalPaymentAmountController.text != '' &&
//             durationController.text != '') {
//           final paymentPerPeriod = PaymentCalculator(
//                   duration: util.Duration(
//                       duration: int.parse(durationController.text),
//                       unit: PaymentCycleHelper(timeUnit: "Day").paymentCycle),
//                   paymentCycle: formModel.paymentCycleType)
//               .getPaymentPerPeriod(
//                   double.parse(totalPaymentAmountController.text))
//               .toStringAsFixed(2);

//           if (paymentPerPeriod != paymentPerPeriodController.text &&
//               !paymentPerPeriodFocusNode.hasFocus) {
//             paymentPerPeriodController.text = paymentPerPeriod;
//             formModel.paymentPerPeriodText = paymentPerPeriod;
//           }
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     startTimeDateController.dispose();
//     endTimeDateController.dispose();
//     durationController.dispose();
//     totalPaymentAmountController.dispose();
//     paymentPerPeriodController.dispose();
//     totalPaymentFocusNode.dispose();
//     paymentPerPeriodFocusNode.dispose();
//   }

//   bool validateForm() {
//     return recurringFormKey.currentState!.validate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final formModel = Provider.of<FormModel>(context);

//     return Form(
//         key: recurringFormKey,
//         child: Column(
//           children: [
//             Observer(
//                 builder: (_) => TextFormField(
//                       controller: startTimeDateController,
//                       keyboardType: TextInputType.none,
//                       decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           labelText: 'Start Date',
//                           errorText: formModel.error.startTimeDate),
//                       readOnly: true,
//                       showCursor: false,
//                       onTap: () {
//                         showDatePicker(
//                                 context: context,
//                                 initialDate: startTimeDateController.text == ""
//                                     ? DateTime.now()
//                                     : DateFormat.yMd().parseLoose(
//                                         startTimeDateController.text),
//                                 firstDate: DateTime.utc(2000, 1, 1),
//                                 lastDate: DateTime.utc(2100, 1, 1))
//                             .then((value) {
//                           if (value != null) {
//                             startTimeDateController.text =
//                                 DateFormat.yMd().format(value);
//                             formModel.startTimeDate =
//                                 startTimeDateController.text;
//                           }
//                         });
//                       },
//                     )),
//             const SizedBox(
//               height: 16,
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Observer(
//                     builder: (_) => TextFormField(
//                         keyboardType: TextInputType.none,
//                         controller: endTimeDateController,
//                         decoration: InputDecoration(
//                             border: const OutlineInputBorder(),
//                             labelText: 'End Date',
//                             errorText: formModel.error.endTimeDate),
//                         showCursor: false,
//                         readOnly: true,
//                         onTap: () {
//                           showDatePicker(
//                                   context: context,
//                                   initialDate: endTimeDateController.text == ""
//                                       ? DateTime.now()
//                                       : DateFormat.yMd().parseLoose(
//                                           endTimeDateController.text),
//                                   firstDate: DateTime.utc(2000, 1, 1),
//                                   lastDate: DateTime.utc(2100, 1, 1))
//                               .then((value) {
//                             if (value != null) {
//                               endTimeDateController.text =
//                                   DateFormat.yMd().format(value);
//                               formModel.endTimeDate =
//                                   endTimeDateController.text;
//                             }
//                           });
//                         }),
//                   ),
//                 ),
//                 const SizedBox(
//                     width:
//                         8), // Optional: to add some space between text fields.
//                 Expanded(
//                   child: Observer(
//                     builder: (context) => TextFormField(
//                       controller: durationController,
//                       onChanged: (value) => formModel.durationText = value,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(
//                             RegExp(r'[1-9][0-9]*')), // 只允许输入0到9的数字
//                       ],
//                       decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           labelText: 'Duration',
//                           suffix: const Text("Day"),
//                           errorText: formModel.error.duration),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Observer(
//                 builder: (_) => DropdownButtonFormField(
//                       value: formModel.paymentCycleType,
//                       decoration: const InputDecoration(
//                         labelText: 'Payment Cycle',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: PaymentCycleType.values
//                           .map<DropdownMenuItem<PaymentCycleType>>(
//                               (PaymentCycleType value) {
//                         return DropdownMenuItem<PaymentCycleType>(
//                           value: value,
//                           child:
//                               Text(PaymentCycleHelper.enum2FormalStr[value]!),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         if (newValue == null) return;
//                         setState(() {
//                           formModel.paymentCycleType = newValue;
//                           updateTotalPaymentAmount(formModel);
//                         });
//                       },
//                     )),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                     child: Observer(
//                   builder: (_) => TextFormField(
//                     controller: paymentPerPeriodController,
//                     onChanged: (value) =>
//                         formModel.paymentPerPeriodText = value,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: <TextInputFormatter>[
//                       FilteringTextInputFormatter.allow(
//                           RegExp(r'^[1-9][0-9]*\.{0,1}\d*$')), // 只允许输入0到9的数字
//                     ],
//                     focusNode: paymentPerPeriodFocusNode,
//                     decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: 'Payment Per Period',
//                         suffix: const Text("\$"),
//                         errorText: formModel.error.paymentPerPeriod),
//                   ),
//                 )),
//                 const SizedBox(width: 8),
//                 Expanded(
//                     child: Observer(
//                   builder: (_) => TextFormField(
//                     controller: totalPaymentAmountController,
//                     onChanged: (value) =>
//                         formModel.totalPaymentAmountText = value,
//                     keyboardType: TextInputType.number,
//                     focusNode: totalPaymentFocusNode,
//                     inputFormatters: <TextInputFormatter>[
//                       FilteringTextInputFormatter.allow(
//                           RegExp(r'^[1-9][0-9]*\.{0,1}\d*$')), // 只允许输入0到9的数字
//                     ],
//                     decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: 'Total Payment Amount',
//                         suffix: const Text("\$"),
//                         errorText: formModel.error.totalPaymentAmount),
//                   ),
//                 ))
//               ],
//             )
//           ],
//         ));
//   }
// }

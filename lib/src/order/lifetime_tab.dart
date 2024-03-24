import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/component/money_input.dart';
import 'package:subscriba/src/util/currency.dart';

class LifetimeTab extends StatelessWidget {
  const LifetimeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context);
    final startDateController =
        TextEditingController(text: formModel.startTimeDate);
    final paymentPerPeriodController = TextEditingController(
        text: formModel.paymentPerPeriod?.amount.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        TextField(
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
                formModel.startTimeDate = DateFormat.yMd().format(value);
                startDateController.text = formModel.startTimeDate!;
              }
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Observer(builder: (context) {
          return MoneyInput(
            currency: formModel.paymentPerPeriod?.currency ?? Currency.CNY,
            moneyController: paymentPerPeriodController,
            onChanged: (value) {
              if (value == null) return;
              formModel.paymentPerPeriod = value;
            },
          );
        }),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';

class LifetimeTab extends StatelessWidget {
  const LifetimeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context);
    final startDateController =
        TextEditingController(text: formModel.startTimeDate);
    final paymentPerPeriodController =
        TextEditingController(text: formModel.paymentPerPeriodText);

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
        TextField(
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
              labelText: 'Cost',
              prefix: const Text("\$"),
              errorText: formModel.error.paymentPerPeriod),
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

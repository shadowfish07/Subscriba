import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriba/src/util/currency.dart';
import 'package:subscriba/src/util/currency_amount.dart';

// TODO 表单error
class MoneyInput extends StatelessWidget {
  final Function(CurrencyAmount?) onChanged;
  final TextEditingController moneyController;
  final Currency currency;

  const MoneyInput(
      {super.key,
      required this.currency,
      required this.onChanged,
      required this.moneyController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(4.0))),
      child: Row(
        children: [
          _CurrencyDropdownButton(
            currency: currency,
            onChanged: (currency) {
              final newValue =
                  CurrencyAmount.fromString(moneyController.text, currency);
              onChanged(
                  newValue.isNaN ? CurrencyAmount.zero(currency) : newValue);
            },
          ),
          Expanded(
            child: TextField(
              controller: moneyController,
              onChanged: (value) {
                final newValue = CurrencyAmount.fromString(value, currency);
                onChanged(
                    newValue.isNaN ? CurrencyAmount.zero(currency) : newValue);
              },
              style: const TextStyle(fontFamily: "Alibaba"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'^[1-9][0-9]*\.{0,1}\d*$')), // 只允许输入0到9的数字
              ],
              decoration: InputDecoration(
                prefixText: currency.symbol,
                label: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: const Text("Payment Per Period"),
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                // floatingLabelBehavior: FloatingLabelBehavior.never
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyDropdownButton extends StatelessWidget {
  final Currency currency;
  final Function(Currency?) onChanged;

  const _CurrencyDropdownButton(
      {required this.currency, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: currency,
          items: Currency.values
              .map((Currency value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      value.ISOCode,
                      style: const TextStyle(fontFamily: "Alibaba"),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subscriba/src/util/currency.dart';

class CurrencySelectView extends StatelessWidget {
  final Currency selectedCurrency;
  const CurrencySelectView({super.key, required this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Currency"),
      ),
      body: _CurrencyList(
        selectedCurrency: selectedCurrency,
      ),
    );
  }
}

/// 参考的名称、代码和符号https://www.xe.com/currencyconverter/
class _CurrencyList extends StatelessWidget {
  final Currency selectedCurrency;

  const _CurrencyList({required this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: currencyNameMap.keys.map((e) {
      final currency = Currency.fromISOCode(e.ISOCode);
      return ListTile(
        onTap: () {
          Navigator.of(context).pop(currency);
        },
        title:
            Text("${currency.name} - ${currency.ISOCode}, ${currency.symbol}"),
        trailing: selectedCurrency == currency ? const Icon(Icons.check) : null,
      );
    }).toList());
  }
}

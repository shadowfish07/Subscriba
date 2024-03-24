import 'package:flutter/material.dart';
import 'package:subscriba/src/util/currency_amount.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(
      {super.key,
      required this.money,
      this.style,
      this.suffix = "",
      this.showLineThrough = false});

  final CurrencyAmount money;
  final TextStyle? style;
  final String suffix;
  final bool showLineThrough;

  @override
  Widget build(BuildContext context) {
    final usingStyle = style ?? Theme.of(context).textTheme.titleMedium!;
    return Text(
      "${money.currency.symbol}${money.isNaN ? '-' : money.amount.toStringAsFixed(2)}$suffix",
      style: usingStyle.copyWith(
          fontFamily: "Alibaba",
          decoration: showLineThrough ? TextDecoration.lineThrough : null),
    );
  }
}

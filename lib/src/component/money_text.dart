import 'package:flutter/material.dart';

class MoneyText extends StatelessWidget {
  const MoneyText({super.key, required this.money, this.style});

  final double money;
  final String currency = "\$";
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final usingStyle = style ?? Theme.of(context).textTheme.titleMedium!;
    return Text(
      "$currency${money == -1 ? '-' : money.toStringAsFixed(2)}",
      style: usingStyle.copyWith(fontFamily: "Alibaba"),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subscriba/src/component/money_text.dart';
import 'package:subscriba/src/util/currency.dart';
import 'package:subscriba/src/util/currency_amount.dart';

enum DisplayMode { column, row }

class MoneyTextWithOriginalCurrency extends StatelessWidget {
  const MoneyTextWithOriginalCurrency(
      {super.key,
      required this.money,
      this.style,
      this.prefix = "",
      this.suffix = "",
      this.showLineThrough = false,
      this.originalCurrency,
      this.displayMode = DisplayMode.column});

  factory MoneyTextWithOriginalCurrency.row(
      {Key? key,
      required CurrencyAmount money,
      TextStyle? style,
      String prefix = "",
      String suffix = "",
      bool showLineThrough = false,
      Currency? originalCurrency,
      DisplayMode displayMode = DisplayMode.column}) {
    return MoneyTextWithOriginalCurrency(
        key: key,
        money: money,
        style: style,
        suffix: suffix,
        prefix: prefix,
        showLineThrough: showLineThrough,
        originalCurrency: originalCurrency,
        displayMode: DisplayMode.row);
  }

  final CurrencyAmount money;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final bool showLineThrough;
  final Currency? originalCurrency;
  final DisplayMode displayMode;

  @override
  Widget build(BuildContext context) {
    final displayOriginCurrency =
        originalCurrency != null && originalCurrency != money.currency;

    if (displayMode == DisplayMode.column) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          displayOriginCurrency
              ? Transform.translate(
                  offset: const Offset(0, 6),
                  child: MoneyText(
                    money: money.toCurrency(originalCurrency),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                )
              : const SizedBox.shrink(),
          MoneyText(
            money: money,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      MoneyText(
        money: money,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      displayOriginCurrency
          ? Transform.translate(
              offset: const Offset(0, -2),
              child: MoneyText(
                prefix: "/",
                money: money.toCurrency(originalCurrency),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            )
          : const SizedBox.shrink(),
    ]);
  }
}

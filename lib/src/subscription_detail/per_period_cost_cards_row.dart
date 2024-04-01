import 'package:flutter/material.dart';
import 'package:subscriba/src/component/money_text_with_original_currency.dart';
import 'package:subscriba/src/subscription_detail/display_card.dart';
import 'package:subscriba/src/util/currency.dart';
import 'package:subscriba/src/util/currency_amount.dart';

class PerPeriodCostCardsRow extends StatelessWidget {
  const PerPeriodCostCardsRow(
      {super.key,
      required this.dailyCost,
      required this.monthlyCost,
      required this.annuallyCost,
      this.originalCurrency});

  final CurrencyAmount dailyCost;
  final CurrencyAmount monthlyCost;
  final CurrencyAmount annuallyCost;
  final Currency? originalCurrency;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: DisplayCard(
                title: Text(
                  "Daily",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                body: MoneyTextWithOriginalCurrency(
                  money: dailyCost,
                  originalCurrency: originalCurrency,
                ))),
        Expanded(
            child: DisplayCard(
                title: Text(
                  "Monthly",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                body: MoneyTextWithOriginalCurrency(
                  money: monthlyCost,
                  originalCurrency: originalCurrency,
                ))),
        Expanded(
            child: DisplayCard(
          title: Text(
            "Annually",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          body: MoneyTextWithOriginalCurrency(
            money: annuallyCost,
            originalCurrency: originalCurrency,
          ),
        )),
      ],
    );
  }
}

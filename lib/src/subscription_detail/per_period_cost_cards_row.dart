import 'package:flutter/material.dart';
import 'package:subscriba/src/component/money_text.dart';
import 'package:subscriba/src/subscription_detail/display_card.dart';
import 'package:subscriba/src/util/currency_amount.dart';

class PerPeriodCostCardsRow extends StatelessWidget {
  const PerPeriodCostCardsRow(
      {super.key,
      required this.dailyCost,
      required this.monthlyCost,
      required this.annuallyCost});

  final CurrencyAmount dailyCost;
  final CurrencyAmount monthlyCost;
  final CurrencyAmount annuallyCost;

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
                body: MoneyText(
                  money: dailyCost,
                  style: Theme.of(context).textTheme.titleMedium,
                ))),
        Expanded(
            child: DisplayCard(
                title: Text(
                  "Monthly",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                body: MoneyText(
                  money: monthlyCost,
                  style: Theme.of(context).textTheme.titleMedium,
                ))),
        Expanded(
            child: DisplayCard(
          title: Text(
            "Annually",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          body: MoneyText(
            money: annuallyCost,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        )),
      ],
    );
  }
}

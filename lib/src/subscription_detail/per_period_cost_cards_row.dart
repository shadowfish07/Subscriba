import 'package:flutter/material.dart';
import 'package:subscriba/src/component/money_text.dart';
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
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    originalCurrency != null
                        ? Transform.translate(
                            offset: const Offset(0, 6),
                            child: MoneyText(
                              money: dailyCost.toCurrency(originalCurrency),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                            ),
                          )
                        : const SizedBox.shrink(),
                    MoneyText(
                      money: dailyCost,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ))),
        Expanded(
            child: DisplayCard(
                title: Text(
                  "Monthly",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    originalCurrency != null
                        ? Transform.translate(
                            offset: const Offset(0, 6),
                            child: MoneyText(
                              money: monthlyCost.toCurrency(originalCurrency),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                            ),
                          )
                        : const SizedBox.shrink(),
                    MoneyText(
                      money: monthlyCost,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ))),
        Expanded(
            child: DisplayCard(
          title: Text(
            "Annually",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              originalCurrency != null
                  ? Transform.translate(
                      offset: const Offset(0, 6),
                      child: MoneyText(
                        money: annuallyCost.toCurrency(originalCurrency),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                      ),
                    )
                  : const SizedBox.shrink(),
              MoneyText(
                money: annuallyCost,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subscriba/src/subscription_detail/display_card.dart';

class PerPeriodCostCardsRow extends StatelessWidget {
  const PerPeriodCostCardsRow(
      {super.key,
      required this.dailyCost,
      required this.monthlyCost,
      required this.annuallyCost});

  final double dailyCost;
  final double monthlyCost;
  final double annuallyCost;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: DisplayCard(
          title: Text(
            "Daily ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          body: Text(
            dailyCost == -1 ? '-' : "\$${dailyCost.toStringAsFixed(2)}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: "Alibaba"),
          ),
        )),
        Expanded(
            child: DisplayCard(
          title: Text(
            "Monthly ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          body: Text(
            monthlyCost == -1 ? '-' : "\$${monthlyCost.toStringAsFixed(2)}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: "Alibaba"),
          ),
        )),
        Expanded(
            child: DisplayCard(
          title: Text(
            "Annually ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          body: Text(
            annuallyCost == -1 ? '-' : "\$${annuallyCost.toStringAsFixed(2)}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: "Alibaba"),
          ),
        )),
      ],
    );
  }
}

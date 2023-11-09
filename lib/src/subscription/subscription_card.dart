import 'package:flutter/material.dart';
import 'package:subscriba/src/database/subscription.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subscription.title,
                  style: Theme.of(context).textTheme.titleMedium),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$800",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "\$10/day",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}

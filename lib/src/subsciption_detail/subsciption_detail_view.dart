import 'package:flutter/material.dart';
import 'package:subscriba/src/component/section.dart';
import 'package:subscriba/src/order/order_card.dart';
import 'package:subscriba/src/styles/styles.dart';

class SubscriptionDetailView extends StatelessWidget {
  const SubscriptionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SubscriptionDetailHeader(),
                Positioned(
                    left: 24,
                    right: 24,
                    top: 90,
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Subscribed for 400 days",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      "Expires in 3 days", // Or Buyout
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                    ),
                                  ],
                                ),
                                Chip(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    label: Text("90%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium))
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("11/01/2012",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant)),
                                Text("11/01/2012",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant))
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: 0.8,
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
            SizedBox(height: 54),
            Padding(
              padding: defaultCenterPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: DisplayCard(
                    title: Text(
                      "Daily ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    body: Text(
                      "\$900",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )),
                  Expanded(
                      child: DisplayCard(
                    title: Text(
                      "Monthly ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    body: Text(
                      "\$900",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )),
                  Expanded(
                      child: DisplayCard(
                    title: Text(
                      "Yearly ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    body: Text(
                      "\$900",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: defaultCenterPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 2,
                      child: DisplayCard(
                        title: Text(
                          "Totally Cost",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        body: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$900",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text("Top 1",
                                style: Theme.of(context).textTheme.labelMedium)
                          ],
                        ),
                      )),
                  Expanded(
                      child: DisplayCard(
                    title: Text(
                      "Orders",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    body: Text(
                      "9",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: defaultCenterPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: DisplayCard(
                    isClickable: true,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    title: Text(
                      "Renew",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    body: Text(
                      "On",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )),
                  Expanded(
                      flex: 2,
                      child: DisplayCard(
                        title: Text(
                          "Next Payment",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        body: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$900",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text("In 3 days",
                                style: Theme.of(context).textTheme.labelMedium)
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 8),
            Section(
                title: "Orders", child: ListView(children: const [OrderCard()]))
          ],
        ));
  }
}

class DisplayCard extends StatelessWidget {
  const DisplayCard(
      {super.key,
      required this.title,
      required this.body,
      this.color,
      this.isClickable = false,
      this.onTap});

  final Widget title;
  final Widget body;
  final Color? color;
  final bool isClickable;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var card = Card(
      color: color ?? Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              body,
            ],
          ),
        ),
      ),
    );
    if (isClickable) {
      InkWell(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

class SubscriptionDetailHeader extends StatelessWidget {
  const SubscriptionDetailHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: SizedBox(
        height: 160,
        child: Center(
          child: Column(
            children: [
              Text(
                'Flower Cloud',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              Text('Flower Cloud',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer))
            ],
          ),
        ),
      ),
    );
  }
}

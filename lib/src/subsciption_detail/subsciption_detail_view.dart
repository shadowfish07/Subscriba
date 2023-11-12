import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:subscriba/src/component/section.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/order/order_card.dart';
import 'package:subscriba/src/styles/styles.dart';
import 'package:subscriba/src/subsciption_detail/subscription_detail_model.dart';
import 'package:subscriba/src/util/date_format_helper.dart';
import 'package:subscriba/src/util/order_calculator.dart';

class SubscriptionDetailView extends StatefulWidget {
  const SubscriptionDetailView({super.key, required this.subscription});

  final Subscription subscription;

  @override
  State<SubscriptionDetailView> createState() =>
      // ignore: no_logic_in_create_state
      _SubscriptionDetailViewState(subscription: subscription);
}

class _SubscriptionDetailViewState extends State<SubscriptionDetailView> {
  late final SubscriptionDetailModel subscriptionDetailModel;

  _SubscriptionDetailViewState({required Subscription subscription}) {
    subscriptionDetailModel =
        SubscriptionDetailModel(subscription: subscription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: _SubscriptionDetailBody(
            subscriptionDetailModel: subscriptionDetailModel));
  }
}

class _SubscriptionDetailBody extends StatelessWidget {
  final SubscriptionDetailModel subscriptionDetailModel;
  const _SubscriptionDetailBody(
      {super.key, required this.subscriptionDetailModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _SubscriptionDetailHeader(
                  subscriptionDetailModel: subscriptionDetailModel,
                ),
                _SubscriptionTimeInfoCard(
                  subscriptionDetailModel: subscriptionDetailModel,
                )
              ],
            ),
            SizedBox(height: 54),
            _PerPeriodCostCardsRow(
              subscriptionDetailModel: subscriptionDetailModel,
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
            const SizedBox(height: 8),
            Section(
                title: "Orders",
                child: Column(children: [
                  OrderCard(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  OrderCard(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  )
                ]))
          ],
        ),
      ),
    );
  }
}

class _PerPeriodCostCardsRow extends StatelessWidget {
  final SubscriptionDetailModel subscriptionDetailModel;

  const _PerPeriodCostCardsRow(
      {super.key, required this.subscriptionDetailModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final orderCalculator = OrderCalculator(
            orders: subscriptionDetailModel.subscription.orders);

        return Padding(
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
                  "\$${orderCalculator.perPrize(PaymentCycleType.daily)}",
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
                  "\$${orderCalculator.perPrize(PaymentCycleType.monthly)}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: "Alibaba"),
                ),
              )),
              Expanded(
                  child: DisplayCard(
                title: Text(
                  "Yearly ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                body: Text(
                  "\$${orderCalculator.perPrize(PaymentCycleType.yearly)}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: "Alibaba"),
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}

class _SubscriptionTimeInfoCard extends StatelessWidget {
  final SubscriptionDetailModel subscriptionDetailModel;

  const _SubscriptionTimeInfoCard(
      {super.key, required this.subscriptionDetailModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final orderCalculator = OrderCalculator(
            orders: subscriptionDetailModel.subscription.orders);
        final lastContinuousSubscriptionDate =
            orderCalculator.lastContinuousSubscriptionDate;
        final latestSubscriptionDate = orderCalculator.latestSubscriptionDate;
        final subscribingDays = orderCalculator.subscribingDays;
        final expiresIn = orderCalculator.expiresIn;
        final expirationProgress = (DateTime.now().microsecondsSinceEpoch -
                lastContinuousSubscriptionDate) /
            (latestSubscriptionDate - lastContinuousSubscriptionDate);

        return Positioned(
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
                              subscribingDays == -1
                                  ? "Lifetime purchase for ${orderCalculator.daysAfterLifetimeSubscription} days"
                                  : "Subscribed for $subscribingDays days",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              expiresIn != null
                                  ? "Expires in ${expiresIn.inDays} days"
                                  : "Lifetime subscription", // Or Buyout
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
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            label: Text(
                                "${(expirationProgress * 100).toStringAsFixed(0)}%",
                                style: Theme.of(context).textTheme.labelMedium))
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            DateFormatHelper.fromMicrosecondsSinceEpoch(
                                lastContinuousSubscriptionDate),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant)),
                        Text(
                            DateFormatHelper.fromMicrosecondsSinceEpoch(
                                latestSubscriptionDate),
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
                      value: expirationProgress,
                    )
                  ],
                ),
              ),
            ));
      },
    );
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

class _SubscriptionDetailHeader extends StatelessWidget {
  const _SubscriptionDetailHeader({required this.subscriptionDetailModel});

  final SubscriptionDetailModel subscriptionDetailModel;

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
              Observer(
                builder: (_) => Text(
                  subscriptionDetailModel.subscription.title,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              Observer(
                builder: (_) => Text(
                    subscriptionDetailModel.subscription.description ?? "",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

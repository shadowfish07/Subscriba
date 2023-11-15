import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/component/section.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/order/order_card.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/styles/styles.dart';
import 'package:subscriba/src/subsciption_detail/display_card.dart';
import 'package:subscriba/src/subsciption_detail/per_period_cost_cards_row.dart';
import 'package:subscriba/src/subsciption_detail/subscription_detail_model.dart';
import 'package:subscriba/src/util/date_format_helper.dart';
import 'package:subscriba/src/util/order_calculator.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

class SubscriptionDetailView extends StatefulWidget {
  const SubscriptionDetailView({super.key, required this.subscription});

  final SubscriptionModel subscription;

  @override
  State<SubscriptionDetailView> createState() =>
      // ignore: no_logic_in_create_state
      _SubscriptionDetailViewState(subscription: subscription);
}

class _SubscriptionDetailViewState extends State<SubscriptionDetailView> {
  final SubscriptionModel subscription;

  _SubscriptionDetailViewState({required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: _SubscriptionDetailBody(subscription: subscription));
  }
}

class _SubscriptionDetailBody extends StatelessWidget {
  final SubscriptionModel subscription;
  const _SubscriptionDetailBody({super.key, required this.subscription});

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
                _SubscriptionDetailHeader(subscription: subscription),
                _SubscriptionTimeInfoCard(subscription: subscription)
              ],
            ),
            const SizedBox(height: 54),
            Observer(builder: (context) {
              final orderCalculator =
                  OrderCalculator(orders: subscription.instance.orders);
              return Padding(
                padding: defaultCenterPadding,
                child: PerPeriodCostCardsRow(
                  dailyCost: orderCalculator.perPrize(PaymentCycleType.daily),
                  monthlyCost:
                      orderCalculator.perPrize(PaymentCycleType.monthly),
                  annuallyCost:
                      orderCalculator.perPrize(PaymentCycleType.yearly),
                ),
              );
            }),
            Padding(
              padding: defaultCenterPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TotallyCostCard(subscription: subscription),
                  Expanded(
                      child: DisplayCard(
                    title: Text(
                      "Orders",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    body: Text(
                      subscription.instance.orders.length.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontFamily: "Alibaba"),
                    ),
                  )),
                ],
              ),
            ),
            _RecurringCardsRow(subscription: subscription),
            const SizedBox(height: 8),
            _OrdersSection(subscription: subscription)
          ],
        ),
      ),
    );
  }
}

class _OrdersSection extends StatelessWidget {
  const _OrdersSection({
    super.key,
    required this.subscription,
  });

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final orderCalculator =
            OrderCalculator(orders: subscription.instance.orders);

        return Section(
            title: "Orders",
            child: Column(
                children: List.from(orderCalculator.availableOrders)
                    .reversed
                    .map((e) => OrderCard(
                          order: e,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ))
                    .toList()));
      },
    );
  }
}

class _RecurringCardsRow extends StatelessWidget {
  const _RecurringCardsRow({
    super.key,
    required this.subscription,
  });
  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isLifetime = OrderCalculator(orders: subscription.instance.orders)
            .includeLifetimeOrder;

        if (isLifetime) {
          return Container();
        }
        return Padding(
          padding: defaultCenterPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RenewCard(subscription: subscription),
              _NextPaymentCard(subscription: subscription),
            ],
          ),
        );
      },
    );
  }
}

class _NextPaymentCard extends StatelessWidget {
  final SubscriptionModel subscription;

  const _NextPaymentCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final orderCalculator =
            OrderCalculator(orders: subscription.instance.orders);

        return Expanded(
            flex: 2,
            child: DisplayCard(
              title: Text(
                "Next Payment",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "\$${orderCalculator.nextPaymentTemplate!.paymentPerPeriod.toStringAsFixed(2)}",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontFamily: "Alibaba"),
                      ),
                      Text(
                          "/${PaymentCycleHelper.enum2PerUnitStr[orderCalculator.nextPaymentTemplate!.paymentCycleType]}",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ))
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}

class _RenewCard extends StatelessWidget {
  final SubscriptionModel subscription;

  const _RenewCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isRenew = subscription.instance.isRenew;
        final isLifetime = OrderCalculator(orders: subscription.instance.orders)
            .includeLifetimeOrder;

        final onTap = isLifetime
            ? null
            : () {
                subscription.toggleRenew();
              };

        return Expanded(
            child: DisplayCard(
          onTap: onTap,
          color: isRenew
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.tertiaryContainer,
          title: Text(
            "Renew",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          body: Text(
            isLifetime
                ? "Lifetime"
                : isRenew
                    ? "On"
                    : "Off",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ));
      },
    );
  }
}

class _TotallyCostCard extends StatelessWidget {
  final SubscriptionModel subscription;

  const _TotallyCostCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: DisplayCard(
          title: Text(
            "Total amount paid",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${OrderCalculator(orders: subscription.instance.orders).totalPrize}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: "Alibaba"),
              ),
              // Text("Top 1", style: Theme.of(context).textTheme.labelMedium)
            ],
          ),
        ));
  }
}

class _SubscriptionTimeInfoCard extends StatelessWidget {
  final SubscriptionModel subscription;

  const _SubscriptionTimeInfoCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final orderCalculator =
            OrderCalculator(orders: subscription.instance.orders);
        final lastContinuousSubscriptionDate =
            orderCalculator.lastContinuousSubscriptionDate;
        final latestSubscriptionDate = orderCalculator.latestSubscriptionDate;
        final subscribingDays = orderCalculator.subscribingDays;
        final expiresIn = orderCalculator.expiresIn;
        // TODO 处理订阅还没有开始的场景
        final expirationProgress = min(
            1.0,
            latestSubscriptionDate - lastContinuousSubscriptionDate != 0
                ? (DateTime.now().microsecondsSinceEpoch -
                        lastContinuousSubscriptionDate) /
                    (latestSubscriptionDate - lastContinuousSubscriptionDate)
                : 0.0);

        String getExpiresInStr() {
          if (expiresIn == null) {
            return "Lifetime subscription";
          } else if (expiresIn.inDays == 0) {
            return "Expires today";
          } else if (expiresIn.inDays < 0) {
            return "Expired for ${-expiresIn.inDays} days";
          } else {
            return "Expires in ${expiresIn.inDays} days";
          }
        }

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
                              getExpiresInStr(), // Or Buyout
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
                                isExpired(expiresIn) ? "Expired" : "Active",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: isExpired(expiresIn)
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary)))
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

  bool isExpired(Duration? expiresIn) =>
      expiresIn != null && expiresIn.inDays < 0;
}

class _SubscriptionDetailHeader extends StatelessWidget {
  const _SubscriptionDetailHeader({required this.subscription});

  final SubscriptionModel subscription;

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
                  subscription.instance.title,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              Observer(
                builder: (_) => Text(subscription.instance.description ?? "",
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

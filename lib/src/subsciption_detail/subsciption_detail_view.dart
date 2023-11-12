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
import 'package:subscriba/src/util/payment_cycle.dart';

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
            const SizedBox(height: 54),
            _PerPeriodCostCardsRow(
              subscriptionDetailModel: subscriptionDetailModel,
            ),
            Padding(
              padding: defaultCenterPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TotallyCostCard(
                    subscriptionDetailModel: subscriptionDetailModel,
                  ),
                  Expanded(
                      child: DisplayCard(
                    title: Text(
                      "Orders",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    body: Text(
                      subscriptionDetailModel.subscription.orders.length
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontFamily: "Alibaba"),
                    ),
                  )),
                ],
              ),
            ),
            _RecurringCardsRow(
                subscriptionDetailModel: subscriptionDetailModel),
            const SizedBox(height: 8),
            _OrdersSection(subscriptionDetailModel: subscriptionDetailModel)
          ],
        ),
      ),
    );
  }
}

class _OrdersSection extends StatelessWidget {
  const _OrdersSection({
    super.key,
    required this.subscriptionDetailModel,
  });

  final SubscriptionDetailModel subscriptionDetailModel;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final orderCalculator = OrderCalculator(
            orders: subscriptionDetailModel.subscription.orders);

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
    required this.subscriptionDetailModel,
  });

  final SubscriptionDetailModel subscriptionDetailModel;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isLifetime =
            OrderCalculator(orders: subscriptionDetailModel.subscription.orders)
                .includeLifetimeOrder;

        if (isLifetime) {
          return Container();
        }
        return Padding(
          padding: defaultCenterPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RenewCard(
                subscriptionDetailModel: subscriptionDetailModel,
              ),
              _NextPaymentCard(
                subscriptionDetailModel: subscriptionDetailModel,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NextPaymentCard extends StatelessWidget {
  final SubscriptionDetailModel subscriptionDetailModel;

  const _NextPaymentCard({super.key, required this.subscriptionDetailModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final orderCalculator = OrderCalculator(
            orders: subscriptionDetailModel.subscription.orders);

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
  final SubscriptionDetailModel subscriptionDetailModel;

  const _RenewCard({super.key, required this.subscriptionDetailModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isRenew = subscriptionDetailModel.subscription.isRenew;
        final isLifetime =
            OrderCalculator(orders: subscriptionDetailModel.subscription.orders)
                .includeLifetimeOrder;

        final onTap = isLifetime
            ? null
            : () {
                subscriptionDetailModel.toggleRenew();
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
  final SubscriptionDetailModel subscriptionDetailModel;

  const _TotallyCostCard({super.key, required this.subscriptionDetailModel});

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
                "\$${OrderCalculator(orders: subscriptionDetailModel.subscription.orders).totalPrize}",
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
                  "Annually ",
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
        // TODO 处理订阅还没有开始的场景
        final expirationProgress =
            latestSubscriptionDate - lastContinuousSubscriptionDate != 0
                ? (DateTime.now().microsecondsSinceEpoch -
                        lastContinuousSubscriptionDate) /
                    (latestSubscriptionDate - lastContinuousSubscriptionDate)
                : 0.0;

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
      this.onTap});

  final Widget title;
  final Widget body;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var card = Card(
      color: color ?? Theme.of(context).colorScheme.surfaceVariant,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
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
      ),
    );

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

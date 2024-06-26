import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/component/money_text.dart';
import 'package:subscriba/src/component/money_text_with_original_currency.dart';
import 'package:subscriba/src/component/section.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/order/order_add.dart';
import 'package:subscriba/src/order/order_card.dart';
import 'package:subscriba/src/settings/settings_model.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/styles/styles.dart';
import 'package:subscriba/src/subscription_detail/display_card.dart';
import 'package:subscriba/src/subscription_detail/per_period_cost_cards_row.dart';
import 'package:subscriba/src/util/currency_amount.dart';
import 'package:subscriba/src/util/date_format_helper.dart';
import 'package:subscriba/src/util/order_calculator.dart';
import 'package:subscriba/src/util/payment_frequency_helper.dart';

class SubscriptionDetailView extends StatelessWidget {
  static const routeName = '/subscription/detail';

  late final Future<Subscription?> subscription;

  Future<Subscription?> _getSubscription(int subscriptionId) async {
    return SubscriptionProvider().getSubscription(subscriptionId);
  }

  SubscriptionDetailView({super.key, required int subscriptionId}) {
    subscription = _getSubscription(subscriptionId);
  }

  @override
  Widget build(context) {
    return FutureBuilder<Subscription?>(
        future: subscription,
        builder: (context, snapshot) {
          // TODO: 找不到的兜底UI
          final settingsModel = Provider.of<SettingsModel>(context);

          if (snapshot.hasData) {
            final subscription = SubscriptionModel(
                snapshot.data!, settingsModel.defaultCurrency);
            subscription.tryRenew().then((hasRenewed) {
              if (hasRenewed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('This subscription has been auto-renewed'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            });
            return Scaffold(
                appBar: _AppBar(subscription: subscription),
                body: _SubscriptionDetailBody(subscription: subscription));
          }

          return Container();
        });
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final SubscriptionModel subscription;
  const _AppBar({required this.subscription});

  @override
  Widget build(BuildContext context) {
    Future<void> showConfirmDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final subscriptionsModel = Provider.of<SubscriptionsModel>(context);

          return AlertDialog(
            title: const Text('Delete subscription?'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('This operation is irreversible'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await SubscriptionProvider().delete(subscription.instance.id);
                  Navigator.of(context).pop();
                  subscriptionsModel.loadSubscriptions();
                },
              ),
            ],
          );
        },
      );
    }

    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions: [
        IconButton(onPressed: showConfirmDialog, icon: const Icon(Icons.delete))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SubscriptionDetailBody extends StatelessWidget {
  final SubscriptionModel subscription;
  const _SubscriptionDetailBody({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _SubscriptionDetailHeader(subscription: subscription),
                Observer(builder: (context) {
                  final orderCalculator = OrderCalculator(
                      orders: subscription.instance.orders,
                      targetCurrency: settingsModel.defaultCurrency);
                  return orderCalculator.availableOrders.isEmpty
                      ? _CreateFirstOrderCard(subscription: subscription)
                      : _SubscriptionTimeInfoCard(subscription: subscription);
                })
              ],
            ),
            // const SizedBox(height: 54),
            Observer(builder: (context) {
              final orderCalculator = OrderCalculator(
                  orders: subscription.instance.orders,
                  targetCurrency: settingsModel.defaultCurrency);

              CurrencyAmount calculateCost(PaymentFrequency cycleType) {
                return orderCalculator.isIncludeLifetimeOrder
                    ? orderCalculator.perCostByActual(cycleType)
                    : orderCalculator.perCostByProtocol(cycleType);
              }

              return Padding(
                padding: defaultCenterPadding,
                child: PerPeriodCostCardsRow(
                  dailyCost: calculateCost(PaymentFrequency.daily),
                  monthlyCost: calculateCost(PaymentFrequency.monthly),
                  annuallyCost: calculateCost(PaymentFrequency.yearly),
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
            Observer(builder: (context) {
              final orderCalculator = OrderCalculator(
                  orders: subscription.instance.orders,
                  targetCurrency: settingsModel.defaultCurrency);
              return orderCalculator.availableOrders.isEmpty
                  ? Container()
                  : _RecurringCardsRow(subscription: subscription);
            }),
            const SizedBox(height: 8),
            _OrdersSection(subscription: subscription),
          ],
        ),
      ),
    );
  }
}

class _OrdersSection extends StatelessWidget {
  const _OrdersSection({
    required this.subscription,
  });

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);

    return Observer(
      builder: (_) {
        final orderCalculator = OrderCalculator(
            orders: subscription.instance.orders,
            targetCurrency: settingsModel.defaultCurrency);

        return Section(
            title: "Orders",
            titleBottomMargin: 0,
            action: SizedBox(
              height: 28,
              width: 28,
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: const Icon(
                  Icons.add,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderAdd(
                              subscriptionId: subscription.instance.id,
                            )),
                  );
                  subscription.reload();
                },
              ),
            ),
            child: Column(
                children: List.from(orderCalculator.availableOrders)
                    .reversed
                    .map((e) => OrderCard(
                          order: e,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          onDelete: subscription.deleteOrder,
                          onEdit: (id) => subscription.reload(),
                        ))
                    .toList()));
      },
    );
  }
}

class _RecurringCardsRow extends StatelessWidget {
  const _RecurringCardsRow({
    required this.subscription,
  });
  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    return Observer(
      builder: (_) {
        final isLifetime = OrderCalculator(
                orders: subscription.instance.orders,
                targetCurrency: settingsModel.defaultCurrency)
            .isIncludeLifetimeOrder;
        final isLastOrderOneTime = OrderCalculator(
                orders: subscription.instance.orders,
                targetCurrency: settingsModel.defaultCurrency)
            .isLastOrderOneTime;

        if (isLifetime || isLastOrderOneTime) {
          return const SizedBox.shrink();
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

  const _NextPaymentCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);

    return Observer(
      builder: (_) {
        final orderCalculator = OrderCalculator(
            orders: subscription.instance.orders,
            targetCurrency: settingsModel.defaultCurrency);
        final isRenew = subscription.instance.isRenew;
        // TODO 永久订阅时的展示
        // ignore: unused_local_variable
        final isLifetime = OrderCalculator(
                orders: subscription.instance.orders,
                targetCurrency: settingsModel.defaultCurrency)
            .isIncludeLifetimeOrder;

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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: isRenew
                        ? [
                            MoneyTextWithOriginalCurrency(
                              money: orderCalculator
                                  .nextPaymentTemplate!.paymentPerPeriod
                                  .toCurrency(settingsModel.defaultCurrency),
                              style: Theme.of(context).textTheme.titleMedium,
                              originalCurrency: orderCalculator
                                  .nextPaymentTemplate!
                                  .paymentPerPeriod
                                  .currency,
                            ),
                            Transform.translate(
                              offset: const Offset(0, -2),
                              child: Text(
                                  "/${PaymentFrequencyHelper.enum2PerUnitStr[orderCalculator.nextPaymentTemplate?.paymentFrequency]}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      )),
                            )
                          ]
                        : [
                            Text("-",
                                style: Theme.of(context).textTheme.titleMedium!)
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

  const _RenewCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final settingsModel = Provider.of<SettingsModel>(context);
        final isRenew = subscription.instance.isRenew;
        final isLifetime = OrderCalculator(
                orders: subscription.instance.orders,
                targetCurrency: settingsModel.defaultCurrency)
            .isIncludeLifetimeOrder;

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

  const _TotallyCostCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);

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
              MoneyText(
                money: OrderCalculator(
                        orders: subscription.instance.orders,
                        targetCurrency: settingsModel.defaultCurrency)
                    .totalCost,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // Text("Top 1", style: Theme.of(context).textTheme.labelMedium)
            ],
          ),
        ));
  }
}

class _CreateFirstOrderCard extends StatelessWidget {
  const _CreateFirstOrderCard({required this.subscription});

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 24,
        right: 24,
        top: 90,
        child: Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              child: SizedBox(
                height: 100,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                          "No order yet? Create your first order to track costs."),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderAdd(
                                          subscriptionId:
                                              subscription.instance.id,
                                        )),
                              );
                              subscription.reload();
                            },
                            child: const Text(
                              "Create one now!",
                            )),
                      ),
                    ]),
              ),
            )));
  }
}

class _SubscriptionTimeInfoCard extends StatelessWidget {
  final SubscriptionModel subscription;

  const _SubscriptionTimeInfoCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final settingsModel = Provider.of<SettingsModel>(context);
        final orderCalculator = OrderCalculator(
            orders: subscription.instance.orders,
            targetCurrency: settingsModel.defaultCurrency);
        final lastContinuousSubscriptionDate =
            orderCalculator.lastContinuousSubscriptionDate;
        final latestSubscriptionDate = orderCalculator.latestSubscriptionDate;
        final subscribingDays = orderCalculator.subscribingDaysByProtocol;
        final expiresIn = orderCalculator.expiresIn;
        // TODO 处理订阅还没有开始的场景
        final expirationProgress = latestSubscriptionDate == -1
            ? 1.0
            : min(
                1.0,
                latestSubscriptionDate - lastContinuousSubscriptionDate != 0
                    ? (DateTime.now().microsecondsSinceEpoch -
                            lastContinuousSubscriptionDate) /
                        (latestSubscriptionDate -
                            lastContinuousSubscriptionDate)
                    : 0.0);

        String getExpiresInStr() {
          if (expiresIn == null) {
            return "";
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
                                orderCalculator.isExpired
                                    ? "Expired"
                                    : "Active",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: orderCalculator.isExpired
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
                            latestSubscriptionDate == -1
                                ? "∞"
                                : DateFormatHelper.fromMicrosecondsSinceEpoch(
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

class _SubscriptionDetailHeader extends StatelessWidget {
  const _SubscriptionDetailHeader({required this.subscription});

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                    ),
                  ),
                  Observer(
                    builder: (_) => Text(
                        subscription.instance.description ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 54)
      ],
    );
  }
}

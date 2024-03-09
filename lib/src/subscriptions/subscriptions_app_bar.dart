import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/component/money_text.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/subscriptions/subscriptions_page_model.dart';
import 'package:subscriba/src/util/payment_frequency_helper.dart';
import 'package:subscriba/src/util/subscription_calculator.dart';

class SubscriptionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SubscriptionAppBar({super.key});
  final double _prefHeight = 50.0;
  @override
  Widget build(BuildContext context) {
    final subscriptionPageModel = Provider.of<SubscriptionPageModel>(context);
    final subscriptionsModel = Provider.of<SubscriptionsModel>(context);
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
        alignment: Alignment.topLeft,
        padding:
            EdgeInsets.only(top: statusBarHeight + 16, left: 24, right: 24),
        height: _prefHeight + statusBarHeight,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Observer(
                    builder: (_) => Text(
                          'A total of ${subscriptionsModel.subscriptions.length}',
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                Observer(builder: (_) {
                  final perMainPaymentCyclePrize = SubscriptionCalculator(
                          subscriptions: subscriptionsModel.subscriptions
                              .map((e) => e.instance)
                              .toList())
                      .perPrizeByProtocol(
                          subscriptionPageModel.paymentFrequency);
                  return InkWell(
                    onTap: () {
                      subscriptionPageModel.toNextPaymentFrequency();
                    },
                    child: Row(
                      children: [
                        MoneyText(
                            money: perMainPaymentCyclePrize,
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(
                          '/${PaymentFrequencyHelper.enum2FormalStr[subscriptionPageModel.paymentFrequency]!.toLowerCase()}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        )
                      ],
                    ),
                  );
                }),
              ],
            )
          ],
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(_prefHeight);
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/component/money_text.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/subscriptions/subscriptions_page_model.dart';
import 'package:subscriba/src/util/payment_cycle.dart';
import 'package:subscriba/src/util/subscription_calculator.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});
  final double _prefHeight = 120.0;
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final subscriptionPageModel = Provider.of<SubscriptionPageModel>(context);
    final subscriptionsModel = Provider.of<SubscriptionsModel>(context);

    return Container(
        alignment: Alignment.topLeft,
        padding:
            EdgeInsets.only(top: statusBarHeight + 16, left: 24, right: 24),
        height: _prefHeight + statusBarHeight,
        child: Column(
          children: [
            Observer(builder: (context) {
              final perMainPaymentCyclePrize = SubscriptionCalculator(
                      subscriptions: subscriptionsModel.subscriptions
                          .map((e) => e.instance)
                          .toList())
                  .perPrizeByProtocol(subscriptionPageModel.paymentCycleType);
              return InkWell(
                onTap: () {
                  subscriptionPageModel.toNextPaymentCycleType();
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MoneyText(
                          money: perMainPaymentCyclePrize,
                          style: Theme.of(context).textTheme.displayMedium),
                      Text(
                        'per ${PaymentCycleHelper.enum2PerUnitStr[subscriptionPageModel.paymentCycleType]}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
              );
            })
          ],
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(_prefHeight);
}

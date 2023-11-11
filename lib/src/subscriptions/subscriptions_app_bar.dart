import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/subscriptions/subscriptions_page_model.dart';
import 'package:subscriba/src/util/order_calculator.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

class SubscriptionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SubscriptionAppBar({super.key});
  final double _prefHeight = 50.0;
  @override
  Widget build(BuildContext context) {
    final subscriptionPageModel = Provider.of<SubscriptionPageModel>(context);
    final subscriptionModel = Provider.of<SubscriptionModel>(context);
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
                          'A total of ${subscriptionModel.subscriptions.length}',
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                Observer(builder: (_) {
                  final perMainPaymentCyclePrize =
                      subscriptionModel.subscriptions.map(
                    (e) {
                      return OrderCalculator(orders: e.orders)
                          .perPrize(subscriptionPageModel.paymentCycleType);
                    },
                  ).reduce((value, element) => value + element);
                  return InkWell(
                    onTap: () {
                      subscriptionPageModel.toNextPaymentCycleType();
                    },
                    child: Row(
                      children: [
                        Text(
                          '\$${perMainPaymentCyclePrize.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '/${PaymentCycleHelper.enum2Str[subscriptionPageModel.paymentCycleType]!.toLowerCase()}',
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

import 'package:flutter/widgets.dart';
import 'package:subscriba/src/subscriptions/subscriptions_card_list.dart';

class SubscriptionsBody extends StatelessWidget {
  const SubscriptionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SubscriptionsCardList()
          // HomeSubscriptionSection(),
          // HomeSubscriptionSection(),
          // HomeSubscriptionSection()
        ],
      ),
    );
  }
}

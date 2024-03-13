import 'package:flutter/widgets.dart';
import 'package:subscriba/src/home/home_subscription_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          MostExpensiveSubscriptionSection(),
          // HomeSubscriptionSection(),
          // HomeSubscriptionSection()
        ],
      ),
    );
  }
}

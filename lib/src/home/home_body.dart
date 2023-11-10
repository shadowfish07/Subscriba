import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/home/home_section.dart';
import 'package:subscriba/src/home/home_subscription_section.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/subscription/subscription_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeSubscriptionSection(),
          HomeSubscriptionSection(),
          HomeSubscriptionSection()
        ],
      ),
    );
  }
}

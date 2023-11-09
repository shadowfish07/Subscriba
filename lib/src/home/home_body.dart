import 'package:flutter/widgets.dart';
import 'package:subscriba/src/home/home_section.dart';
import 'package:subscriba/src/subscription/subscription_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        HomeSection(
          title: "Most Expensive",
          children: [SubscriptionCard(), SubscriptionCard()],
        )
      ]),
    );
  }
}

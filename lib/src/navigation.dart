import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/home/home_view.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/subscriptions/subscriptions_view.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<StatefulWidget> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;
  late SubscriptionModel subscriptionModel;

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
      subscriptionModel.loadSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    subscriptionModel = Provider.of<SubscriptionModel>(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.toc),
            icon: Icon(Icons.toc_outlined),
            label: 'Subscriptions',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outline),
            label: 'About',
          )
        ],
        selectedIndex: currentIndex,
        onDestinationSelected: setCurrentIndex,
      ),
      body: [
        const HomeView(),
        const SubscriptionsView(),
        Container()
      ][currentIndex],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subscriba/src/add_subscription/add_subscription_view.dart';
import 'package:subscriba/src/home/home_app_bar.dart';
import 'package:subscriba/src/home/home_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    void onPressCreateSubscriptionFAB() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddSubscriptionView()),
      );
    }

    return Scaffold(
      appBar: HomeAppBar(),
      body: const HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressCreateSubscriptionFAB,
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';

class StoreRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final SubscriptionsModel subscriptionsModel;

  StoreRouteObserver({required this.subscriptionsModel});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    subscriptionsModel.loadSubscriptions();
  }
}

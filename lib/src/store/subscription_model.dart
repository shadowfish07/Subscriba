import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/subscription.dart';

part 'subscription_model.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionModel = _SubscriptionModel with _$SubscriptionModel;

abstract class _SubscriptionModel with Store {
  _SubscriptionModel() {
    loadSubscriptions();
  }

  @observable
  List<Subscription> subscriptions = [];

  @action
  loadSubscriptions() async {
    subscriptions = await SubscriptionProvider().getSubscriptions();
  }
}

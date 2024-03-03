import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/store/subscription_model.dart';

part 'subscriptions_model.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionsModel = _SubscriptionsModel with _$SubscriptionsModel;

abstract class _SubscriptionsModel with Store {
  _SubscriptionsModel() {
    loadSubscriptions();
  }

  @observable
  ObservableList<SubscriptionModel> subscriptions =
      ObservableList<SubscriptionModel>();

  @observable
  ObservableMap<int, SubscriptionModel> subscriptionsMap = ObservableMap();

  getSubscription(int id) {
    return subscriptionsMap[id];
  }

  @action
  loadSubscriptions() async {
    subscriptions = ObservableList.of(
        ((await SubscriptionProvider().getSubscriptions())
            .map((e) => SubscriptionModel(e))));
    for (var element in subscriptions) {
      subscriptionsMap[element.instance.id] = element;
    }
  }

  @action
  Future<void> tryRenewAll() async {
    for (var element in subscriptions) {
      await element.tryRenew();
    }
  }
}

import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/subscription.dart';

part 'subscription_model.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionModel = _SubscriptionModel with _$SubscriptionModel;

abstract class _SubscriptionModel with Store {
  @observable
  Subscription instance;

  _SubscriptionModel(this.instance);

  @action
  Future<void> reload() async {
    instance = (await SubscriptionProvider().getSubscription(instance.id))!;
  }

  @action
  Future<void> toggleRenew() async {
    await SubscriptionProvider().setIsRenew(instance.id, !instance.isRenew);
    reload();
  }
}

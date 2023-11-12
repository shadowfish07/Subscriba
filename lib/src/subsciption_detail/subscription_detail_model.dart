import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/subscription.dart';

part 'subscription_detail_model.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionDetailModel = _SubscriptionDetailModel
    with _$SubscriptionDetailModel;

abstract class _SubscriptionDetailModel with Store {
  @observable
  Subscription subscription;

  _SubscriptionDetailModel({required this.subscription});
}

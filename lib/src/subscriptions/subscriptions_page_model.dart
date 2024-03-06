import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/order.dart';

part 'subscriptions_page_model.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionPageModel = _SubscriptionPageModel
    with _$SubscriptionPageModel;

abstract class _SubscriptionPageModel with Store {
  @observable
  PaymentFrequency paymentFrequency = PaymentFrequency.yearly;

  @action
  void toNextPaymentFrequency() {
    if (paymentFrequency == PaymentFrequency.daily) {
      paymentFrequency = PaymentFrequency.monthly;
    } else if (paymentFrequency == PaymentFrequency.monthly) {
      paymentFrequency = PaymentFrequency.yearly;
    } else {
      paymentFrequency = PaymentFrequency.daily;
    }
  }
}

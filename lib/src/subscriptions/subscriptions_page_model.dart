import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/order.dart';

part 'subscriptions_page_model.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionPageModel = _SubscriptionPageModel
    with _$SubscriptionPageModel;

abstract class _SubscriptionPageModel with Store {
  @observable
  PaymentCycleType paymentCycleType = PaymentCycleType.yearly;

  @action
  void toNextPaymentCycleType() {
    if (paymentCycleType == PaymentCycleType.daily) {
      paymentCycleType = PaymentCycleType.monthly;
    } else if (paymentCycleType == PaymentCycleType.monthly) {
      paymentCycleType = PaymentCycleType.yearly;
    } else {
      paymentCycleType = PaymentCycleType.daily;
    }
  }
}

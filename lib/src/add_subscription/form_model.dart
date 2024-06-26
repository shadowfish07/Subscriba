import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/currency_amount.dart';
import 'package:subscriba/src/util/duration.dart';
import 'package:subscriba/src/util/payment_frequency_helper.dart';

part 'form_model.g.dart';

// ignore: library_private_types_in_public_api
class FormModel = _FormModel with _$FormModel;

abstract class _FormModel with Store {
  final FormErrorState error = FormErrorState();

  Order? order;

  @action
  fromOrder(Order order) {
    this.order = order;
    paymentType = order.paymentType;
    startTimeDate = DateFormat.yMd()
        .format(DateTime.fromMicrosecondsSinceEpoch(order.startDate));
    endTimeDate = order.endDate != null
        ? DateFormat.yMd()
            .format(DateTime.fromMicrosecondsSinceEpoch(order.endDate!))
        : null;
    paymentPerPeriod = order.paymentPerPeriod;
  }

  @observable
  PaymentType paymentType = PaymentType.recurring;

  @observable
  String? subscriptionName;

  @observable
  String? subscriptionDescription;

  @observable
  String? startTimeDate = DateFormat.yMd().format(DateTime.now());

  @computed
  int? get startTimeTimestamp {
    if (startTimeDate == null) {
      return null;
    }

    return DateFormat.yMd().parseLoose(startTimeDate!).microsecondsSinceEpoch;
  }

  @observable
  String? endTimeDate;

  @computed
  int? get endTimeTimestamp {
    if (endTimeDate == null) {
      return null;
    }

    return DateFormat.yMd().parseLoose(endTimeDate!).microsecondsSinceEpoch;
  }

  @computed
  int? get duration {
    if (startTimeTimestamp == null || endTimeTimestamp == null) {
      return null;
    }

    return getDateDuration(startTimeTimestamp!, endTimeTimestamp!);
  }

  @observable
  CurrencyAmount? paymentPerPeriod;

  @computed
  PaymentFrequency? get paymentFrequency {
    if (duration == null) return null;
    return PaymentFrequencyHelper.dayAmountToPaymentFrequency(duration!);
  }

  late List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => subscriptionName, validateSubscriptionName),
      reaction((_) => startTimeDate, validateStartTimeDate),
      reaction((_) => endTimeDate, validateEndTimeDate),
      reaction((_) => paymentPerPeriod, validatePaymentPerPeriod),
    ];
  }

  void validateAll([bool orderOnly = false]) {
    if (!orderOnly) validateSubscriptionName(subscriptionName);

    if (paymentType == PaymentType.recurring) {
      validateStartTimeDate(startTimeDate);
      validateEndTimeDate(endTimeDate);
      validatePaymentPerPeriod(paymentPerPeriod);
    } else if (paymentType == PaymentType.lifetime) {
      validateStartTimeDate(startTimeDate);
      validatePaymentPerPeriod(paymentPerPeriod);
    }
  }

  @action
  void setPaymentType(PaymentType paymentType) {
    this.paymentType = paymentType;
    if (order == null || paymentType != order!.paymentType) {
      paymentPerPeriod = CurrencyAmount.zero();
      startTimeDate = DateFormat.yMd().format(DateTime.now());
      endTimeDate = null;
    } else {
      fromOrder(order!);
    }
  }

  @action
  void validateSubscriptionName(String? subscriptionName) {
    error.subscriptionName =
        subscriptionName != null && subscriptionName.isNotEmpty
            ? null
            : "This field is required";
  }

  @action
  void validateStartTimeDate(String? startTimeDate) {
    error.startTimeDate = startTimeDate != null && startTimeDate.isNotEmpty
        ? null
        : "This field is required";
  }

  @action
  void validateEndTimeDate(String? endTimeDate) {
    error.endTimeDate = endTimeDate != null && endTimeDate.isNotEmpty
        ? null
        : "This field is required";

    if (endTimeDate != null && endTimeDate.isNotEmpty) {
      if (startTimeDate != null && startTimeDate!.isNotEmpty) {
        if (endTimeTimestamp! <= startTimeTimestamp!) {
          error.endTimeDate = "End date must be after start date";
        }
      }
    }
  }

  @action
  void validatePaymentPerPeriod(CurrencyAmount? paymentPerPeriod) {
    error.paymentPerPeriod =
        paymentPerPeriod != null ? null : "This field is required";
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}

// ignore: library_private_types_in_public_api
class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String? subscriptionName;

  @observable
  String? subscriptionDescription;

  @observable
  String? startTimeDate;

  @observable
  String? endTimeDate;

  @observable
  String? paymentPerPeriod;

  @computed
  bool get hasErrors =>
      subscriptionName != null ||
      subscriptionDescription != null ||
      startTimeDate != null ||
      endTimeDate != null ||
      paymentPerPeriod != null;
}

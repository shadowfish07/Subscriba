import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:subscriba/src/database/order.dart';

part 'form_model.g.dart';

// ignore: library_private_types_in_public_api
class FormModel = _FormModel with _$FormModel;

abstract class _FormModel with Store {
  final FormErrorState error = FormErrorState();

  @computed
  PaymentType get paymentType {
    return PaymentType.values[paymentTypeInt];
  }

  @observable
  int paymentTypeInt = 0;

  @observable
  String? subscriptionName;

  @observable
  String? subscriptionDescription;

  @observable
  String? startTimeDate;

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

  @observable
  PaymentCycleType paymentCycleType = PaymentCycleType.monthly;

  @computed
  int? get duration {
    if (durationText == null) {
      return null;
    }

    return int.parse(durationText!);
  }

  @observable
  String? durationText;

  @computed
  double get paymentPerPeriod {
    if (paymentPerPeriodText == null) {
      return 0;
    }

    return double.parse(paymentPerPeriodText!);
  }

  @observable
  String? paymentPerPeriodText;

  @computed
  double get totalPaymentAmount {
    if (totalPaymentAmountText == null) {
      return 0;
    }

    return double.parse(totalPaymentAmountText!);
  }

  @observable
  String? totalPaymentAmountText;

  late List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => subscriptionName, validateSubscriptionName),
      reaction((_) => startTimeDate, validateStartTimeDate),
      reaction((_) => endTimeDate, validateEndTimeDate),
      reaction((_) => totalPaymentAmountText, validateTotalPaymentAmount),
      reaction((_) => paymentPerPeriodText, validatePaymentPerPeriod),
      reaction((_) => durationText, validateDuration)
    ];
  }

  void validateAll() {
    validateSubscriptionName(subscriptionName);

    if (paymentType == PaymentType.recurring) {
      validateStartTimeDate(startTimeDate);
      validateEndTimeDate(endTimeDate);
      validateTotalPaymentAmount(totalPaymentAmountText);
      validatePaymentPerPeriod(paymentPerPeriodText);
      validateDuration(durationText);
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
  }

  @action
  void validateTotalPaymentAmount(String? totalPaymentAmount) {
    error.totalPaymentAmount =
        totalPaymentAmount != null && totalPaymentAmount.isNotEmpty
            ? null
            : "This field is required";
  }

  @action
  void validatePaymentPerPeriod(String? paymentPerPeriod) {
    error.paymentPerPeriod =
        paymentPerPeriod != null && paymentPerPeriod.isNotEmpty
            ? null
            : "This field is required";
  }

  @action
  void validateDuration(String? durationText) {
    error.duration = durationText != null && durationText.isNotEmpty
        ? null
        : "This field is required";
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
  String? paymentCycleType;

  @observable
  String? duration;

  @observable
  String? paymentPerPeriod;

  @observable
  String? totalPaymentAmount;

  @computed
  bool get hasErrors =>
      subscriptionName != null ||
      subscriptionDescription != null ||
      startTimeDate != null ||
      endTimeDate != null ||
      paymentCycleType != null ||
      duration != null ||
      paymentPerPeriod != null ||
      totalPaymentAmount != null;
}

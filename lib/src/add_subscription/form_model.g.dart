// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FormModel on _FormModel, Store {
  Computed<PaymentType>? _$paymentTypeComputed;

  @override
  PaymentType get paymentType =>
      (_$paymentTypeComputed ??= Computed<PaymentType>(() => super.paymentType,
              name: '_FormModel.paymentType'))
          .value;
  Computed<int?>? _$startTimeTimestampComputed;

  @override
  int? get startTimeTimestamp => (_$startTimeTimestampComputed ??=
          Computed<int?>(() => super.startTimeTimestamp,
              name: '_FormModel.startTimeTimestamp'))
      .value;
  Computed<int?>? _$endTimeTimestampComputed;

  @override
  int? get endTimeTimestamp => (_$endTimeTimestampComputed ??= Computed<int?>(
          () => super.endTimeTimestamp,
          name: '_FormModel.endTimeTimestamp'))
      .value;
  Computed<int?>? _$durationComputed;

  @override
  int? get duration => (_$durationComputed ??=
          Computed<int?>(() => super.duration, name: '_FormModel.duration'))
      .value;
  Computed<double>? _$paymentPerPeriodComputed;

  @override
  double get paymentPerPeriod => (_$paymentPerPeriodComputed ??=
          Computed<double>(() => super.paymentPerPeriod,
              name: '_FormModel.paymentPerPeriod'))
      .value;
  Computed<double>? _$totalPaymentAmountComputed;

  @override
  double get totalPaymentAmount => (_$totalPaymentAmountComputed ??=
          Computed<double>(() => super.totalPaymentAmount,
              name: '_FormModel.totalPaymentAmount'))
      .value;

  late final _$paymentTypeIntAtom =
      Atom(name: '_FormModel.paymentTypeInt', context: context);

  @override
  int get paymentTypeInt {
    _$paymentTypeIntAtom.reportRead();
    return super.paymentTypeInt;
  }

  @override
  set paymentTypeInt(int value) {
    _$paymentTypeIntAtom.reportWrite(value, super.paymentTypeInt, () {
      super.paymentTypeInt = value;
    });
  }

  late final _$subscriptionNameAtom =
      Atom(name: '_FormModel.subscriptionName', context: context);

  @override
  String? get subscriptionName {
    _$subscriptionNameAtom.reportRead();
    return super.subscriptionName;
  }

  @override
  set subscriptionName(String? value) {
    _$subscriptionNameAtom.reportWrite(value, super.subscriptionName, () {
      super.subscriptionName = value;
    });
  }

  late final _$subscriptionDescriptionAtom =
      Atom(name: '_FormModel.subscriptionDescription', context: context);

  @override
  String? get subscriptionDescription {
    _$subscriptionDescriptionAtom.reportRead();
    return super.subscriptionDescription;
  }

  @override
  set subscriptionDescription(String? value) {
    _$subscriptionDescriptionAtom
        .reportWrite(value, super.subscriptionDescription, () {
      super.subscriptionDescription = value;
    });
  }

  late final _$startTimeDateAtom =
      Atom(name: '_FormModel.startTimeDate', context: context);

  @override
  String? get startTimeDate {
    _$startTimeDateAtom.reportRead();
    return super.startTimeDate;
  }

  @override
  set startTimeDate(String? value) {
    _$startTimeDateAtom.reportWrite(value, super.startTimeDate, () {
      super.startTimeDate = value;
    });
  }

  late final _$endTimeDateAtom =
      Atom(name: '_FormModel.endTimeDate', context: context);

  @override
  String? get endTimeDate {
    _$endTimeDateAtom.reportRead();
    return super.endTimeDate;
  }

  @override
  set endTimeDate(String? value) {
    _$endTimeDateAtom.reportWrite(value, super.endTimeDate, () {
      super.endTimeDate = value;
    });
  }

  late final _$paymentCycleTypeAtom =
      Atom(name: '_FormModel.paymentCycleType', context: context);

  @override
  PaymentCycleType get paymentCycleType {
    _$paymentCycleTypeAtom.reportRead();
    return super.paymentCycleType;
  }

  @override
  set paymentCycleType(PaymentCycleType value) {
    _$paymentCycleTypeAtom.reportWrite(value, super.paymentCycleType, () {
      super.paymentCycleType = value;
    });
  }

  late final _$durationTextAtom =
      Atom(name: '_FormModel.durationText', context: context);

  @override
  String? get durationText {
    _$durationTextAtom.reportRead();
    return super.durationText;
  }

  @override
  set durationText(String? value) {
    _$durationTextAtom.reportWrite(value, super.durationText, () {
      super.durationText = value;
    });
  }

  late final _$paymentPerPeriodTextAtom =
      Atom(name: '_FormModel.paymentPerPeriodText', context: context);

  @override
  String? get paymentPerPeriodText {
    _$paymentPerPeriodTextAtom.reportRead();
    return super.paymentPerPeriodText;
  }

  @override
  set paymentPerPeriodText(String? value) {
    _$paymentPerPeriodTextAtom.reportWrite(value, super.paymentPerPeriodText,
        () {
      super.paymentPerPeriodText = value;
    });
  }

  late final _$totalPaymentAmountTextAtom =
      Atom(name: '_FormModel.totalPaymentAmountText', context: context);

  @override
  String? get totalPaymentAmountText {
    _$totalPaymentAmountTextAtom.reportRead();
    return super.totalPaymentAmountText;
  }

  @override
  set totalPaymentAmountText(String? value) {
    _$totalPaymentAmountTextAtom
        .reportWrite(value, super.totalPaymentAmountText, () {
      super.totalPaymentAmountText = value;
    });
  }

  late final _$_FormModelActionController =
      ActionController(name: '_FormModel', context: context);

  @override
  void validateSubscriptionName(String? subscriptionName) {
    final _$actionInfo = _$_FormModelActionController.startAction(
        name: '_FormModel.validateSubscriptionName');
    try {
      return super.validateSubscriptionName(subscriptionName);
    } finally {
      _$_FormModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateStartTimeDate(String? startTimeDate) {
    final _$actionInfo = _$_FormModelActionController.startAction(
        name: '_FormModel.validateStartTimeDate');
    try {
      return super.validateStartTimeDate(startTimeDate);
    } finally {
      _$_FormModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateEndTimeDate(String? endTimeDate) {
    final _$actionInfo = _$_FormModelActionController.startAction(
        name: '_FormModel.validateEndTimeDate');
    try {
      return super.validateEndTimeDate(endTimeDate);
    } finally {
      _$_FormModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateTotalPaymentAmount(String? totalPaymentAmount) {
    final _$actionInfo = _$_FormModelActionController.startAction(
        name: '_FormModel.validateTotalPaymentAmount');
    try {
      return super.validateTotalPaymentAmount(totalPaymentAmount);
    } finally {
      _$_FormModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validatePaymentPerPeriod(String? paymentPerPeriod) {
    final _$actionInfo = _$_FormModelActionController.startAction(
        name: '_FormModel.validatePaymentPerPeriod');
    try {
      return super.validatePaymentPerPeriod(paymentPerPeriod);
    } finally {
      _$_FormModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateDuration(String? durationText) {
    final _$actionInfo = _$_FormModelActionController.startAction(
        name: '_FormModel.validateDuration');
    try {
      return super.validateDuration(durationText);
    } finally {
      _$_FormModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
paymentTypeInt: ${paymentTypeInt},
subscriptionName: ${subscriptionName},
subscriptionDescription: ${subscriptionDescription},
startTimeDate: ${startTimeDate},
endTimeDate: ${endTimeDate},
paymentCycleType: ${paymentCycleType},
durationText: ${durationText},
paymentPerPeriodText: ${paymentPerPeriodText},
totalPaymentAmountText: ${totalPaymentAmountText},
paymentType: ${paymentType},
startTimeTimestamp: ${startTimeTimestamp},
endTimeTimestamp: ${endTimeTimestamp},
duration: ${duration},
paymentPerPeriod: ${paymentPerPeriod},
totalPaymentAmount: ${totalPaymentAmount}
    ''';
  }
}

mixin _$FormErrorState on _FormErrorState, Store {
  Computed<bool>? _$hasErrorsComputed;

  @override
  bool get hasErrors =>
      (_$hasErrorsComputed ??= Computed<bool>(() => super.hasErrors,
              name: '_FormErrorState.hasErrors'))
          .value;

  late final _$subscriptionNameAtom =
      Atom(name: '_FormErrorState.subscriptionName', context: context);

  @override
  String? get subscriptionName {
    _$subscriptionNameAtom.reportRead();
    return super.subscriptionName;
  }

  @override
  set subscriptionName(String? value) {
    _$subscriptionNameAtom.reportWrite(value, super.subscriptionName, () {
      super.subscriptionName = value;
    });
  }

  late final _$subscriptionDescriptionAtom =
      Atom(name: '_FormErrorState.subscriptionDescription', context: context);

  @override
  String? get subscriptionDescription {
    _$subscriptionDescriptionAtom.reportRead();
    return super.subscriptionDescription;
  }

  @override
  set subscriptionDescription(String? value) {
    _$subscriptionDescriptionAtom
        .reportWrite(value, super.subscriptionDescription, () {
      super.subscriptionDescription = value;
    });
  }

  late final _$startTimeDateAtom =
      Atom(name: '_FormErrorState.startTimeDate', context: context);

  @override
  String? get startTimeDate {
    _$startTimeDateAtom.reportRead();
    return super.startTimeDate;
  }

  @override
  set startTimeDate(String? value) {
    _$startTimeDateAtom.reportWrite(value, super.startTimeDate, () {
      super.startTimeDate = value;
    });
  }

  late final _$endTimeDateAtom =
      Atom(name: '_FormErrorState.endTimeDate', context: context);

  @override
  String? get endTimeDate {
    _$endTimeDateAtom.reportRead();
    return super.endTimeDate;
  }

  @override
  set endTimeDate(String? value) {
    _$endTimeDateAtom.reportWrite(value, super.endTimeDate, () {
      super.endTimeDate = value;
    });
  }

  late final _$paymentCycleTypeAtom =
      Atom(name: '_FormErrorState.paymentCycleType', context: context);

  @override
  String? get paymentCycleType {
    _$paymentCycleTypeAtom.reportRead();
    return super.paymentCycleType;
  }

  @override
  set paymentCycleType(String? value) {
    _$paymentCycleTypeAtom.reportWrite(value, super.paymentCycleType, () {
      super.paymentCycleType = value;
    });
  }

  late final _$durationAtom =
      Atom(name: '_FormErrorState.duration', context: context);

  @override
  String? get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  @override
  set duration(String? value) {
    _$durationAtom.reportWrite(value, super.duration, () {
      super.duration = value;
    });
  }

  late final _$paymentPerPeriodAtom =
      Atom(name: '_FormErrorState.paymentPerPeriod', context: context);

  @override
  String? get paymentPerPeriod {
    _$paymentPerPeriodAtom.reportRead();
    return super.paymentPerPeriod;
  }

  @override
  set paymentPerPeriod(String? value) {
    _$paymentPerPeriodAtom.reportWrite(value, super.paymentPerPeriod, () {
      super.paymentPerPeriod = value;
    });
  }

  late final _$totalPaymentAmountAtom =
      Atom(name: '_FormErrorState.totalPaymentAmount', context: context);

  @override
  String? get totalPaymentAmount {
    _$totalPaymentAmountAtom.reportRead();
    return super.totalPaymentAmount;
  }

  @override
  set totalPaymentAmount(String? value) {
    _$totalPaymentAmountAtom.reportWrite(value, super.totalPaymentAmount, () {
      super.totalPaymentAmount = value;
    });
  }

  @override
  String toString() {
    return '''
subscriptionName: ${subscriptionName},
subscriptionDescription: ${subscriptionDescription},
startTimeDate: ${startTimeDate},
endTimeDate: ${endTimeDate},
paymentCycleType: ${paymentCycleType},
duration: ${duration},
paymentPerPeriod: ${paymentPerPeriod},
totalPaymentAmount: ${totalPaymentAmount},
hasErrors: ${hasErrors}
    ''';
  }
}

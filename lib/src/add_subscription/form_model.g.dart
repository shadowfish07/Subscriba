// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FormModel on _FormModel, Store {
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
  Computed<PaymentFrequency?>? _$paymentFrequencyComputed;

  @override
  PaymentFrequency? get paymentFrequency => (_$paymentFrequencyComputed ??=
          Computed<PaymentFrequency?>(() => super.paymentFrequency,
              name: '_FormModel.paymentFrequency'))
      .value;

  late final _$paymentTypeAtom =
      Atom(name: '_FormModel.paymentType', context: context);

  @override
  PaymentType get paymentType {
    _$paymentTypeAtom.reportRead();
    return super.paymentType;
  }

  @override
  set paymentType(PaymentType value) {
    _$paymentTypeAtom.reportWrite(value, super.paymentType, () {
      super.paymentType = value;
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

  late final _$_FormModelActionController =
      ActionController(name: '_FormModel', context: context);

  @override
  dynamic fromOrder(Order order) {
    final _$actionInfo =
        _$_FormModelActionController.startAction(name: '_FormModel.fromOrder');
    try {
      return super.fromOrder(order);
    } finally {
      _$_FormModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPaymentType(PaymentType paymentType) {
    final _$actionInfo = _$_FormModelActionController.startAction(
        name: '_FormModel.setPaymentType');
    try {
      return super.setPaymentType(paymentType);
    } finally {
      _$_FormModelActionController.endAction(_$actionInfo);
    }
  }

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
  String toString() {
    return '''
paymentType: ${paymentType},
subscriptionName: ${subscriptionName},
subscriptionDescription: ${subscriptionDescription},
startTimeDate: ${startTimeDate},
endTimeDate: ${endTimeDate},
paymentPerPeriodText: ${paymentPerPeriodText},
startTimeTimestamp: ${startTimeTimestamp},
endTimeTimestamp: ${endTimeTimestamp},
duration: ${duration},
paymentPerPeriod: ${paymentPerPeriod},
paymentFrequency: ${paymentFrequency}
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

  @override
  String toString() {
    return '''
subscriptionName: ${subscriptionName},
subscriptionDescription: ${subscriptionDescription},
startTimeDate: ${startTimeDate},
endTimeDate: ${endTimeDate},
paymentPerPeriod: ${paymentPerPeriod},
hasErrors: ${hasErrors}
    ''';
  }
}

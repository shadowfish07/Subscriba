// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_page_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionPageModel on _SubscriptionPageModel, Store {
  late final _$paymentCycleTypeAtom =
      Atom(name: '_SubscriptionPageModel.paymentCycleType', context: context);

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

  late final _$_SubscriptionPageModelActionController =
      ActionController(name: '_SubscriptionPageModel', context: context);

  @override
  void toNextPaymentCycleType() {
    final _$actionInfo = _$_SubscriptionPageModelActionController.startAction(
        name: '_SubscriptionPageModel.toNextPaymentCycleType');
    try {
      return super.toNextPaymentCycleType();
    } finally {
      _$_SubscriptionPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
paymentCycleType: ${paymentCycleType}
    ''';
  }
}

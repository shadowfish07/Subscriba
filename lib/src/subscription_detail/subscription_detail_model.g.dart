// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_detail_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionDetailModel on _SubscriptionDetailModel, Store {
  late final _$subscriptionAtom =
      Atom(name: '_SubscriptionDetailModel.subscription', context: context);

  @override
  Subscription get subscription {
    _$subscriptionAtom.reportRead();
    return super.subscription;
  }

  @override
  set subscription(Subscription value) {
    _$subscriptionAtom.reportWrite(value, super.subscription, () {
      super.subscription = value;
    });
  }

  late final _$toggleRenewAsyncAction =
      AsyncAction('_SubscriptionDetailModel.toggleRenew', context: context);

  @override
  Future<void> toggleRenew() {
    return _$toggleRenewAsyncAction.run(() => super.toggleRenew());
  }

  @override
  String toString() {
    return '''
subscription: ${subscription}
    ''';
  }
}

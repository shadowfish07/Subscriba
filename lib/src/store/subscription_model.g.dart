// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionModel on _SubscriptionModel, Store {
  late final _$instanceAtom =
      Atom(name: '_SubscriptionModel.instance', context: context);

  @override
  Subscription get instance {
    _$instanceAtom.reportRead();
    return super.instance;
  }

  @override
  set instance(Subscription value) {
    _$instanceAtom.reportWrite(value, super.instance, () {
      super.instance = value;
    });
  }

  late final _$reloadAsyncAction =
      AsyncAction('_SubscriptionModel.reload', context: context);

  @override
  Future<void> reload() {
    return _$reloadAsyncAction.run(() => super.reload());
  }

  late final _$toggleRenewAsyncAction =
      AsyncAction('_SubscriptionModel.toggleRenew', context: context);

  @override
  Future<void> toggleRenew() {
    return _$toggleRenewAsyncAction.run(() => super.toggleRenew());
  }

  late final _$deleteOrderAsyncAction =
      AsyncAction('_SubscriptionModel.deleteOrder', context: context);

  @override
  Future<void> deleteOrder(int id) {
    return _$deleteOrderAsyncAction.run(() => super.deleteOrder(id));
  }

  @override
  String toString() {
    return '''
instance: ${instance}
    ''';
  }
}

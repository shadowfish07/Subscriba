// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionsModel on _SubscriptionsModel, Store {
  late final _$subscriptionsAtom =
      Atom(name: '_SubscriptionsModel.subscriptions', context: context);

  @override
  ObservableList<SubscriptionModel> get subscriptions {
    _$subscriptionsAtom.reportRead();
    return super.subscriptions;
  }

  @override
  set subscriptions(ObservableList<SubscriptionModel> value) {
    _$subscriptionsAtom.reportWrite(value, super.subscriptions, () {
      super.subscriptions = value;
    });
  }

  late final _$loadSubscriptionsAsyncAction =
      AsyncAction('_SubscriptionsModel.loadSubscriptions', context: context);

  @override
  Future loadSubscriptions() {
    return _$loadSubscriptionsAsyncAction.run(() => super.loadSubscriptions());
  }

  @override
  String toString() {
    return '''
subscriptions: ${subscriptions}
    ''';
  }
}

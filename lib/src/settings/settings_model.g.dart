// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsModel on _SettingsModel, Store {
  late final _$_defaultCurrencyAtom =
      Atom(name: '_SettingsModel._defaultCurrency', context: context);

  @override
  Currency get _defaultCurrency {
    _$_defaultCurrencyAtom.reportRead();
    return super._defaultCurrency;
  }

  @override
  set _defaultCurrency(Currency value) {
    _$_defaultCurrencyAtom.reportWrite(value, super._defaultCurrency, () {
      super._defaultCurrency = value;
    });
  }

  late final _$loadSettingsAsyncAction =
      AsyncAction('_SettingsModel.loadSettings', context: context);

  @override
  Future<void> loadSettings() {
    return _$loadSettingsAsyncAction.run(() => super.loadSettings());
  }

  late final _$updateDefaultCurrencyAsyncAction =
      AsyncAction('_SettingsModel.updateDefaultCurrency', context: context);

  @override
  Future<void> updateDefaultCurrency(Currency currency) {
    return _$updateDefaultCurrencyAsyncAction
        .run(() => super.updateDefaultCurrency(currency));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}

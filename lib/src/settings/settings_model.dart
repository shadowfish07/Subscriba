import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriba/src/util/currency.dart';
import 'package:subscriba/src/util/currency_amount.dart';

part 'settings_model.g.dart';

// ignore: library_private_types_in_public_api
class SettingsModel = _SettingsModel with _$SettingsModel;

abstract class _SettingsModel with Store {
  _SettingsModel() {
    sharedPreferences = SharedPreferences.getInstance();
    loadSettings();
  }

  @observable
  late Currency _defaultCurrency = Currency.fromISOCode("CNY");

  late final Future<SharedPreferences> sharedPreferences;

  Currency get defaultCurrency => _defaultCurrency;

  @action
  Future<void> loadSettings() async {
    final sharedPreferences = await this.sharedPreferences;
    _defaultCurrency = Currency.fromISOCode(
        sharedPreferences.getString("defaultCurrency") ?? "CNY");
    CurrencyAmount.defaultCurrency = _defaultCurrency;
  }

  @action
  Future<void> updateDefaultCurrency(Currency currency) async {
    _defaultCurrency = currency;
    final sharedPreferences = await this.sharedPreferences;
    await sharedPreferences.setString(
        "defaultCurrency", _defaultCurrency.ISOCode);
  }
}

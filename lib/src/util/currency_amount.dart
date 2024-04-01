import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subscriba/src/util/currency.dart';
import 'package:subscriba/src/util/exchange_rate.dart';

class CurrencyAmount {
  CurrencyAmount(
      {Currency? currency, required this.amount, this.isNaN = false}) {
    this.currency = currency ?? defaultCurrency;
  }

  static Currency defaultCurrency = Currency.CNY;

  late final Currency currency;
  final double amount;
  // 标识是否无意义
  final bool isNaN;

  factory CurrencyAmount.zero([Currency? currency]) {
    return CurrencyAmount(currency: currency ?? defaultCurrency, amount: 0);
  }

  // ignore: non_constant_identifier_names
  factory CurrencyAmount.NaN([Currency? currency]) {
    return CurrencyAmount(
        currency: currency ?? defaultCurrency, amount: 0, isNaN: true);
  }

  factory CurrencyAmount.fromString(String amount, [Currency? currency]) {
    try {
      return CurrencyAmount(
          currency: currency ?? defaultCurrency, amount: double.parse(amount));
    } catch (e) {
      return CurrencyAmount.NaN(currency);
    }
  }

  /// 不传currency默认为defaultCurrency
  CurrencyAmount toCurrency([Currency? currency]) {
    final usingCurrency = currency ?? defaultCurrency;
    return CurrencyAmount(
        currency: usingCurrency,
        amount: ExchangeRate.getRate(this.currency, usingCurrency) * amount);
  }

  CurrencyAmount operator +(CurrencyAmount other) {
    if (isNaN) {
      throw Exception('Cannot add NaN amounts');
    }

    debugPrint("sssssss ${ExchangeRate.exchangeRates}");

    debugPrint(
        "ssssssss $currency$amount + ${other.currency}${other.amount}  ${ExchangeRate.getRate(other.currency, currency)}");

    return CurrencyAmount(
        currency: currency,
        amount: amount +
            ExchangeRate.getRate(other.currency, currency) * other.amount);
  }

  CurrencyAmount operator /(num other) {
    if (isNaN) {
      throw Exception('Cannot add NaN amounts');
    }

    return CurrencyAmount(currency: currency, amount: amount / other);
  }

  CurrencyAmount operator *(num other) {
    if (isNaN) {
      throw Exception('Cannot add NaN amounts');
    }

    return CurrencyAmount(currency: currency, amount: amount * other);
  }

  CurrencyAmount ensureAmount() {
    if (amount.isNaN || amount.isInfinite) return CurrencyAmount.zero();
    return this;
  }

  @override
  String toString() {
    if (isNaN) return "${currency.symbol}NaN";
    return "${currency.symbol}$amount";
  }

  int compareTo(CurrencyAmount other) {
    if (amount <
        ExchangeRate.getRate(other.currency, currency) * other.amount) {
      return -1;
    }
    if (amount >
        ExchangeRate.getRate(other.currency, currency) * other.amount) {
      return 1;
    }
    return 0;
  }
}

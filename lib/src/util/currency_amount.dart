import 'package:subscriba/src/util/currency.dart';

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
      return CurrencyAmount.NaN();
    }
  }

  CurrencyAmount operator +(CurrencyAmount other) {
    if (other.currency != currency) {
      // TODO 后续如果要实现不同币种相加的话需要实现
      throw Exception('Cannot add amounts with different currencies');
    }

    if (isNaN) {
      throw Exception('Cannot add NaN amounts');
    }

    return CurrencyAmount(currency: currency, amount: amount + other.amount);
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
    if (other.currency != currency) {
      throw Exception(
          'Cannot compare CurrencyAmounts of different currencies.');
    }

    if (amount < other.amount) return -1;
    if (amount > other.amount) return 1;
    return 0;
  }
}

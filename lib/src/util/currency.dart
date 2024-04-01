library currency;

class UnsupportedCurrencyException implements Exception {
  final String ISOCode;

  UnsupportedCurrencyException(this.ISOCode);

  @override
  String toString() {
    return "UnsupportedCurrencyException: $ISOCode";
  }
}

const currencySymbolMap = {
  Currency.CNY: "¥",
  Currency.USD: "\$",
  Currency.EUR: "€",
  Currency.INR: "₹",
  Currency.JPY: "¥",
  Currency.TRY: "₺",
  Currency.ARS: "\$",
};

const currencyNameMap = {
  Currency.CNY: "Chinese Yuan",
  Currency.USD: "US Dollar",
  Currency.EUR: "Euro",
  Currency.INR: "Indian Rupee",
  Currency.JPY: "Japanese Yen",
  Currency.TRY: "Turkish Lira",
  Currency.ARS: "Argentine Peso",
};

enum Currency {
  CNY(ISOCode: "CNY"),
  USD(ISOCode: "USD"),
  EUR(ISOCode: "EUR"),
  INR(ISOCode: "INR"),
  JPY(ISOCode: "JPY"),
  TRY(ISOCode: "TRY"),
  ARS(ISOCode: "ARS");

  const Currency({
    required this.ISOCode,
  });

  final String ISOCode;

  get symbol => currencySymbolMap[this]!;

  get name => currencyNameMap[this]!;

  factory Currency.fromISOCode(String ISOCode) {
    return currencySymbolMap.keys.firstWhere(
        (element) => element.ISOCode == ISOCode,
        orElse: () => throw UnsupportedCurrencyException(ISOCode));
  }
}

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
};

const currencyNameMap = {
  Currency.CNY: "Chinese Yuan Renminbi",
  Currency.USD: "US Dollar",
};

enum Currency {
  CNY(ISOCode: "CNY"),
  USD(ISOCode: "USD");

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

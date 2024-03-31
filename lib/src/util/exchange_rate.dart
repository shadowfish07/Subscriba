import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriba/src/util/currency.dart';
import 'package:http/http.dart' as http;

Map<Currency, Map<Currency, double>> defaultExchangeRate = {
  Currency.CNY: {
    Currency.CNY: 1,
    Currency.USD: 0.1384567663,
  },
  Currency.USD: {
    Currency.CNY: 7.2224711501,
    Currency.USD: 1,
  }
};

class ExchangeRate {
  static Map<Currency, Map<Currency, double>> exchangeRates =
      defaultExchangeRate;

  static DateTime lastUpdated = DateTime(2024, 3, 31);

  static double getRate(Currency from, Currency to) {
    return exchangeRates[from]?[to] ?? 1;
  }

  static void _loadFromJSON(String json) {
    final exchangeRatesFromJSON = jsonDecode(json);
    for (var i in exchangeRatesFromJSON.keys) {
      for (var j in exchangeRatesFromJSON[i].keys) {
        if (exchangeRates[Currency.fromISOCode(i)] == null) {
          exchangeRates[Currency.fromISOCode(i)] = {};
        }
        exchangeRates[Currency.fromISOCode(i)]![Currency.fromISOCode(j)] =
            exchangeRatesFromJSON[i][j];
      }
    }
  }

  static Map<String, Map<String, dynamic>> _toPlainMap() {
    final Map<String, Map<String, dynamic>> result = {};
    for (var i in exchangeRates.keys) {
      result[i.ISOCode] = {};
      for (var j in exchangeRates[i]!.keys) {
        result[i.ISOCode]![j.ISOCode] = exchangeRates[i]![j];
      }
    }
    return result;
  }

  static void _write() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("exchangeRates", jsonEncode(_toPlainMap()));
    sharedPreferences.setInt(
        "exchangeRatesUpdatedTime", lastUpdated.microsecondsSinceEpoch);
  }

  static Future<void> loadExchangeRate() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final exchangeRatesString = sharedPreferences.getString("exchangeRates");
    final exchangeRatesUpdatedTime =
        sharedPreferences.getInt("exchangeRatesUpdatedTime");

    if (exchangeRatesUpdatedTime != null && exchangeRatesString != null) {
      _loadFromJSON(exchangeRatesString);
      // 本地缓存3天后自动发请求更新
      if (exchangeRatesUpdatedTime <
          DateTime.now()
              .subtract(const Duration(days: 3))
              .microsecondsSinceEpoch) {
        fetchExchangeRate();
      }
      return;
    }

    fetchExchangeRate();
  }

  // TODO 接口出错，throw出来
  static Future<bool> fetchExchangeRate() async {
    bool isUpdated = false;
    final allISOCode = currencySymbolMap.keys.map((e) => e.ISOCode);
    var response = await http
        .get(Uri.https(
            'subscricurrency-tvvlijgvvu.cn-hongkong.fcapp.run', "/action", {
          "baseCurrency": Currency.CNY.ISOCode,
          "targetCurrency": allISOCode.join(","),
          "targetCurrencyHash":
              md5.convert(utf8.encode(allISOCode.join(","))).toString()
        }))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final latestExchangeRates = data['data'];
      final latestLastUpdated =
          DateTime.parse(data['meta']!['last_updated_at']);
      isUpdated = !lastUpdated.isAtSameMomentAs(latestLastUpdated);
      lastUpdated = latestLastUpdated;
      for (var base in latestExchangeRates.keys) {
        final baseCurrency = Currency.fromISOCode(base);
        if (exchangeRates[baseCurrency] == null) {
          exchangeRates[baseCurrency] = {};
        }

        for (var target in latestExchangeRates.keys) {
          final targetCurrency = Currency.fromISOCode(target);
          exchangeRates[baseCurrency]![targetCurrency] =
              latestExchangeRates[target]['value'] /
                  latestExchangeRates[base]["value"];
        }
      }

      _write();
    }

    return isUpdated;
  }
}

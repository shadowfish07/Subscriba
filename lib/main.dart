import 'package:flutter/material.dart';
import 'package:subscriba/src/settings/settings_model.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/util/exchange_rate.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ExchangeRate.loadExchangeRate();

  runApp(MyApp(
    subscriptionsModel: SubscriptionsModel(),
    settingsModel: SettingsModel(),
  ));
}

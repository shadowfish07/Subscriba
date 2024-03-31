import 'package:flutter/material.dart';
import 'package:subscriba/src/settings/settings_model.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';

import 'src/app.dart';

void main() async {
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    subscriptionsModel: SubscriptionsModel(),
    settingsModel: SettingsModel(),
  ));
}

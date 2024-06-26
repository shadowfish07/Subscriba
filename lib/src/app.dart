import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriba/src/about/about_view.dart';
import 'package:subscriba/src/add_subscription/add_subscription_view.dart';
import 'package:subscriba/src/navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:subscriba/src/settings/settings_model.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/store_route_observer.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  final SubscriptionsModel subscriptionsModel;
  final SettingsModel settingsModel;

  const MyApp(
      {super.key,
      required this.settingsModel,
      required this.subscriptionsModel});

  @override
  Widget build(BuildContext context) {
    // SubscriptionProvider().getSubscription(1).then((value) {
    //   print(value);
    // });
    // OrderProvider().getOrder(6).then((value) {
    //   print(value);
    // });
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
      providers: [
        Provider(create: (_) => settingsModel),
        Provider(create: (_) => subscriptionsModel),
      ],
      builder: (context, child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: ThemeMode.dark, //settingsController.themeMode,

          navigatorObservers: [
            StoreRouteObserver(subscriptionsModel: subscriptionsModel)
          ],
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case AddSubscriptionView.routeName:
                    return const AddSubscriptionView();
                  case AboutView.routeName:
                    return const AboutView();
                  default:
                    return const Navigation();
                }
              },
            );
          },
        );
      },
    );
  }
}

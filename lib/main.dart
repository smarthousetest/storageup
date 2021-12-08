import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upstorage_desktop/pages/auth/auth_view.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';
import 'package:upstorage_desktop/theme.dart';
import 'generated/l10n.dart';
import 'utilities/injection.dart';
import 'utilities/state_container.dart';

void main() async {
  await configureInjection();
  runApp(new StateContainer(child: new MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: kLightTheme,
      //dark: kDarkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        title: 'Flutter Demo',
        darkTheme: dark,
        theme: light,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          S.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        // initialRoute: AuthView.route,
        initialRoute: HomePage.route,

        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AuthView.route:
              return MaterialPageRoute(
                builder: (_) => AuthView(),
                settings: settings,
              );
            case HomePage.route:
              return MaterialPageRoute(
                builder: (_) => HomePage(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}

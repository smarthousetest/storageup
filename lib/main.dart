import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upstorage_desktop/pages/auth/auth_view.dart';
import 'package:upstorage_desktop/pages/home/home.dart';
import 'package:upstorage_desktop/theme.dart';
import 'generated/l10n.dart';
import 'utilites/injection.dart';

void main() async {
  await configureInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DesktopWindow.setMinWindowSize(Size(1280, 720));
    return AdaptiveTheme(
      light: kLightTheme,
      dark: kDarkTheme,
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

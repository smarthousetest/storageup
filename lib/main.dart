import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upstorage_desktop/pages/auth/auth_view.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';
import 'package:upstorage_desktop/theme.dart';
import 'generated/l10n.dart';
import 'utilites/injection.dart';
import 'utilites/state_container.dart';

void main() async {
  await configureInjection();
  runApp(new StateContainer(child: new MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  static const platformMedia = MethodChannel('com.upstorage/media');

  // static void setLocale(BuildContext context, Locale newLocale) {
  //   _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
  //   state?.setLocale(newLocale);
  // }
}

class _MyAppState extends State<MyApp> {
  // Locale? _locale;
  // setLocale(Locale locale) {
  //   setState(() {
  //     _locale = locale;
  //   });
  // }

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
        locale: StateContainer.of(context).loacale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          S.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        // initialRoute: AuthView.route,
        initialRoute: AuthView.route,

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

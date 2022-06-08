import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:os_specification/os_specification.dart';
import 'package:upstorage_desktop/pages/auth/auth_view.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';
import 'package:upstorage_desktop/theme.dart';
import 'package:upstorage_desktop/utilites/language_locale.dart';
import 'constants.dart';
import 'generated/l10n.dart';
import 'utilites/injection.dart';
import 'utilites/state_container.dart';

void main() async {
  writeToFileDomainName();
  await configureInjection();
  //HttpOverrides.global = MyHttpOverrides();
  runApp(new StateContainer(child: new MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  static const platformMedia = MethodChannel('com.upstorage/media');

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
// static void setLocale(BuildContext context, Locale newLocale) {
//   _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
//   state?.setLocale(newLocale);
// }
}

class _MyAppState extends State<MyApp> {
  _MyAppState() : _locale = Locale(Intl.systemLocale) {
    hasCurrentLocale().then((value) {
      getLocale().then(
        (loc) => setLocale(loc),
      );
    });
  }

  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

//  Locale? _locale = StateContainer.of(context).locale;
//   setLocale(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//   }
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: kLightTheme,
      //dark: kDarkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        darkTheme: dark,
        theme: light,
        locale: StateContainer.of(context).locale,
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
          return null;
        },
      ),
    );
  }
}

void writeToFileDomainName() {
  var os = OsSpecifications.getOs();
  if (os.appDirPath.isEmpty) {
    os.appDirPath = '${Directory.current.path}${Platform.pathSeparator}';
  }
  var domainNameFile = File('${os.appDirPath}domainName');
  if (!domainNameFile.existsSync()) {
    domainNameFile.createSync(recursive: true);
  }
  domainNameFile.writeAsStringSync(domainName);
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

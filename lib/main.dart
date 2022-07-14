import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cpp_native/controllers/load/load_controller.dart';
import 'package:cpp_native/cpp_native.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storageup/pages/auth/auth_view.dart';
import 'package:storageup/pages/home/home_view.dart';
import 'package:storageup/theme.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/extensions.dart';
import 'package:storageup/utilities/language_locale.dart';
import 'package:storageup/utilities/local_server/local_server.dart' as ui;
import 'package:storageup/utilities/repositories/token_repository.dart';

import 'constants.dart';
import 'generated/l10n.dart';
import 'utilities/injection.dart';
import 'utilities/state_containers/state_container.dart';

void main() async {
  ui.Server().startServer();

  await configureInjection();
  WidgetsFlutterBinding.ensureInitialized();
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
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    hasCurrentLocale().then((value) {
      if (value) {
        getLocale().then(
          (loc) => setLocale(loc),
        );
      } else {
        findSystemLocale().then((value) {
          String systemLanguage = Intl.systemLocale;

          if (systemLanguage.contains('_')) {
            systemLanguage = systemLanguage.split('_')[0];
          }

          setLocale(Locale(systemLanguage));
        });
      }
    });
  }

  void setLocale(Locale locale) async {
    await StateContainer.of(context).changeLocale(locale);
  }

  @override
  void initState() {
    initLoadController();
    super.initState();
  }

  void initLoadController() async {
    LoadController.instance.init(
      filesController: getIt<FilesController>(instanceName: 'files_controller'),
      tokenRepository: getIt<TokenRepository>(),
      documentsDirectory: (await getApplicationSupportDirectory()).path,
      supportDirectory: (await getApplicationSupportDirectory()).path,
      backendUrl: kServerUrl.split('/').last,
      copyFileToDownloadDir: copyFileToDownloadDir,
      reportError: (
          {required CustomError error, required String message}) async {
        final S translate = getIt<S>();
        String errorText = await getErrorReasonDescription(
            translate: translate, reason: error.errorReason);
        showErrorPopUp(
            context: NavigatorService.navigatorKey.currentContext!,
            message: errorText);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: kLightTheme,
      //dark: kDarkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        darkTheme: dark,
        theme: light,
        navigatorKey: NavigatorService.navigatorKey,
        locale: StateContainer.of(context).locale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
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

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

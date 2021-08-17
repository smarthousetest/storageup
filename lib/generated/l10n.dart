// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to UpStorage`
  String get welcome_to_upsctorage {
    return Intl.message(
      'Welcome to UpStorage',
      name: 'welcome_to_upsctorage',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account yet? Hurry to join us!`
  String get still_dont_have_account {
    return Intl.message(
      'Don\'t have an account yet? Hurry to join us!',
      name: 'still_dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Register now`
  String get register {
    return Intl.message(
      'Register now',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get allready_have_an_account {
    return Intl.message(
      'Already have an account?',
      name: 'allready_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get sign_in {
    return Intl.message(
      'Login',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get sign_in_to_account {
    return Intl.message(
      'Login to your account',
      name: 'sign_in_to_account',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get remember_me {
    return Intl.message(
      'Remember me',
      name: 'remember_me',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgot_password {
    return Intl.message(
      'Forgot your password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `or continue with`
  String get or_continue_with {
    return Intl.message(
      'or continue with',
      name: 'or_continue_with',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get user_name {
    return Intl.message(
      'Username',
      name: 'user_name',
      desc: '',
      args: [],
    );
  }

  /// `I accept the terms `
  String get term_of_use_before {
    return Intl.message(
      'I accept the terms ',
      name: 'term_of_use_before',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement`
  String get term_of_use {
    return Intl.message(
      'User Agreement',
      name: 'term_of_use',
      desc: '',
      args: [],
    );
  }

  /// ` and give my consent to the processing of my personal data`
  String get term_of_use_after {
    return Intl.message(
      ' and give my consent to the processing of my personal data',
      name: 'term_of_use_after',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

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

  /// `Welcome to StorageUp`
  String get welcome_to_upsctorage {
    return Intl.message(
      'Welcome to StorageUp',
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

  /// `Password must be more than 8 characters`
  String get wrong_password {
    return Intl.message(
      'Password must be more than 8 characters',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get wrong_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'wrong_email',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password!`
  String get wrong_cred {
    return Intl.message(
      'Invalid email or password!',
      name: 'wrong_cred',
      desc: '',
      args: [],
    );
  }

  /// `Username must be more than 2 characters`
  String get wrong_username {
    return Intl.message(
      'Username must be more than 2 characters',
      name: 'wrong_username',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Try again later`
  String get something_goes_wrong {
    return Intl.message(
      'Something went wrong. Try again later',
      name: 'something_goes_wrong',
      desc: '',
      args: [],
    );
  }

  /// `User with this Email is already registered`
  String get allready_registered_email {
    return Intl.message(
      'User with this Email is already registered',
      name: 'allready_registered_email',
      desc: '',
      args: [],
    );
  }

  /// `A letter has been sent to your e-mail `
  String get restore_password_before_email {
    return Intl.message(
      'A letter has been sent to your e-mail ',
      name: 'restore_password_before_email',
      desc: '',
      args: [],
    );
  }

  /// `, to reset your password, follow the link inside the letter`
  String get resore_password_after_email {
    return Intl.message(
      ', to reset your password, follow the link inside the letter',
      name: 'resore_password_after_email',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_button {
    return Intl.message(
      'Continue',
      name: 'continue_button',
      desc: '',
      args: [],
    );
  }

  /// `Nothing came to Email?`
  String get nothing_on_email {
    return Intl.message(
      'Nothing came to Email?',
      name: 'nothing_on_email',
      desc: '',
      args: [],
    );
  }

  /// `Send email again`
  String get to_send_letter {
    return Intl.message(
      'Send email again',
      name: 'to_send_letter',
      desc: '',
      args: [],
    );
  }

  /// `Go to the main page`
  String get back_to_main {
    return Intl.message(
      'Go to the main page',
      name: 'back_to_main',
      desc: '',
      args: [],
    );
  }

  /// `Password recovery`
  String get password_recovery {
    return Intl.message(
      'Password recovery',
      name: 'password_recovery',
      desc: '',
      args: [],
    );
  }

  /// `To recover your password, enter your email address in the field`
  String get password_recovery_enter_email {
    return Intl.message(
      'To recover your password, enter your email address in the field',
      name: 'password_recovery_enter_email',
      desc: '',
      args: [],
    );
  }

  /// ` , to confirm the email address, follow the link inside the letter`
  String get email_confirming_after {
    return Intl.message(
      ' , to confirm the email address, follow the link inside the letter',
      name: 'email_confirming_after',
      desc: '',
      args: [],
    );
  }

  /// `Email confirmation`
  String get email_confirming {
    return Intl.message(
      'Email confirmation',
      name: 'email_confirming',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation of e-mail address`
  String get email_confirming_reg {
    return Intl.message(
      'Confirmation of e-mail address',
      name: 'email_confirming_reg',
      desc: '',
      args: [],
    );
  }

  /// `To complete registration, please confirm your e-mail address.`
  String get email_confirming_confirm {
    return Intl.message(
      'To complete registration, please confirm your e-mail address.',
      name: 'email_confirming_confirm',
      desc: '',
      args: [],
    );
  }

  /// `We sent a letter to the mail `
  String get email_confirming_letter {
    return Intl.message(
      'We sent a letter to the mail ',
      name: 'email_confirming_letter',
      desc: '',
      args: [],
    );
  }

  /// `To confirm, follow the link inside the letter.`
  String get email_confirming_link {
    return Intl.message(
      'To confirm, follow the link inside the letter.',
      name: 'email_confirming_link',
      desc: '',
      args: [],
    );
  }

  /// `Registration completed`
  String get register_complete {
    return Intl.message(
      'Registration completed',
      name: 'register_complete',
      desc: '',
      args: [],
    );
  }

  /// `Your e-mail address has been successfully confirmed`
  String get email_successfully {
    return Intl.message(
      'Your e-mail address has been successfully confirmed',
      name: 'email_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Go to authorization`
  String get back_to_registration {
    return Intl.message(
      'Go to authorization',
      name: 'back_to_registration',
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

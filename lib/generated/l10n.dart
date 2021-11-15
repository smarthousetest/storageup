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
  String get welcome_to_upstorage {
    return Intl.message(
      'Welcome to StorageUp',
      name: 'welcome_to_upstorage',
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
  String get already_have_an_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_an_account',
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

  /// `E-mail`
  String get email {
    return Intl.message(
      'E-mail',
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
  String get already_registered_email {
    return Intl.message(
      'User with this Email is already registered',
      name: 'already_registered_email',
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
  String get restore_password_after_email {
    return Intl.message(
      ', to reset your password, follow the link inside the letter',
      name: 'restore_password_after_email',
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
  String get back_to_authorization {
    return Intl.message(
      'Go to authorization',
      name: 'back_to_authorization',
      desc: '',
      args: [],
    );
  }

  /// `Go to authorization`
  String get go_to_authorization {
    return Intl.message(
      'Go to authorization',
      name: 'go_to_authorization',
      desc: '',
      args: [],
    );
  }

  /// `Non-existent e-mail`
  String get non_existent_email {
    return Intl.message(
      'Non-existent e-mail',
      name: 'non_existent_email',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Format`
  String get format {
    return Intl.message(
      'Format',
      name: 'format',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Renting a place`
  String get sell_space {
    return Intl.message(
      'Renting a place',
      name: 'sell_space',
      desc: '',
      args: [],
    );
  }

  /// `How it works?`
  String get how_work {
    return Intl.message(
      'How it works?',
      name: 'how_work',
      desc: '',
      args: [],
    );
  }

  /// `You can use free space on your hard`
  String get rent_space {
    return Intl.message(
      'You can use free space on your hard',
      name: 'rent_space',
      desc: '',
      args: [],
    );
  }

  /// `disk - rent space and make money on it!`
  String get make_money {
    return Intl.message(
      'disk - rent space and make money on it!',
      name: 'make_money',
      desc: '',
      args: [],
    );
  }

  /// `Select the folder on the drive where you have free space.`
  String get select_folder {
    return Intl.message(
      'Select the folder on the drive where you have free space.',
      name: 'select_folder',
      desc: '',
      args: [],
    );
  }

  /// `We use this space to store files, and you `
  String get store_files {
    return Intl.message(
      'We use this space to store files, and you ',
      name: 'store_files',
      desc: '',
      args: [],
    );
  }

  /// `can make money from it.`
  String get money {
    return Intl.message(
      'can make money from it.',
      name: 'money',
      desc: '',
      args: [],
    );
  }

  /// `Start earning in two steps:`
  String get money_two_step {
    return Intl.message(
      'Start earning in two steps:',
      name: 'money_two_step',
      desc: '',
      args: [],
    );
  }

  /// `Select a folder`
  String get folder {
    return Intl.message(
      'Select a folder',
      name: 'folder',
      desc: '',
      args: [],
    );
  }

  /// `Specify the size of the space for rent`
  String get size_of_space {
    return Intl.message(
      'Specify the size of the space for rent',
      name: 'size_of_space',
      desc: '',
      args: [],
    );
  }

  /// `As soon as we upload the first files there, money will be credited `
  String get upload_file {
    return Intl.message(
      'As soon as we upload the first files there, money will be credited ',
      name: 'upload_file',
      desc: '',
      args: [],
    );
  }

  /// `to your balance.`
  String get your_balance {
    return Intl.message(
      'to your balance.',
      name: 'your_balance',
      desc: '',
      args: [],
    );
  }

  /// `You have no storage locations yet`
  String get not_storage {
    return Intl.message(
      'You have no storage locations yet',
      name: 'not_storage',
      desc: '',
      args: [],
    );
  }

  /// `Add location`
  String get add_location {
    return Intl.message(
      'Add location',
      name: 'add_location',
      desc: '',
      args: [],
    );
  }

  /// `Choose storage location`
  String get select_storage {
    return Intl.message(
      'Choose storage location',
      name: 'select_storage',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `Set storage size`
  String get set_size {
    return Intl.message(
      'Set storage size',
      name: 'set_size',
      desc: '',
      args: [],
    );
  }

  /// `Minimum storage size: 32 GB`
  String get min_storage {
    return Intl.message(
      'Minimum storage size: 32 GB',
      name: 'min_storage',
      desc: '',
      args: [],
    );
  }

  /// `Maximum size for your drive: 180 GB`
  String get max_storage {
    return Intl.message(
      'Maximum size for your drive: 180 GB',
      name: 'max_storage',
      desc: '',
      args: [],
    );
  }

  /// `Your income`
  String get your_income {
    return Intl.message(
      'Your income',
      name: 'your_income',
      desc: '',
      args: [],
    );
  }

  /// `Our tariff assumes payment of 0.2 rubles / day for 1 GB of surrendered space`
  String get our_tariff {
    return Intl.message(
      'Our tariff assumes payment of 0.2 rubles / day for 1 GB of surrendered space',
      name: 'our_tariff',
      desc: '',
      args: [],
    );
  }

  /// `Your earnings will be`
  String get earnings {
    return Intl.message(
      'Your earnings will be',
      name: 'earnings',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `$`
  String get currency {
    return Intl.message(
      '\$',
      name: 'currency',
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

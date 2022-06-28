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

  /// `You need to log in again`
  String get notification_re_auth {
    return Intl.message(
      'You need to log in again',
      name: 'notification_re_auth',
      desc: '',
      args: [],
    );
  }

  /// `Well`
  String get well {
    return Intl.message(
      'Well',
      name: 'well',
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

  /// `Invalid password`
  String get wrong_old_password {
    return Intl.message(
      'Invalid password',
      name: 'wrong_old_password',
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

  /// `Something went wrong. Please repeat a little later.`
  String get something_goes_wrong {
    return Intl.message(
      'Something went wrong. Please repeat a little later.',
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

  /// `Minimum storage size: {count} GB`
  String min_storage(Object count) {
    return Intl.message(
      'Minimum storage size: $count GB',
      name: 'min_storage',
      desc: '',
      args: [count],
    );
  }

  /// `Maximum size for your drive: `
  String get max_storage {
    return Intl.message(
      'Maximum size for your drive: ',
      name: 'max_storage',
      desc: '',
      args: [],
    );
  }

  /// `The volume of the selected storage space does not exceed 32 GB`
  String get not_exceed {
    return Intl.message(
      'The volume of the selected storage space does not exceed 32 GB',
      name: 'not_exceed',
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

  /// `Trust level`
  String get trust_level {
    return Intl.message(
      'Trust level',
      name: 'trust_level',
      desc: '',
      args: [],
    );
  }

  /// `Latest file`
  String get latest_file {
    return Intl.message(
      'Latest file',
      name: 'latest_file',
      desc: '',
      args: [],
    );
  }

  /// `Get more space change your subscription!`
  String get more_space {
    return Intl.message(
      'Get more space change your subscription!',
      name: 'more_space',
      desc: '',
      args: [],
    );
  }

  /// `Go to`
  String get go_to {
    return Intl.message(
      'Go to',
      name: 'go_to',
      desc: '',
      args: [],
    );
  }

  /// `Not enough space?`
  String get not_space {
    return Intl.message(
      'Not enough space?',
      name: 'not_space',
      desc: '',
      args: [],
    );
  }

  /// `Subscription management`
  String get management {
    return Intl.message(
      'Subscription management',
      name: 'management',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw funds`
  String get funds {
    return Intl.message(
      'Withdraw funds',
      name: 'funds',
      desc: '',
      args: [],
    );
  }

  /// `Active subscription`
  String get active_sub {
    return Intl.message(
      'Active subscription',
      name: 'active_sub',
      desc: '',
      args: [],
    );
  }

  /// `Personal data`
  String get personal_data {
    return Intl.message(
      'Personal data',
      name: 'personal_data',
      desc: '',
      args: [],
    );
  }

  /// `Regulations`
  String get regulations {
    return Intl.message(
      'Regulations',
      name: 'regulations',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `1. General Provisions`
  String get provisions {
    return Intl.message(
      '1. General Provisions',
      name: 'provisions',
      desc: '',
      args: [],
    );
  }

  /// `Настоящая политика обработки персональных данных составлена в соответствии с требованиями Федерального закона от 27.07.2006. №152-ФЗ «О персональных данных» (далее - Закон о персональных данных) и определяет порядок обработки персональных данных и меры по обеспечению безопасности персональных данных, предпринимаемые Михайловым Иваном Сергеевичем (далее – Оператор).1.1. Оператор ставит своей важнейшей целью и условием осуществления своей деятельности соблюдение прав и свобод человека и гражданина при обработке его персональных данных, в том числе защиты прав на неприкосновенность частной жизни, личную и семейную тайну.1.2. Настоящая политика Оператора в отношении обработки персональных данных (далее – Политика) применяется ко всей информации, которую Оператор может получить о посетителях веб-сайта httpsː//thismywebsite·com.`
  String get personal {
    return Intl.message(
      'Настоящая политика обработки персональных данных составлена в соответствии с требованиями Федерального закона от 27.07.2006. №152-ФЗ «О персональных данных» (далее - Закон о персональных данных) и определяет порядок обработки персональных данных и меры по обеспечению безопасности персональных данных, предпринимаемые Михайловым Иваном Сергеевичем (далее – Оператор).1.1. Оператор ставит своей важнейшей целью и условием осуществления своей деятельности соблюдение прав и свобод человека и гражданина при обработке его персональных данных, в том числе защиты прав на неприкосновенность частной жизни, личную и семейную тайну.1.2. Настоящая политика Оператора в отношении обработки персональных данных (далее – Политика) применяется ко всей информации, которую Оператор может получить о посетителях веб-сайта httpsː//thismywebsite·com.',
      name: 'personal',
      desc: '',
      args: [],
    );
  }

  /// `Profile photo`
  String get profile_photo {
    return Intl.message(
      'Profile photo',
      name: 'profile_photo',
      desc: '',
      args: [],
    );
  }

  /// `Mail`
  String get mail {
    return Intl.message(
      'Mail',
      name: 'mail',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Common parameters`
  String get parameters {
    return Intl.message(
      'Common parameters',
      name: 'parameters',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Date format`
  String get date_format {
    return Intl.message(
      'Date format',
      name: 'date_format',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_Password {
    return Intl.message(
      'Change password',
      name: 'change_Password',
      desc: '',
      args: [],
    );
  }

  /// `The new password must be at least 8 characters long`
  String get new_password_8 {
    return Intl.message(
      'The new password must be at least 8 characters long',
      name: 'new_password_8',
      desc: '',
      args: [],
    );
  }

  /// `Passwords don't match`
  String get passwords_dont_match {
    return Intl.message(
      'Passwords don\'t match',
      name: 'passwords_dont_match',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password {
    return Intl.message(
      'New password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Repeat new password`
  String get repeat_password {
    return Intl.message(
      'Repeat new password',
      name: 'repeat_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your old password`
  String get old_password {
    return Intl.message(
      'Enter your old password',
      name: 'old_password',
      desc: '',
      args: [],
    );
  }

  /// `Account deleting`
  String get accaunt_deleting {
    return Intl.message(
      'Account deleting',
      name: 'accaunt_deleting',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to permanently delete your account`
  String get permanently_delete {
    return Intl.message(
      'Are you sure you want to permanently delete your account',
      name: 'permanently_delete',
      desc: '',
      args: [],
    );
  }

  /// `in StorageUp?`
  String get in_StorageUp {
    return Intl.message(
      'in StorageUp?',
      name: 'in_StorageUp',
      desc: '',
      args: [],
    );
  }

  /// `Your files will disappear forever and cannot be recovered.`
  String get cannot_recovered {
    return Intl.message(
      'Your files will disappear forever and cannot be recovered.',
      name: 'cannot_recovered',
      desc: '',
      args: [],
    );
  }

  /// `Before deleting an account`
  String get before_deleting {
    return Intl.message(
      'Before deleting an account',
      name: 'before_deleting',
      desc: '',
      args: [],
    );
  }

  /// `contact us`
  String get contact_us {
    return Intl.message(
      'contact us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `, maybe we can help you.`
  String get we_can_help {
    return Intl.message(
      ', maybe we can help you.',
      name: 'we_can_help',
      desc: '',
      args: [],
    );
  }

  /// `Reason for deletion`
  String get reason_deleting {
    return Intl.message(
      'Reason for deletion',
      name: 'reason_deleting',
      desc: '',
      args: [],
    );
  }

  /// `Tell us why you decided to delete your account`
  String get tell_us {
    return Intl.message(
      'Tell us why you decided to delete your account',
      name: 'tell_us',
      desc: '',
      args: [],
    );
  }

  /// `Delete permanently`
  String get delete_permanently {
    return Intl.message(
      'Delete permanently',
      name: 'delete_permanently',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get enter_password {
    return Intl.message(
      'Enter password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Folder`
  String get folder_dir {
    return Intl.message(
      'Folder',
      name: 'folder_dir',
      desc: '',
      args: [],
    );
  }

  /// `Recent`
  String get recent {
    return Intl.message(
      'Recent',
      name: 'recent',
      desc: '',
      args: [],
    );
  }

  /// `Properties`
  String get properties {
    return Intl.message(
      'Properties',
      name: 'properties',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get created {
    return Intl.message(
      'Created',
      name: 'created',
      desc: '',
      args: [],
    );
  }

  /// `Changed`
  String get changed {
    return Intl.message(
      'Changed',
      name: 'changed',
      desc: '',
      args: [],
    );
  }

  /// `Viewed`
  String get viewed {
    return Intl.message(
      'Viewed',
      name: 'viewed',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Create folder`
  String get create_folder {
    return Intl.message(
      'Create folder',
      name: 'create_folder',
      desc: '',
      args: [],
    );
  }

  /// `Create a folder`
  String get create_a_folder {
    return Intl.message(
      'Create a folder',
      name: 'create_a_folder',
      desc: '',
      args: [],
    );
  }

  /// `Create album`
  String get create_album {
    return Intl.message(
      'Create album',
      name: 'create_album',
      desc: '',
      args: [],
    );
  }

  /// `New album`
  String get new_album {
    return Intl.message(
      'New album',
      name: 'new_album',
      desc: '',
      args: [],
    );
  }

  /// `New folder`
  String get new_folder {
    return Intl.message(
      'New folder',
      name: 'new_folder',
      desc: '',
      args: [],
    );
  }

  /// `Upload to files`
  String get upload_to_files {
    return Intl.message(
      'Upload to files',
      name: 'upload_to_files',
      desc: '',
      args: [],
    );
  }

  /// `Upload to media`
  String get upload_to_media {
    return Intl.message(
      'Upload to media',
      name: 'upload_to_media',
      desc: '',
      args: [],
    );
  }

  /// `You are renting`
  String get you_rent {
    return Intl.message(
      'You are renting',
      name: 'you_rent',
      desc: '',
      args: [],
    );
  }

  /// `You turn in`
  String get you_turn_in {
    return Intl.message(
      'You turn in',
      name: 'you_turn_in',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Rent`
  String get rent {
    return Intl.message(
      'Rent',
      name: 'rent',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to get out?`
  String get get_out {
    return Intl.message(
      'Are you sure you want to get out?',
      name: 'get_out',
      desc: '',
      args: [],
    );
  }

  /// `Upload file`
  String get upload_files {
    return Intl.message(
      'Upload file',
      name: 'upload_files',
      desc: '',
      args: [],
    );
  }

  /// `Upload folder`
  String get upload_folder {
    return Intl.message(
      'Upload folder',
      name: 'upload_folder',
      desc: '',
      args: [],
    );
  }

  /// `Upload media`
  String get upload_media {
    return Intl.message(
      'Upload media',
      name: 'upload_media',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message(
      'Photos',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Media`
  String get media {
    return Intl.message(
      'Media',
      name: 'media',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `All files`
  String get all_files {
    return Intl.message(
      'All files',
      name: 'all_files',
      desc: '',
      args: [],
    );
  }

  /// `{count} files`
  String count_of_files(Object count) {
    return Intl.message(
      '$count files',
      name: 'count_of_files',
      desc: '',
      args: [count],
    );
  }

  /// `Change photo`
  String get change_photo {
    return Intl.message(
      'Change photo',
      name: 'change_photo',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Deleting`
  String get deleting {
    return Intl.message(
      'Deleting',
      name: 'deleting',
      desc: '',
      args: [],
    );
  }

  /// `Advantageous offer - switch to an annual subscription`
  String get offer {
    return Intl.message(
      'Advantageous offer - switch to an annual subscription',
      name: 'offer',
      desc: '',
      args: [],
    );
  }

  /// `Payment:`
  String get payment {
    return Intl.message(
      'Payment:',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message(
      'Canceled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Card:`
  String get card {
    return Intl.message(
      'Card:',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Other subscriptions`
  String get other_sub {
    return Intl.message(
      'Other subscriptions',
      name: 'other_sub',
      desc: '',
      args: [],
    );
  }

  /// `Free subcription`
  String get free_sub {
    return Intl.message(
      'Free subcription',
      name: 'free_sub',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribe`
  String get unsubscribe {
    return Intl.message(
      'Unsubscribe',
      name: 'unsubscribe',
      desc: '',
      args: [],
    );
  }

  /// `Delete file`
  String get delete_file {
    return Intl.message(
      'Delete file',
      name: 'delete_file',
      desc: '',
      args: [],
    );
  }

  /// `{count_of_gb} GB for {cost} $/mounth`
  String current_subscription_title(Object count_of_gb, Object cost) {
    return Intl.message(
      '$count_of_gb GB for $cost \$/mounth',
      name: 'current_subscription_title',
      desc: '',
      args: [count_of_gb, cost],
    );
  }

  /// `Next payment on {date} will be {cost} $`
  String current_subscription_payment(DateTime date, Object cost) {
    final DateFormat dateDateFormat = DateFormat.yMd(Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    return Intl.message(
      'Next payment on $dateString will be $cost \$',
      name: 'current_subscription_payment',
      desc: '',
      args: [dateString, cost],
    );
  }

  /// `Your {count_of_gb} GB subscription will be valid until {date} after which time `
  String cancel_sub(DateTime date, Object count_of_gb) {
    final DateFormat dateDateFormat = DateFormat.yMd(Intl.getCurrentLocale());
    final String dateString = dateDateFormat.format(date);

    return Intl.message(
      'Your $count_of_gb GB subscription will be valid until $dateString after which time ',
      name: 'cancel_sub',
      desc: '',
      args: [dateString, count_of_gb],
    );
  }

  /// `objects from the files and media sections, filling {count_of_gb}`
  String filled_gb(Object count_of_gb) {
    return Intl.message(
      'objects from the files and media sections, filling $count_of_gb',
      name: 'filled_gb',
      desc: '',
      args: [count_of_gb],
    );
  }

  /// `spaces will be deleted without the possibility of recovery.`
  String get will_be_deleted {
    return Intl.message(
      'spaces will be deleted without the possibility of recovery.',
      name: 'will_be_deleted',
      desc: '',
      args: [],
    );
  }

  /// `You will be able to use the app free of charge from now on.`
  String get further_use {
    return Intl.message(
      'You will be able to use the app free of charge from now on.',
      name: 'further_use',
      desc: '',
      args: [],
    );
  }

  /// `{count} $/mounth`
  String subscription_pay_mounth(Object count) {
    return Intl.message(
      '$count \$/mounth',
      name: 'subscription_pay_mounth',
      desc: '',
      args: [count],
    );
  }

  /// `Folder`
  String get foldr {
    return Intl.message(
      'Folder',
      name: 'foldr',
      desc: '',
      args: [],
    );
  }

  /// `{count} B`
  String b(Object count) {
    return Intl.message(
      '$count B',
      name: 'b',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Kb`
  String kb(Object count) {
    return Intl.message(
      '$count Kb',
      name: 'kb',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Mb`
  String mb(Object count) {
    return Intl.message(
      '$count Mb',
      name: 'mb',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Gb`
  String gb(Object count) {
    return Intl.message(
      '$count Gb',
      name: 'gb',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Tb`
  String tb(Object count) {
    return Intl.message(
      '$count Tb',
      name: 'tb',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Pb`
  String pb(Object count) {
    return Intl.message(
      '$count Pb',
      name: 'pb',
      desc: '',
      args: [count],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Move`
  String get move {
    return Intl.message(
      'Move',
      name: 'move',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `By type`
  String get by_type {
    return Intl.message(
      'By type',
      name: 'by_type',
      desc: '',
      args: [],
    );
  }

  /// `By name`
  String get by_name {
    return Intl.message(
      'By name',
      name: 'by_name',
      desc: '',
      args: [],
    );
  }

  /// `By date addded`
  String get by_date_added {
    return Intl.message(
      'By date addded',
      name: 'by_date_added',
      desc: '',
      args: [],
    );
  }

  /// `By date viewed`
  String get by_date_viewed {
    return Intl.message(
      'By date viewed',
      name: 'by_date_viewed',
      desc: '',
      args: [],
    );
  }

  /// `By size`
  String get by_size {
    return Intl.message(
      'By size',
      name: 'by_size',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Finance`
  String get finance {
    return Intl.message(
      'Finance',
      name: 'finance',
      desc: '',
      args: [],
    );
  }

  /// `File sorting`
  String get file_sorting {
    return Intl.message(
      'File sorting',
      name: 'file_sorting',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get documents {
    return Intl.message(
      'Documents',
      name: 'documents',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete?`
  String get realy_delete {
    return Intl.message(
      'Do you really want to delete?',
      name: 'realy_delete',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get russian {
    return Intl.message(
      'Russian',
      name: 'russian',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Removing a photo`
  String get delete_pic {
    return Intl.message(
      'Removing a photo',
      name: 'delete_pic',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete your profile picture?`
  String get really_delete_pic {
    return Intl.message(
      'Do you really want to delete your profile picture?',
      name: 'really_delete_pic',
      desc: '',
      args: [],
    );
  }

  /// `Deleting a storage location`
  String get realy_delete_keeper {
    return Intl.message(
      'Deleting a storage location',
      name: 'realy_delete_keeper',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the storage location?`
  String get delete_keeper_text1 {
    return Intl.message(
      'Are you sure you want to delete the storage location?',
      name: 'delete_keeper_text1',
      desc: '',
      args: [],
    );
  }

  /// `This action is irreversible.`
  String get delete_keeper_text2 {
    return Intl.message(
      'This action is irreversible.',
      name: 'delete_keeper_text2',
      desc: '',
      args: [],
    );
  }

  /// `We will need to clean up the space on your computer, please do not exit the application.`
  String get delete_keeper_text3 {
    return Intl.message(
      'We will need to clean up the space on your computer, please do not exit the application.',
      name: 'delete_keeper_text3',
      desc: '',
      args: [],
    );
  }

  /// `Install update`
  String get install_update {
    return Intl.message(
      'Install update',
      name: 'install_update',
      desc: '',
      args: [],
    );
  }

  /// `Name of storage location`
  String get name_storage {
    return Intl.message(
      'Name of storage location',
      name: 'name_storage',
      desc: '',
      args: [],
    );
  }

  /// `Path`
  String get path {
    return Intl.message(
      'Path',
      name: 'path',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your e-mail!`
  String get confirm_email {
    return Intl.message(
      'Confirm your e-mail!',
      name: 'confirm_email',
      desc: '',
      args: [],
    );
  }

  /// `You can't log in, confirm your e-mail address.`
  String get you_cant_enter {
    return Intl.message(
      'You can\'t log in, confirm your e-mail address.',
      name: 'you_cant_enter',
      desc: '',
      args: [],
    );
  }

  /// `We have sent an email to`
  String get we_send {
    return Intl.message(
      'We have sent an email to',
      name: 'we_send',
      desc: '',
      args: [],
    );
  }

  /// `To confirm, click on the link inside the email.`
  String get for_confirm {
    return Intl.message(
      'To confirm, click on the link inside the email.',
      name: 'for_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `The file name must not contain the following characters: \/:*?"<>|`
  String get wrong_symbvols {
    return Intl.message(
      'The file name must not contain the following characters: \\/:*?"<>|',
      name: 'wrong_symbvols',
      desc: '',
      args: [],
    );
  }

  /// `File winth that name already exists.`
  String get wrong_filename {
    return Intl.message(
      'File winth that name already exists.',
      name: 'wrong_filename',
      desc: '',
      args: [],
    );
  }

  /// `This computer`
  String get this_computer {
    return Intl.message(
      'This computer',
      name: 'this_computer',
      desc: '',
      args: [],
    );
  }

  /// `Other copmuters`
  String get other_computers {
    return Intl.message(
      'Other copmuters',
      name: 'other_computers',
      desc: '',
      args: [],
    );
  }

  /// `Level of trust`
  String get level_of_confidence {
    return Intl.message(
      'Level of trust',
      name: 'level_of_confidence',
      desc: '',
      args: [],
    );
  }

  /// `Space`
  String get space {
    return Intl.message(
      'Space',
      name: 'space',
      desc: '',
      args: [],
    );
  }

  /// `Downloating`
  String get downloating {
    return Intl.message(
      'Downloating',
      name: 'downloating',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Inactive`
  String get inactive {
    return Intl.message(
      'Inactive',
      name: 'inactive',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Reboot`
  String get reboot {
    return Intl.message(
      'Reboot',
      name: 'reboot',
      desc: '',
      args: [],
    );
  }

  /// `Earning pay day`
  String get ern_pay_day {
    return Intl.message(
      'Earning pay day',
      name: 'ern_pay_day',
      desc: '',
      args: [],
    );
  }

  /// `You need to restart keeper`
  String get restart_keeper {
    return Intl.message(
      'You need to restart keeper',
      name: 'restart_keeper',
      desc: '',
      args: [],
    );
  }

  /// `Learn more`
  String get learn_more {
    return Intl.message(
      'Learn more',
      name: 'learn_more',
      desc: '',
      args: [],
    );
  }

  /// `On`
  String get on {
    return Intl.message(
      'On',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get off {
    return Intl.message(
      'Off',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `It is possible to restart keeper locally`
  String get reboot_keeper {
    return Intl.message(
      'It is possible to restart keeper locally',
      name: 'reboot_keeper',
      desc: '',
      args: [],
    );
  }

  /// ` of 100%`
  String get of_percent {
    return Intl.message(
      ' of 100%',
      name: 'of_percent',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `The connection to the server cannot be established.\nCheck your internet connection and try again.`
  String get no_internet {
    return Intl.message(
      'The connection to the server cannot be established.\nCheck your internet connection and try again.',
      name: 'no_internet',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Resend letter will be available in`
  String get resend_letter_available {
    return Intl.message(
      'Resend letter will be available in',
      name: 'resend_letter_available',
      desc: '',
      args: [],
    );
  }

  /// `{count} seconds`
  String seconds(Object count) {
    return Intl.message(
      '$count seconds',
      name: 'seconds',
      desc: '',
      args: [count],
    );
  }

  /// `Never`
  String get never {
    return Intl.message(
      'Never',
      name: 'never',
      desc: '',
      args: [],
    );
  }

  /// `Where to move it to?`
  String get where_move {
    return Intl.message(
      'Where to move it to?',
      name: 'where_move',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get down {
    return Intl.message(
      'Download',
      name: 'down',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `The name must contain more than 2 characters`
  String get name_contain {
    return Intl.message(
      'The name must contain more than 2 characters',
      name: 'name_contain',
      desc: '',
      args: [],
    );
  }

  /// `A technical error has occurred in the StorageUp application. Please repeat a little later.`
  String get technical_error {
    return Intl.message(
      'A technical error has occurred in the StorageUp application. Please repeat a little later.',
      name: 'technical_error',
      desc: '',
      args: [],
    );
  }

  /// `A server-side error occurred in the Storage Up application. Please repeat a little later.`
  String get internal_server_error {
    return Intl.message(
      'A server-side error occurred in the Storage Up application. Please repeat a little later.',
      name: 'internal_server_error',
      desc: '',
      args: [],
    );
  }

  /// `There are no keepers in the StorageUp application at the moment. Please repeat a little later.`
  String get no_available_keepers {
    return Intl.message(
      'There are no keepers in the StorageUp application at the moment. Please repeat a little later.',
      name: 'no_available_keepers',
      desc: '',
      args: [],
    );
  }

  /// `There is no necessary proxy on the StorageUp server. Please repeat a little later.`
  String get no_available_proxy {
    return Intl.message(
      'There is no necessary proxy on the StorageUp server. Please repeat a little later.',
      name: 'no_available_proxy',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred in the StorageUp application when working with a file. The file cannot be downloaded.`
  String get null_file {
    return Intl.message(
      'An error occurred in the StorageUp application when working with a file. The file cannot be downloaded.',
      name: 'null_file',
      desc: '',
      args: [],
    );
  }

  /// `Not enought space`
  String get not_enought_space {
    return Intl.message(
      'Not enought space',
      name: 'not_enought_space',
      desc: '',
      args: [],
    );
  }

  /// `The current subscription does not allow you to download the selected files. You have filled all your free space. To continue downloading, switch to a subscription with a large number of gigabytes or free up the current space.`
  String get no_available_space {
    return Intl.message(
      'The current subscription does not allow you to download the selected files. You have filled all your free space. To continue downloading, switch to a subscription with a large number of gigabytes or free up the current space.',
      name: 'no_available_space',
      desc: '',
      args: [],
    );
  }

  /// `{count,plural, =0{0 files} =1{{count} file} other{{count} files}}`
  String many_files(num count) {
    return Intl.plural(
      count,
      zero: '0 files',
      one: '$count file',
      other: '$count files',
      name: 'many_files',
      desc: '',
      args: [count],
    );
  }

  /// `Add files`
  String get add_files {
    return Intl.message(
      'Add files',
      name: 'add_files',
      desc: '',
      args: [],
    );
  }

  /// `Change place`
  String get change_place {
    return Intl.message(
      'Change place',
      name: 'change_place',
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

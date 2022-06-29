import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'language_code';

const String ENGLISH = 'en';
const String RUSSIAN = 'ru';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "ru";
  return _locale(languageCode);
}

Future<bool> hasCurrentLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.containsKey(LAGUAGE_CODE);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case RUSSIAN:
      return Locale(RUSSIAN, 'RU');
    default:
      return Locale(RUSSIAN, 'RU');
  }
}

import 'package:flutter/material.dart';

final kDarkTheme = ThemeData.dark().copyWith();

final kLightTheme = ThemeData.light().copyWith(
  accentColor: Color(0xFF64AEEA),
  primaryColor: Color(0xFFFFFFFF),
  disabledColor: Color(0xFF7D7D7D),
  hintColor: Color(0xFFEDEDED),
  errorColor: Color(0xFFFF786F),
  textTheme: ThemeData.light().textTheme.copyWith(
        headline1: TextStyle(
          color: Color(0xFFC4C4C4),
        ),
      ),
);

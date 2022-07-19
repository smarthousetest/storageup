import 'package:flutter/material.dart';

final kDarkTheme = ThemeData.dark().copyWith();

final kLightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Color(0xff64AEEA),
  indicatorColor: Color(0xFFFF847E),
  primaryColor: Color(0xFFFFFFFF),
  disabledColor: Color(0xFF7D7D7D),
  selectedRowColor: Color(0xFFCEF3E6),
  hintColor: Color(0xFFEDEDED),
  errorColor: Color(0xFFFF786F),
  shadowColor: Color(0xffC4C4C4),
  focusColor: Color(0xff5F5F5F),
  dividerColor: Color(0xffF1F8FE),
  cardColor: Color(0xffF7F9FB),
  splashColor: Color(0xff70BBF6),
  canvasColor: Color(0xffE4E7ED),
  hoverColor: Color(0xff767676),
  highlightColor: Color(0xffF1F8FE),
  buttonTheme: ThemeData.light().buttonTheme.copyWith(
          colorScheme: ColorScheme.light(
        primary: Color(0xFFEBF5FF),
      )),
  toggleButtonsTheme: ThemeData.light().toggleButtonsTheme.copyWith(
        color: Color(0xffE0E0E0),
      ),
  bottomAppBarColor: Color(0xff5A5A5A),
  colorScheme: ThemeData.light().colorScheme.copyWith(
        onPrimary: Color(0xFFE0E0E0),
        onSurface: Color(0xFF70BBF6),
        onBackground: Color(0xFF9C9C9C),
        onSecondary: Color(0xFFF1F8FE),
      ),
  textTheme: ThemeData.light().textTheme.copyWith(
        headline1: TextStyle(
          color: Color(0xFFC4C4C4),
        ),
        subtitle1: TextStyle(
          color: Color(0xff9C9C9C),
        ),
        headline2: TextStyle(
          color: Color(0xFF5A5A5A),
        ),
      ),
);

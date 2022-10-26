import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social/shared/components/constants.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  textTheme: const TextTheme(
    subtitle1: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black45),
    bodyText1: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black45),
    bodyText2: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black45),
    overline: TextStyle(
        fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45),
    headline1: TextStyle(
        fontSize: 96, fontWeight: FontWeight.bold, color: Colors.black45),
    headline2: TextStyle(
        fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black45),
    headline3: TextStyle(
        fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black45),
    headline4: TextStyle(
        fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black45),
    headline5: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45),
    headline6: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black45),
    caption: TextStyle(fontSize: 12, color: Colors.black45),
    button: TextStyle(fontSize: 14, color: Colors.black45),
  ),
  cardColor: lightThemePrimaryColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: lightThemePrimaryColor,
    selectedItemColor: Colors.deepOrange,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),
  primarySwatch: Colors.deepOrange,
  scaffoldBackgroundColor: lightThemePrimaryColor,
  appBarTheme: const AppBarTheme(
    actionsIconTheme: IconThemeData(
      color: Colors.black,
    ),
    foregroundColor: lightThemePrimaryColor,
    toolbarTextStyle: TextStyle(color: Colors.black),
    backgroundColor: lightThemePrimaryColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: lightThemePrimaryColor,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  textTheme: const TextTheme(
    subtitle1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    bodyText1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    bodyText2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    overline: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    headline1: TextStyle(
        fontSize: 96,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    headline2: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    headline3: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    headline4: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    headline5: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    headline6: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: lightThemePrimaryColor),
    caption: TextStyle(fontSize: 12, color: lightThemePrimaryColor),
    button: TextStyle(fontSize: 14, color: lightThemePrimaryColor),
  ),
  cardColor: darkThemeSecondColor,
  scaffoldBackgroundColor: darkThemeSecondColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: darkThemeSecondColor,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.deepOrange,
    unselectedItemColor: Colors.grey,
  ),
  primarySwatch: Colors.deepOrange,
  appBarTheme: AppBarTheme(
    elevation: 0,
    foregroundColor: darkThemeSecondColor,
    toolbarTextStyle: TextStyle(
      color: darkThemeSecondColor,
    ),
    titleTextStyle: const TextStyle(
      color: lightThemePrimaryColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: lightThemePrimaryColor),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: darkThemeSecondColor,
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: darkThemeSecondColor,
  ),
);

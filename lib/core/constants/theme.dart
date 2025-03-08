import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 110, 121, 238),
          onPrimary: Colors.black,
          secondary: Colors.black,
          onSecondary: Color(0xffFAFAFA),
          error: Colors.red,
          onError: Colors.black,
          background: Color.fromARGB(255, 236, 229, 249),
          onBackground: Colors.black,
          surface: Color.fromARGB(255, 255, 255, 255),
          onSurface: Colors.black),
      textTheme: Typography.blackCupertino);

  static ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xffA9B0F9),
          onPrimary: Colors.black,
          secondary: Colors.black,
          onSecondary: Color(0xffFAFAFA),
          error: Colors.red,
          onError: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Color(0xff9A80E9),
          onSurface: Colors.black),
      textTheme: Typography.blackCupertino);
}

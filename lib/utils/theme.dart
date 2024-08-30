import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark(useMaterial3: true).copyWith(
    brightness: Brightness.dark,
    primaryColor: textColor,
    scaffoldBackgroundColor: const Color(0xff122243),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    hintColor: const Color.fromRGBO(255, 255, 255, 0.40),
    // textTheme: Typography().white.apply(fontFamily: 'Poppins'),
    textTheme: lightTextTheme,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff122243),
      secondary: Color(0xff071128),
    ),
  );

  static final lightThemeMode = ThemeData.light(useMaterial3: true).copyWith(
    brightness: Brightness.light,
    primaryColor: textColor,
    scaffoldBackgroundColor: mobileBackgroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: mobileBackgroundColor),
    hintColor: secondaryColor,
    // textTheme: Typography().white.apply(fontFamily: 'poppins'),
    textTheme: lightTextTheme,
    colorScheme: const ColorScheme.light(
      primary: Color(0xff122243),
      secondary: Color(0xff071128),
    ),
  );
}

const TextTheme lightTextTheme = TextTheme(
  ///Mobile/Header1
  displayLarge: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: textColor,
  ),

  ///Mobile/Header2
  displayMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: textColor,
  ),

  ///Mobile/Header3
  displaySmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: textColor,
  ),

  ///Mobile/Header4
  headlineMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: textColor,
  ),

  ///Mobile/Text Body
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textColor,
  ),

  ///Mobile/Additional
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: textColor,
  ),

  ///Mobile/Additional2
  titleMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: textColor,
  ),

  ///Desktop/Additional
  titleSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: textColor,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: textColor,
  ),
);

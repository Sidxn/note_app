import 'package:flutter/material.dart';
import 'colorScheme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Urbanist',
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textGray),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
    cardColor: AppColors.lightCard,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      hintStyle: const TextStyle(color: AppColors.textGray),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
colorScheme: ColorScheme.light(
  primary: AppColors.primaryBlue,
  secondary: AppColors.lightBlue,
  background: AppColors.background,
  surface: AppColors.lightCard,
  onPrimary: Colors.white,
  onSurface: AppColors.textDark,
),

  );

  static ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  fontFamily: 'Urbanist',
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardColor: Colors.grey[900],
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    hintStyle: const TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryBlue,
    background: Colors.black,
    surface: Colors.grey,
    onSurface: Colors.white,
  ),
);

}


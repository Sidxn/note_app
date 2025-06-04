import 'package:flutter/material.dart';
import 'colorScheme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Urbanist',
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.lightText),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.lightSubText),
      labelMedium: TextStyle(fontSize: 12, color: AppColors.accent),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.lightText),
      iconTheme: IconThemeData(color: AppColors.lightText),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      onPrimary: Colors.white,
      background: AppColors.lightBackground,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightText,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightCard,
      hintStyle: const TextStyle(color: AppColors.lightSubText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.accentLight),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.accent),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Urbanist',
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkSubText),
      labelMedium: TextStyle(fontSize: 12, color: AppColors.accentLight),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
      iconTheme: IconThemeData(color: AppColors.darkText),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentDark,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentDark,
      onPrimary: Colors.white,
      background: AppColors.darkBackground,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkText,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      hintStyle: const TextStyle(color: AppColors.darkSubText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.accentDark),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.accentDark),
  );

  }
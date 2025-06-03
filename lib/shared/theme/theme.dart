import 'package:flutter/material.dart';

class AppColors {
  // Light Theme
  static const Color lightBackground = Color(0xFFFDFDFD);
  static const Color lightCard = Color(0xFFF3F4F6);
  static const Color lightText = Color(0xFF1D1D1F);
  static const Color lightSubText = Color(0xFF4A4A4A);

  // Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFF1F1F1);
  static const Color darkSubText = Color(0xFF9E9E9E);

  static const Color accentBlue = Color(0xFF3A86FF);
  static const Color fabBlue = Color(0xFF3F51F0);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: 'Urbanist',
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.lightText),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.lightSubText),
    ),
    cardColor: AppColors.lightCard,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightText),
      iconTheme: IconThemeData(color: AppColors.lightText),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.fabBlue,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightCard,
      hintStyle: const TextStyle(color: AppColors.lightSubText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Urbanist',
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkText),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkSubText),
    ),
    cardColor: AppColors.darkCard,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.darkText),
      iconTheme: IconThemeData(color: AppColors.darkText),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.fabBlue,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      hintStyle: const TextStyle(color: AppColors.darkSubText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

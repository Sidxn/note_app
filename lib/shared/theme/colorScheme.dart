import 'package:flutter/material.dart';

class AppColors {
  // Shared Accent Colors
  static const Color primary = Color(0xFF1565C0); // Strong blue
  static const Color secondary = Color(0xFF90CAF9); // Soft blue
  static const Color accent = Color(0xFF64B5F6); // Light accent blue
  static const Color primaryBlue = Color(0xFF3B82F6); // Vibrant shared blue

  static const Color white = Colors.white;
  static const Color shadow = Color(0x1A000000);    
  static const Color divider = Color(0xFFBDBDBD);

  // ------------------------------
  // LIGHT THEME COLORS
  // ------------------------------
  static const Color lightBackground = Color(0xFFF5F9FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0D1B2A);
  static const Color lightTextSecondary = Color(0xFF5C6B7A);
  static const Color lightFab = Color(0xFF1976D2);
 static const Color textDark = Color(0xFF1C1C1E); // Dark text
  static const Color textGray = Color(0xFF8E8E93); // Gray/secondary text
  // Additional light fields for ThemeData support
  static const Color lightOnPrimary = white;
  static const Color lightOnBackground = lightTextPrimary;

  // ------------------------------
  // DARK THEME COLORS (updated)
  // ------------------------------
  static const Color darkBackground = Color(0xFF1A1D26); // Scaffold background
  static const Color darkSurface = Color(0xFF2A2D3E);    // Card/fields
  static const Color darkCard = Color(0xFF242731);
  static const Color darkTextPrimary = Color(0xFFF5F9FF);
  static const Color darkTextSecondary = Color(0xFF8A8F9E);
  static const Color darkFab = Color(0xFF4F7DF9);
  static const Color darkAccent = Color(0xFF4F7DF9);
  static const Color darkBorder = Color(0xFF373A45);

  // Additional dark fields for ThemeData support
  static const Color darkOnPrimary = Colors.white;
  static const Color darkOnBackground = darkTextPrimary;
  

  static const Color black = Color(0xFF000000);

  static const Color scaffoldLight = Color(0xFFFDFDFD);
  static const Color scaffoldDark = Color(0xFF121212);

  static const Color surfaceDark = Color(0xFF1E1E1E);


}

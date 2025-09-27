import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimary = Color(0xFF6C5CE7);
  static const Color lightSecondary = Color(0xFF74B9FF);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF2D3436);
  static const Color lightOnSurface = Color(0xFF636E72);
  static const Color lightAccent = Color(0xFFE17055);
  static const Color lightError = Color(0xFFE74C3C);

  static const Color darkPrimary = Color(0xFF6C5CE7);
  static const Color darkSecondary = Color(0xFF74B9FF);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkOnBackground = Color(0xFFE8E8E8);
  static const Color darkOnSurface = Color(0xFFB0B0B0);
  static const Color darkAccent = Color(0xFFE17055);
  static const Color darkError = Color(0xFFE74C3C);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightSecondary,
      background: lightBackground,
      surface: lightSurface,
      onPrimary: lightOnPrimary,
      onSecondary: lightOnSecondary,
      onBackground: lightOnBackground,
      onSurface: lightOnSurface,
      error: lightError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightOnBackground,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: lightOnPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: lightOnBackground,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: lightOnBackground,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: lightOnBackground,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: lightOnSurface,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkSecondary,
      background: darkBackground,
      surface: darkSurface,
      onPrimary: darkOnPrimary,
      onSecondary: darkOnSecondary,
      onBackground: darkOnBackground,
      onSurface: darkOnSurface,
      error: darkError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkOnBackground,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkOnPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: darkOnBackground,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: darkOnBackground,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: darkOnBackground,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: darkOnSurface,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  static Color lightPrimaryAlpha(double alpha) =>
      lightPrimary.withValues(alpha: alpha);
  static Color lightSecondaryAlpha(double alpha) =>
      lightSecondary.withValues(alpha: alpha);
  static Color lightAccentAlpha(double alpha) =>
      lightAccent.withValues(alpha: alpha);

  static Color darkPrimaryAlpha(double alpha) =>
      darkPrimary.withValues(alpha: alpha);
  static Color darkSecondaryAlpha(double alpha) =>
      darkSecondary.withValues(alpha: alpha);
  static Color darkAccentAlpha(double alpha) =>
      darkAccent.withValues(alpha: alpha);
}

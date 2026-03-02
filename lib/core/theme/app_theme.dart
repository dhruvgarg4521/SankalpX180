import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AppTheme - Dark cosmic theme for SankalpX180
class AppTheme {
  // Primary Colors
  static const Color primaryBackground = Color(0xFF0B0F2A);
  static const Color secondaryBackground = Color(0xFF1A1F3A);
  static const Color accentBlue = Color(0xFF2D8CFF);
  static const Color successGreen = Color(0xFF1ED760);
  static const Color dangerRed = Color(0xFFB00020);
  static const Color gold = Color(0xFFFFC857);
  static const Color warningYellow = Color(0xFFFFB800);
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF0B0F2A);
  static const Color gradientEnd = Color(0xFF1A1F3A);
  static const Color gradientPurple = Color(0xFF6B46C1);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  
  // Surface Colors
  static const Color surfaceDark = Color(0xFF1E2338);
  static const Color surfaceLight = Color(0xFF2A2F4A);
  static const Color dividerColor = Color(0xFF2A2F4A);
  
  // Status Colors
  static const Color notTempted = successGreen;
  static const Color tempted = warningYellow;
  static const Color relapsed = dangerRed;
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentBlue,
      scaffoldBackgroundColor: primaryBackground,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: successGreen,
        error: dangerRed,
        surface: surfaceDark,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onError: textPrimary,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textSecondary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textTertiary,
          fontSize: 12,
        ),
      ),
    );
  }
  
  /// Get gradient background decoration
  static BoxDecoration get gradientBackground => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [gradientStart, gradientEnd, gradientPurple],
      stops: const [0.0, 0.5, 1.0],
    ),
  );
  
  /// Get glowing button decoration
  static BoxDecoration get glowingButton => BoxDecoration(
    color: accentBlue,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: accentBlue.withOpacity(0.4),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ],
  );
  
  /// Get danger button decoration
  static BoxDecoration get dangerButton => BoxDecoration(
    color: dangerRed,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: dangerRed.withOpacity(0.4),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ],
  );
  
  /// Get success button decoration
  static BoxDecoration get successButton => BoxDecoration(
    color: successGreen,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: successGreen.withOpacity(0.4),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ],
  );
}

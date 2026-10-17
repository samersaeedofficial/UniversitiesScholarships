import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF2563EB); // Vibrant Royal Indigo
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color primaryText = Color(0xFF0F172A); // Slate 900
  static const Color secondaryText = Color(0xFF64748B); // Slate 500
  static const Color mutedText = Color(0xFF94A3B8); // Slate 400

  // Backgrounds & Surfaces (Light mode)
  static const Color scaffoldBg = Color(0xFFF8FAFC); // Slate 50
  static const Color cardBg = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1F5F9); // Slate 100
  static const Color borderColor = Color(0xFFE2E8F0); // Slate 200
  static const Color dividerColor = Color(0xFFF1F5F9);

  // Status & Functional Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successBg = Color(0xFFECFDF5); // Emerald 50
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningBg = Color(0xFFFFFBEB); // Amber 50
  static const Color danger = Color(0xFFEF4444); // Red 500
  static const Color dangerBg = Color(0xFFFEF2F2); // Red 50
  static const Color info = Color(0xFF0EA5E9); // Sky 500
  static const Color infoBg = Color(0xFFF0F9FF); // Sky 50
  static const Color purple = Color(0xFF8B5CF6); // Violet 500
  static const Color purpleBg = Color(0xFFF5F3FF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryLight,
        onPrimaryContainer: primaryDark,
        secondary: Color(0xFF475569),
        surface: cardBg,
        onSurface: primaryText,
        error: danger,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primaryText,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: const TextStyle(color: mutedText, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: danger, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 24,
      ),
    );
  }

  // Soft shadows for clean modern cards
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.04),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 3),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.02),
          blurRadius: 2,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ];
}

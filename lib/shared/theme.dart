import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Softer Teal Blue (Professional & Clean)
  static const Color primary = Color(0xFF0891B2); // cyan-600
  static const Color primaryDark = Color(0xFF0E7490); // cyan-700
  static const Color primaryLight = Color(0xFF06B6D4); // cyan-500

  static const Color secondary = Color(0xFF0284C7); // sky-600
  static const Color secondaryDark = Color(0xFF0369A1); // sky-700
  static const Color secondaryLight = Color(0xFF0EA5E9); // sky-500

  // Accent Colors (Subtle)
  static const Color accent = Color(0xFF3B82F6); // blue-500
  static const Color accentGreen = Color(0xFF10B981); // emerald-500
  static const Color accentOrange = Color(0xFFF97316); // orange-500
  static const Color accentPurple = Color(0xFF8B5CF6); // violet-500
  static const Color accentRed = Color(0xFFEF4444); // red-500

  // Neutral Colors
  static const Color textDark = Color(0xFF1F2937); // gray-800
  static const Color textMedium = Color(0xFF6B7280); // gray-500
  static const Color textLight = Color(0xFF9CA3AF); // gray-400
  static const Color background = Color(0xFFF8FAFC); // slate-50
  static const Color cardBackground = Colors.white;
  static const Color border = Color(0xFFE5E7EB); // gray-200
  static const Color borderLight = Color(0xFFF3F4F6); // gray-100

  // Gradients - Softer transitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0891B2), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF0F9FF), Color(0xFFFFFFFF)], // sky-50 to white
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Border Radius - More rounded for modern look
  static BorderRadius borderRadiusSmall = BorderRadius.circular(12);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(16);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(20);
  static BorderRadius borderRadiusXLarge = BorderRadius.circular(24);
  static BorderRadius borderRadiusXXLarge = BorderRadius.circular(28);

  // Box Shadows - Minimalist & subtle
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> shadowCard = [
    BoxShadow(
      color: primary.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  // Text Styles
  static const TextStyle headingXLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textDark,
    letterSpacing: 0.5,
  );

  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle bodyLarge = TextStyle(fontSize: 16, color: textMedium);

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textMedium,
  );

  static const TextStyle bodySmall = TextStyle(fontSize: 12, color: textLight);

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // App Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.cyan,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusXLarge),
        color: cardBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusLarge),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const ivory = Color(0xFFF7F3EB);
  static const forest = Color(0xFF1F4D3A);
  static const sage = Color(0xFF6B8F71);
  static const navy = Color(0xFF243447);
  static const sand = Color(0xFFE6DCC8);
  static const gold = Color(0xFFB08D57);
  static const terracotta = Color(0xFFC0754C);
  static const text = Color(0xFF2A2F2C);
  static const muted = Color(0xFF5F6B64);
  static const surface = Color(0xFFFFFCF7);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        primary: AppColors.forest,
        secondary: AppColors.sage,
        tertiary: AppColors.gold,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),
    );

    final textTheme = GoogleFonts.ibmPlexSansKrTextTheme(
      base.textTheme,
    ).apply(bodyColor: AppColors.text, displayColor: AppColors.navy);

    return base.copyWith(
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.25,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.3,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.55),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.55),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.forest,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.ibmPlexSansKr(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.forest,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: AppColors.sage.withValues(alpha: 0.35),
        backgroundColor: AppColors.sand.withValues(alpha: 0.55),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFD9D0C0)),
    );
  }
}

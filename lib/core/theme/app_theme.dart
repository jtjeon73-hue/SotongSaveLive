import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const navy = Color(0xFF0B1F33);
  static const navySoft = Color(0xFF16324F);
  static const teal = Color(0xFF0F8B7B);
  static const tealLight = Color(0xFF1BB89F);
  static const amber = Color(0xFFC98500);
  static const danger = Color(0xFFC62828);
  static const background = Color(0xFFF4F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF142033);
  static const muted = Color(0xFF5B6B7C);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        primary: AppColors.navy,
        secondary: AppColors.teal,
        error: AppColors.danger,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    final textTheme = GoogleFonts.ibmPlexSansKrTextTheme(
      base.textTheme,
    ).apply(bodyColor: AppColors.text, displayColor: AppColors.text);

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navy,
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
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: AppColors.navy,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.navy,
        selectedIconTheme: IconThemeData(color: AppColors.tealLight),
        unselectedIconTheme: IconThemeData(color: Colors.white70),
        selectedLabelTextStyle: TextStyle(color: Colors.white),
        unselectedLabelTextStyle: TextStyle(color: Colors.white70),
      ),
    );
  }

  static ThemeData emergency() {
    return light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFFFF8F7),
      colorScheme: light().colorScheme.copyWith(
        primary: AppColors.danger,
        secondary: AppColors.navy,
      ),
    );
  }
}

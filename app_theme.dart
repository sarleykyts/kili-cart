import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeMode { amoled, vintage }

class AppTheme {
  static ThemeData themeData(AppThemeMode mode) {
    final isAmoled = mode == AppThemeMode.amoled;
    final bg = isAmoled ? AppColors.amoledBackground : AppColors.vintageBackground;
    final card = isAmoled ? AppColors.amoledCard : AppColors.vintageCard;
    final surface = isAmoled ? AppColors.amoledSurface : AppColors.vintageSurface;
    final text = isAmoled ? AppColors.amoledText : AppColors.vintageText;
    final textSecondary = isAmoled ? AppColors.amoledTextSecondary : AppColors.vintageTextSecondary;
    final accent = isAmoled ? AppColors.primaryOrange : AppColors.vintageMutedOrange;
    final brightness = isAmoled ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      cardColor: card,
      primaryColor: accent,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accent,
        onPrimary: Colors.white,
        secondary: accent,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: text,
        background: bg,
        onBackground: text,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        isAmoled ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.poppins(
          color: text, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.poppins(
          color: text, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.poppins(
          color: text, fontSize: 18, fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(color: text, fontSize: 16),
        bodyMedium: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
        labelLarge: GoogleFonts.poppins(color: text, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accent.withOpacity(0.4), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accent.withOpacity(0.4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        labelStyle: TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: text),
        titleTextStyle: TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        margin: EdgeInsets.zero,
      ),
    );
  }
}

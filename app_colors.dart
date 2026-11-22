import 'package:flutter/material.dart';

/// KiliCart Design System - Colors
/// Primary: Vivid Orange #FF6B00
abstract class AppColors {
  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryOrangeLight = Color(0xFFFF8A33);
  static const Color primaryOrangeDark = Color(0xFFE55A00);

  // AMOLED Black theme
  static const Color amoledBackground = Color(0xFF000000);
  static const Color amoledCard = Color(0xFF121212);
  static const Color amoledSurface = Color(0xFF1A1A1A);
  static const Color amoledText = Color(0xFFFFFFFF);
  static const Color amoledTextSecondary = Color(0xFFB0B0B0);
  static const Color amoledAccent = Color(0xFFFF6B00);

  // Vintage theme
  static const Color vintageBackground = Color(0xFFFDF6EC);
  static const Color vintageCard = Color(0xFFF5E8D0);
  static const Color vintageSurface = Color(0xFFEFDFBE);
  static const Color vintageText = Color(0xFF4A3728);
  static const Color vintageTextSecondary = Color(0xFF8A7358);
  static const Color vintageMutedOrange = Color(0xFFD97706);
  static const Color vintagePaperGrain = Color(0x1A000000);

  // Gradients
  static LinearGradient amoledGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF6B00), Color(0xFF000000)],
  );
  static LinearGradient vintageGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5D7A0), Color(0xFFFDF6EC)],
  );
  static LinearGradient liquidGlassGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x0AFFFFFF)],
  );
}

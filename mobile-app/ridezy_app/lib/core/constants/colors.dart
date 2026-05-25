import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const background = Color(0xFF020617);
  static const surface = Color(0xFF0A0F1E);
  static const card = Color(0xFF0F172A);

  // Brand
  static const primary = Color(0xFF6D5DF6);
  static const primaryLight = Color(0xFF8B7FF8);
  static const secondary = Color(0xFF00D2FF);
  static const accent = Color(0xFF00FFB2);

  // Glow
  static const glowPurple = Color(0xFF6D5DF6);
  static const glowCyan = Color(0xFF00D2FF);
  static const glowGreen = Color(0xFF00FFB2);
  static const glowAmber = Color(0xFFFFB800);

  // Text
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF475569);

  // Status
  static const success = Color(0xFF00FFB2);
  static const warning = Color(0xFFFFB800);
  static const error = Color(0xFFFF4D6D);
  static const info = Color(0xFF00D2FF);

  // Borders
  static const border = Color(0xFF1E293B);
  static const borderGlow = Color(0xFF334155);

  // Glass
  static Color glassWhite = Colors.white.withOpacity(0.06);
  static Color glassBorder = Colors.white.withOpacity(0.10);
  static Color glassHighlight = Colors.white.withOpacity(0.15);

  // Gradients
  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF6D5DF6), Color(0xFF00D2FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientDark = LinearGradient(
    colors: [Color(0xFF020617), Color(0xFF0A0F1E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientCard = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient glassGradient = LinearGradient(
    colors: [
      Colors.white.withOpacity(0.10),
      Colors.white.withOpacity(0.04),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

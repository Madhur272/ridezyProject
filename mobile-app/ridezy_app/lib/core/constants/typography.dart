import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  // Hero title: 34-42
  static TextStyle heroTitle({double size = 38, Color? color}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.1,
        color: color ?? AppColors.textPrimary,
      );

  // Section title: 24-28
  static TextStyle sectionTitle({double size = 26, Color? color}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.2,
        color: color ?? AppColors.textPrimary,
      );

  // Card heading: 18-20
  static TextStyle cardHeading({double size = 18, Color? color}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.3,
        color: color ?? AppColors.textPrimary,
      );

  // Description: 14-16
  static TextStyle description({double size = 15, Color? color}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.5,
        color: color ?? AppColors.textSecondary,
      );

  // Metadata: 12-13
  static TextStyle metadata({double size = 12, Color? color}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        height: 1.4,
        color: color ?? AppColors.textMuted,
      );

  // Numeric / data display
  static TextStyle dataDisplay({double size = 32, Color? color}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        height: 1.0,
        color: color ?? AppColors.textPrimary,
      );

  // Button label
  static TextStyle button({double size = 16, Color? color}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: color ?? AppColors.textPrimary,
      );

  // Label / tag
  static TextStyle label({double size = 13, Color? color}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: color ?? AppColors.textSecondary,
      );
}

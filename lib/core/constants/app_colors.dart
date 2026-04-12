import 'package:flutter/material.dart';

/// App-wide color constants
class AppColors {
  AppColors._();

  // Primary palette — dark maroon/crimson from the design
  static const Color primary = Color(0xFFAE1E3F);
  static const Color primaryDark = Color(0xFF8E1833);
  static const Color primaryLight = Color(0xFFD22F55);
  static const Color tertiary = Color(0xFFEBC500);

  // Accent
  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentOrange = Color(0xFFFFA726);

  // Backgrounds
  static const Color scaffoldBg = Color(0xFFFFF8F5); // surface
  static const Color cardBg = Color(0xFFFFFFFF); // lowest surface
  static const Color darkBg = Color(0xFF1A1A2E);

  // Surface Containers
  static const Color surfaceContainerLow = Color(0xFFFFF1E8);
  static const Color surfaceContainer = Color(0xFFFBEBE0);
  static const Color surfaceContainerHigh = Color(0xFFF5E5DB);
  static const Color surfaceContainerHighest = Color(0xFFEFE0D5);

  // Text
  static const Color textPrimary = Color(0xFF221A14); // on_background
  static const Color textSecondary = Color(0xFF594042); // on_surface_variant
  static const Color textLight = Color(0xFF8D7072); // outline
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Kutoot brand colors
  static const Color kutootMaroon = Color(0xFFAE1E3F);
  static const Color kutootRed = Color(0xFFAE1E3F);
  static const Color locationOrange = Color(0xFFEA6B1E);
  static const Color bannerRed = Color(0xFFCC2936);
  static const Color bannerDarkRed = Color(0xFF9B1B30);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B1A4A), Color(0xFFBE1E48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFFCC2936), Color(0xFF9B1B30)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Misc
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shimmer = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  static const Color starYellow = Color(0xFFFFC107);
}

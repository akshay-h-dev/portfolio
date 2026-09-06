import 'package:flutter/material.dart';

/// Central color palette for the portfolio.
///
/// Structural colors (background/text/status) are fixed constants.
/// The single interactive "accent" color is NOT stored here — it lives in
/// `accentColorProvider` (lib/state/accent_color_provider.dart) and flows
/// through `ThemeData.colorScheme.secondary`, so anything that reads
/// `Theme.of(context).colorScheme.secondary` (see the `context.accent`
/// extension in app_theme.dart) updates live when the footer's global
/// color changer picks a new one — no page reload, no rebuild wiring
/// needed per-widget.
class AppColors {
  AppColors._();

  // Background — solid black everywhere, per the current design direction.
  static const Color background = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF000000);
  static const Color surface = Color(0xFF000000);

  // Outline — replaces the old glassmorphism fill/border. Cards, the nav
  // bar, and dividers are plain black with a white outline at rest; the
  // outline switches to the live accent color on hover (see OutlineCard).
  static const Color outline = Color(0x4DFFFFFF); // white @ ~30% alpha
  static const Color outlineSubtle = Color(0x1FFFFFFF); // white @ ~12% alpha

  // Text
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFFA9B2C3);
  static const Color textMuted = Color(0xFFA9B2C3);

  // Status
  static const Color success = Color(0xFF3DDC97);
  static const Color warning = Color(0xFFFFC048);
}

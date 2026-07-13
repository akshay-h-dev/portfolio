import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Reads the live global accent color from wherever a BuildContext is
/// available. Backed by Theme.of(context).colorScheme.secondary, which
/// MaterialApp.router regenerates whenever accentColorProvider changes
/// (see main.dart) — so this always reflects the footer color changer's
/// current pick, and reading it doesn't require Riverpod in the leaf widget.
extension AccentColorX on BuildContext {
  Color get accent => Theme.of(this).colorScheme.secondary;
}

/// Typography + ThemeData for the whole app.
///
/// Type system:
///  - Display: Space Grotesk  -> headings, hero name, section titles
///  - Body:    Inter          -> paragraphs, descriptions, UI copy
///  - Mono:    JetBrains Mono -> eyebrows/labels, tags, code-flavoured accents
class AppTheme {
  AppTheme._();

  static TextStyle get displayFont => GoogleFonts.spaceGrotesk();
  static TextStyle get bodyFont => GoogleFonts.inter();
  static TextStyle get monoFont => GoogleFonts.jetBrainsMono();

  /// Builds a full ThemeData for the given accent color. Called from
  /// main.dart every time accentColorProvider changes, so the whole app
  /// re-themes live.
  static ThemeData themeFor(Color accent) {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: accent,
      colorScheme: base.colorScheme.copyWith(
        primary: accent,
        secondary: accent,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: _textTheme(base.textTheme, accent),
      splashColor: accent.withValues(alpha: 0.10),
      highlightColor: Colors.transparent,
      hoverColor: Colors.white.withValues(alpha: 0.03),
      dividerColor: AppColors.outlineSubtle,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(accent.withValues(alpha: 0.5)),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base, Color accent) {
    return base.copyWith(
      displayLarge: displayFont.copyWith(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.05,
        letterSpacing: -1.2,
      ),
      displayMedium: displayFont.copyWith(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.1,
        letterSpacing: -0.8,
      ),
      headlineLarge: displayFont.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      headlineMedium: displayFont.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: displayFont.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: bodyFont.copyWith(
        fontSize: 17,
        color: AppColors.textSecondary,
        height: 1.6,
      ),
      bodyMedium: bodyFont.copyWith(
        fontSize: 15,
        color: AppColors.textSecondary,
        height: 1.55,
      ),
      labelLarge: monoFont.copyWith(
        fontSize: 13,
        color: accent,
        letterSpacing: 1.1,
      ),
      labelMedium: monoFont.copyWith(
        fontSize: 12,
        color: AppColors.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }
}

/// Picks black or white text for readable contrast on top of an arbitrary
/// accent fill (accent presets range from bright cyan to deep purple).
Color textColorOnAccent(Color accent) {
  return ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
      ? Colors.white
      : Colors.black;
}

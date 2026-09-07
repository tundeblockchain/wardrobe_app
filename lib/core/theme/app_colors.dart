import 'package:flutter/material.dart';

/// Burgundy / plum palette for Digital Wardrobe (WARDROBE-58).
///
/// Tokens are tuned for WCAG AA contrast on paired on-colors. Screens should
/// read [ColorScheme] from [ThemeData] instead of these constants.
abstract final class AppColors {
  // Light — wine burgundy + deep plum.
  static const lightPrimary = Color(0xFF7B1E3A);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFF3D6DE);
  static const lightOnPrimaryContainer = Color(0xFF3F1020);

  static const lightSecondary = Color(0xFF5C2A4A);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightSecondaryContainer = Color(0xFFF3D9EC);
  static const lightOnSecondaryContainer = Color(0xFF3A1832);

  static const lightTertiary = Color(0xFF8E3A4C);
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightTertiaryContainer = Color(0xFFFAD8E0);
  static const lightOnTertiaryContainer = Color(0xFF4A1824);

  static const lightError = Color(0xFFB42318);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFEE4E2);
  static const lightOnErrorContainer = Color(0xFF7A271A);

  static const lightSurface = Color(0xFFFBF6F8);
  static const lightOnSurface = Color(0xFF221318);
  static const lightOnSurfaceVariant = Color(0xFF5C4A51);
  static const lightOutline = Color(0xFF857078);
  static const lightOutlineVariant = Color(0xFFD8CBD0);
  static const lightInverseSurface = Color(0xFF36282D);
  static const lightOnInverseSurface = Color(0xFFF7EEF1);
  static const lightInversePrimary = Color(0xFFE8B4C4);
  static const lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const lightSurfaceContainerLow = Color(0xFFF7F0F3);
  static const lightSurfaceContainer = Color(0xFFF1E8EC);
  static const lightSurfaceContainerHigh = Color(0xFFEBE1E6);
  static const lightSurfaceContainerHighest = Color(0xFFE5D9DF);

  // Dark — dusty rose + muted plum on a wine surface.
  static const darkPrimary = Color(0xFFE2A4B4);
  static const darkOnPrimary = Color(0xFF4A1224);
  static const darkPrimaryContainer = Color(0xFF7B1E3A);
  static const darkOnPrimaryContainer = Color(0xFFFADCE4);

  static const darkSecondary = Color(0xFFD4B0C8);
  static const darkOnSecondary = Color(0xFF3A1832);
  static const darkSecondaryContainer = Color(0xFF5C2A4A);
  static const darkOnSecondaryContainer = Color(0xFFF3D9EC);

  static const darkTertiary = Color(0xFFE0A8B0);
  static const darkOnTertiary = Color(0xFF4A1824);
  static const darkTertiaryContainer = Color(0xFF8E3A4C);
  static const darkOnTertiaryContainer = Color(0xFFFAD8E0);

  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF912018);
  static const darkOnErrorContainer = Color(0xFFFEE4E2);

  static const darkSurface = Color(0xFF161012);
  static const darkOnSurface = Color(0xFFF4EEF1);
  static const darkOnSurfaceVariant = Color(0xFFD0C2C8);
  static const darkOutline = Color(0xFF9A8A90);
  static const darkOutlineVariant = Color(0xFF4A3D42);
  static const darkInverseSurface = Color(0xFFF4EEF1);
  static const darkOnInverseSurface = Color(0xFF2A2125);
  static const darkInversePrimary = Color(0xFF7B1E3A);
  static const darkSurfaceContainerLowest = Color(0xFF110D0F);
  static const darkSurfaceContainerLow = Color(0xFF1C1618);
  static const darkSurfaceContainer = Color(0xFF221C1F);
  static const darkSurfaceContainerHigh = Color(0xFF2C2428);
  static const darkSurfaceContainerHighest = Color(0xFF372E32);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: lightPrimary,
      onPrimary: lightOnPrimary,
      primaryContainer: lightPrimaryContainer,
      onPrimaryContainer: lightOnPrimaryContainer,
      secondary: lightSecondary,
      onSecondary: lightOnSecondary,
      secondaryContainer: lightSecondaryContainer,
      onSecondaryContainer: lightOnSecondaryContainer,
      tertiary: lightTertiary,
      onTertiary: lightOnTertiary,
      tertiaryContainer: lightTertiaryContainer,
      onTertiaryContainer: lightOnTertiaryContainer,
      error: lightError,
      onError: lightOnError,
      errorContainer: lightErrorContainer,
      onErrorContainer: lightOnErrorContainer,
      surface: lightSurface,
      onSurface: lightOnSurface,
      onSurfaceVariant: lightOnSurfaceVariant,
      outline: lightOutline,
      outlineVariant: lightOutlineVariant,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: lightInverseSurface,
      onInverseSurface: lightOnInverseSurface,
      inversePrimary: lightInversePrimary,
      surfaceTint: lightPrimary,
      surfaceContainerLowest: lightSurfaceContainerLowest,
      surfaceContainerLow: lightSurfaceContainerLow,
      surfaceContainer: lightSurfaceContainer,
      surfaceContainerHigh: lightSurfaceContainerHigh,
      surfaceContainerHighest: lightSurfaceContainerHighest,
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: darkOnPrimary,
      primaryContainer: darkPrimaryContainer,
      onPrimaryContainer: darkOnPrimaryContainer,
      secondary: darkSecondary,
      onSecondary: darkOnSecondary,
      secondaryContainer: darkSecondaryContainer,
      onSecondaryContainer: darkOnSecondaryContainer,
      tertiary: darkTertiary,
      onTertiary: darkOnTertiary,
      tertiaryContainer: darkTertiaryContainer,
      onTertiaryContainer: darkOnTertiaryContainer,
      error: darkError,
      onError: darkOnError,
      errorContainer: darkErrorContainer,
      onErrorContainer: darkOnErrorContainer,
      surface: darkSurface,
      onSurface: darkOnSurface,
      onSurfaceVariant: darkOnSurfaceVariant,
      outline: darkOutline,
      outlineVariant: darkOutlineVariant,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: darkInverseSurface,
      onInverseSurface: darkOnInverseSurface,
      inversePrimary: darkInversePrimary,
      surfaceTint: darkPrimary,
      surfaceContainerLowest: darkSurfaceContainerLowest,
      surfaceContainerLow: darkSurfaceContainerLow,
      surfaceContainer: darkSurfaceContainer,
      surfaceContainerHigh: darkSurfaceContainerHigh,
      surfaceContainerHighest: darkSurfaceContainerHighest,
    );
  }
}

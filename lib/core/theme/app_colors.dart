import 'package:flutter/material.dart';

/// Purple / pink palette for Digital Wardrobe.
///
/// Tokens are tuned for WCAG AA contrast on paired on-colors. Screens should
/// read [ColorScheme] from [ThemeData] instead of these constants.
abstract final class AppColors {
  // Light — jewel purple + deep pink.
  static const lightPrimary = Color(0xFF6C2BD9);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFE9D7FE);
  static const lightOnPrimaryContainer = Color(0xFF3B0764);

  static const lightSecondary = Color(0xFFC2185B);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightSecondaryContainer = Color(0xFFFCE7F3);
  static const lightOnSecondaryContainer = Color(0xFF831843);

  static const lightTertiary = Color(0xFFA21CAF);
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightTertiaryContainer = Color(0xFFFAE8FF);
  static const lightOnTertiaryContainer = Color(0xFF701A75);

  static const lightError = Color(0xFFB42318);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFEE4E2);
  static const lightOnErrorContainer = Color(0xFF7A271A);

  static const lightSurface = Color(0xFFFBF7FF);
  static const lightOnSurface = Color(0xFF1C1326);
  static const lightOnSurfaceVariant = Color(0xFF544B5E);
  static const lightOutline = Color(0xFF7D7388);
  static const lightOutlineVariant = Color(0xFFD4CBDA);
  static const lightInverseSurface = Color(0xFF32283A);
  static const lightOnInverseSurface = Color(0xFFF6EEF8);
  static const lightInversePrimary = Color(0xFFD8B4FE);
  static const lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const lightSurfaceContainerLow = Color(0xFFF6F0FC);
  static const lightSurfaceContainer = Color(0xFFF0E8F8);
  static const lightSurfaceContainerHigh = Color(0xFFEAE1F4);
  static const lightSurfaceContainerHighest = Color(0xFFE4DAF0);

  // Dark — luminous lilac + blush on a plum surface.
  static const darkPrimary = Color(0xFFC4B5FD);
  static const darkOnPrimary = Color(0xFF2E1065);
  static const darkPrimaryContainer = Color(0xFF5B21B6);
  static const darkOnPrimaryContainer = Color(0xFFEDE9FE);

  static const darkSecondary = Color(0xFFF9A8D4);
  static const darkOnSecondary = Color(0xFF831843);
  static const darkSecondaryContainer = Color(0xFF9D174D);
  static const darkOnSecondaryContainer = Color(0xFFFCE7F3);

  static const darkTertiary = Color(0xFFF0ABFC);
  static const darkOnTertiary = Color(0xFF701A75);
  static const darkTertiaryContainer = Color(0xFF86198F);
  static const darkOnTertiaryContainer = Color(0xFFFAE8FF);

  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF912018);
  static const darkOnErrorContainer = Color(0xFFFEE4E2);

  static const darkSurface = Color(0xFF141018);
  static const darkOnSurface = Color(0xFFF4EEF8);
  static const darkOnSurfaceVariant = Color(0xFFC9BFD4);
  static const darkOutline = Color(0xFF988EA3);
  static const darkOutlineVariant = Color(0xFF4A4154);
  static const darkInverseSurface = Color(0xFFF4EEF8);
  static const darkOnInverseSurface = Color(0xFF2A2232);
  static const darkInversePrimary = Color(0xFF6C2BD9);
  static const darkSurfaceContainerLowest = Color(0xFF0F0C13);
  static const darkSurfaceContainerLow = Color(0xFF1C1624);
  static const darkSurfaceContainer = Color(0xFF221C2B);
  static const darkSurfaceContainerHigh = Color(0xFF2C2536);
  static const darkSurfaceContainerHighest = Color(0xFF372F42);

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

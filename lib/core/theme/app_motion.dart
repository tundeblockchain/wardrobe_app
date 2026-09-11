import 'package:flutter/material.dart';

/// Shared motion, gloss, and shimmer tokens (WARDROBE-88).
///
/// Widgets should read these instead of hard-coding durations or opacities so
/// light/dark burgundy–plum surfaces stay consistent. Animations must check
/// [reduce] and skip motion when the platform requests it.
abstract final class AppMotion {
  static const fadeDuration = Duration(milliseconds: 240);
  static const pageDuration = Duration(milliseconds: 280);
  static const sheenDuration = Duration(milliseconds: 720);
  static const sparkleDuration = Duration(milliseconds: 900);

  static const fadeCurve = Curves.easeOutCubic;
  static const pageCurve = Curves.easeOutCubic;
  static const sheenCurve = Curves.easeInOutCubic;

  /// Vertical offset (logical pixels) for list-load fades.
  static const fadeSlide = 8.0;

  static const glossHighlightLight = 0.20;
  static const glossHighlightDark = 0.14;
  static const glossTailLight = 0.05;
  static const glossTailDark = 0.08;

  static const buttonGlossHighlightLight = 0.26;
  static const buttonGlossHighlightDark = 0.16;

  static const headerGlossHighlightLight = 0.18;
  static const headerGlossHighlightDark = 0.14;

  static const sheenPeakOpacity = 0.16;
  static const sparklePeakOpacity = 0.55;
  static const sparkleRestOpacity = 0.16;
  static const shimmerHighlight = 0.14;

  /// Platform "reduce motion" / disable animations.
  static bool reduce(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }

  static Duration fadeOf(BuildContext context) =>
      reduce(context) ? Duration.zero : fadeDuration;

  static Duration pageOf(BuildContext context) =>
      reduce(context) ? Duration.zero : pageDuration;

  static Duration sheenOf(BuildContext context) =>
      reduce(context) ? Duration.zero : sheenDuration;

  static Duration sparkleOf(BuildContext context) =>
      reduce(context) ? Duration.zero : sparkleDuration;
}

/// Tasteful fade used for route pushes (WARDROBE-88).
class AppFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const AppFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (AppMotion.reduce(context)) {
      return child;
    }
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: AppMotion.pageCurve),
      child: child,
    );
  }
}

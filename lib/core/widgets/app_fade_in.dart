import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// Short fade + lift used when list content first appears.
class AppFadeIn extends StatelessWidget {
  const AppFadeIn({super.key, required this.child});

  static const fadeKey = Key('app_fade_in');

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduce(context)) {
      return child;
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.fadeDuration,
      curve: AppMotion.fadeCurve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, AppMotion.fadeSlide * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

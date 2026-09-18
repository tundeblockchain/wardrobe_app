import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/coach_controller.dart';
import '../domain/coach_screen.dart';
import 'feature_coach_overlay.dart';

/// Wraps a screen and shows [FeatureCoachOverlay] the first time it is visited.
class ScreenCoachHost extends ConsumerWidget {
  const ScreenCoachHost({super.key, required this.screen, required this.child});

  final CoachScreen screen;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seen = ref.watch(coachControllerProvider).contains(screen);
    return Stack(
      children: [
        child,
        if (!seen)
          Positioned.fill(
            child: FeatureCoachOverlay(
              screen: screen,
              onDismiss: () {
                ref.read(coachControllerProvider.notifier).dismiss(screen);
              },
            ),
          ),
      ],
    );
  }
}

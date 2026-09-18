import 'package:flutter/material.dart';

import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_gloss.dart';
import '../../../core/widgets/app_sparkle.dart';
import '../domain/coach_screen.dart';

/// Spotlight-style first-visit coach mark (WARDROBE-99).
///
/// Dims the screen with a burgundy/plum scrim, cuts a soft spotlight above a
/// feature card, and dismisses on **Got it** or a tap outside the card.
class FeatureCoachOverlay extends StatelessWidget {
  const FeatureCoachOverlay({
    super.key,
    required this.screen,
    required this.onDismiss,
  });

  static const overlayKey = Key('feature_coach_overlay');
  static const scrimKey = Key('feature_coach_scrim');
  static const cardKey = Key('feature_coach_card');
  static const gotItKey = Key('feature_coach_got_it');
  static const spotlightKey = Key('feature_coach_spotlight');

  final CoachScreen screen;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final copy = CoachCopy.of(screen);
    final scheme = Theme.of(context).colorScheme;
    final overlay = Material(
      key: overlayKey,
      type: MaterialType.transparency,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            key: scrimKey,
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: CustomPaint(
              painter: SpotlightPainter(
                scrimColor: Color.alphaBlend(
                  scheme.primary.withValues(alpha: 0.28),
                  scheme.scrim.withValues(alpha: 0.58),
                ),
                glowColor: scheme.primary.withValues(alpha: 0.32),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: _CoachCard(copy: copy, onDismiss: onDismiss),
              ),
            ),
          ),
        ],
      ),
    );

    if (AppMotion.reduce(context)) {
      return overlay;
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
      child: overlay,
    );
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.copy, required this.onDismiss});

  final CoachCopy copy;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return GestureDetector(
      onTap: () {},
      child: Material(
        key: FeatureCoachOverlay.cardKey,
        color: scheme.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.dialog,
          side: BorderSide(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: AppGloss(
          borderRadius: AppRadii.dialog,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                    key: FeatureCoachOverlay.spotlightKey,
                    width: 72,
                    height: 72,
                    child: ClipOval(
                      child: AppGloss(
                        sheen: true,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ColoredBox(color: scheme.primaryContainer),
                            Center(
                              child: Icon(
                                copy.icon,
                                size: 36,
                                color: scheme.onPrimaryContainer,
                              ),
                            ),
                            const Positioned.fill(
                              child: AppSparkleAccent(count: 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  copy.title,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  copy.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  key: FeatureCoachOverlay.gotItKey,
                  onPressed: onDismiss,
                  child: const Text('Got it'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dim overlay with a soft radial spotlight above the coach card.
class SpotlightPainter extends CustomPainter {
  SpotlightPainter({required this.scrimColor, required this.glowColor});

  final Color scrimColor;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(bounds, Paint()..color = scrimColor);

    final spotlightCenter = Offset(size.width / 2, size.height * 0.38);
    final radius = size.shortestSide * 0.42;
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [glowColor, glowColor.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: spotlightCenter, radius: radius));
    canvas.drawCircle(spotlightCenter, radius, glow);
  }

  @override
  bool shouldRepaint(covariant SpotlightPainter oldDelegate) {
    return oldDelegate.scrimColor != scrimColor ||
        oldDelegate.glowColor != glowColor;
  }
}

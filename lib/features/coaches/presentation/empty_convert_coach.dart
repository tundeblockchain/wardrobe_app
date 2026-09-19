import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_fade_in.dart';
import '../../../core/widgets/app_gloss.dart';
import '../../../core/widgets/app_sparkle.dart';

/// Short empty-state convert card (WARDROBE-113). Not a tutorial overlay.
///
/// Burgundy/plum surfaces via [ColorScheme]. Fade respects [AppMotion.reduce]
/// through [AppFadeIn].
class EmptyConvertCoach extends StatelessWidget {
  const EmptyConvertCoach({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.primaryKey,
    this.secondaryKey,
  });

  static const coachKey = Key('empty_convert_coach');
  static const primaryActionKey = Key('empty_convert_primary');
  static const secondaryActionKey = Key('empty_convert_secondary');
  static const cardKey = Key('empty_convert_card');

  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Key? primaryKey;
  final Key? secondaryKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: AppFadeIn(
        child: Material(
          key: cardKey,
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
                children: [
                  SizedBox(
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
                                icon,
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
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    key: primaryKey ?? primaryActionKey,
                    onPressed: onPrimary,
                    child: Text(primaryLabel),
                  ),
                  if (secondaryLabel != null && onSecondary != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton(
                      key: secondaryKey ?? secondaryActionKey,
                      onPressed: onSecondary,
                      child: Text(secondaryLabel!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

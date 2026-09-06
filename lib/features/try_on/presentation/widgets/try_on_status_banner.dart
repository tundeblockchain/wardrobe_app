import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../outfits/domain/outfit_render.dart';

/// PENDING / PROCESSING / FAILED banner for a try-on render.
class TryOnStatusBanner extends StatelessWidget {
  const TryOnStatusBanner({super.key, required this.render});

  final OutfitRender render;

  static const bannerKey = Key('try_on_status_banner');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = _colorsFor(scheme, render.status);
    return Card(
      key: bannerKey,
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (render.status.isInProgress)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.foreground,
                ),
              )
            else
              Icon(_iconFor(render.status), color: colors.foreground),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    render.status.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _detail(render),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: render.status == OutfitRenderStatus.failed
                          ? scheme.error
                          : colors.foreground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _detail(OutfitRender render) {
  switch (render.status) {
    case OutfitRenderStatus.pending:
      return 'Queued — generating your look.';
    case OutfitRenderStatus.processing:
      return 'Still rendering this outfit.';
    case OutfitRenderStatus.ready:
      return 'Ready to view.';
    case OutfitRenderStatus.failed:
      return render.error ?? 'Try-on failed. Please try again.';
    case OutfitRenderStatus.unknown:
      return 'Status is unavailable.';
  }
}

IconData _iconFor(OutfitRenderStatus status) {
  switch (status) {
    case OutfitRenderStatus.pending:
      return Icons.schedule;
    case OutfitRenderStatus.processing:
      return Icons.autorenew;
    case OutfitRenderStatus.ready:
      return Icons.check_circle_outline;
    case OutfitRenderStatus.failed:
      return Icons.error_outline;
    case OutfitRenderStatus.unknown:
      return Icons.help_outline;
  }
}

class _ToneColors {
  const _ToneColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

_ToneColors _colorsFor(ColorScheme scheme, OutfitRenderStatus status) {
  switch (status) {
    case OutfitRenderStatus.pending:
      return _ToneColors(
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
      );
    case OutfitRenderStatus.processing:
      return _ToneColors(
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
      );
    case OutfitRenderStatus.ready:
      return _ToneColors(
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
      );
    case OutfitRenderStatus.failed:
      return _ToneColors(
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
      );
    case OutfitRenderStatus.unknown:
      return _ToneColors(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
      );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../domain/item.dart';
import '../../domain/processing_status_display.dart';

/// Compact badge for [Item.processingStatus] on grid cards and detail.
class ProcessingStatusChip extends StatelessWidget {
  const ProcessingStatusChip({
    super.key,
    required this.status,
    this.processingError,
    this.compact = true,
  });

  final ItemProcessingStatus status;
  final String? processingError;
  final bool compact;

  static Key chipKey(String itemId) => Key('item_status_chip_$itemId');

  @override
  Widget build(BuildContext context) {
    final display = ProcessingStatusDisplay.of(
      status,
      processingError: processingError,
    );
    final colors = _colorsFor(Theme.of(context).colorScheme, display.tone);
    final chip = Chip(
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: Icon(display.tone._icon, size: 16, color: colors.foreground),
      label: Text(display.label),
      labelStyle: TextStyle(
        color: colors.foreground,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: colors.background,
      side: BorderSide(color: colors.border),
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 4)
          : const EdgeInsets.symmetric(horizontal: 8),
    );
    if (status != ItemProcessingStatus.failed) {
      return chip;
    }
    return Tooltip(message: display.detailMessage, child: chip);
  }
}

/// Detail-page status banner with optional failed message and retry CTA.
class ProcessingStatusBanner extends StatelessWidget {
  const ProcessingStatusBanner({
    super.key,
    required this.status,
    this.processingError,
    this.onRetry,
    this.isRetrying = false,
    this.retryKey,
  });

  static const keyPrefix = Key('item_detail_status');
  static const retryButtonKey = Key('item_processing_retry');

  final ItemProcessingStatus status;
  final String? processingError;
  final VoidCallback? onRetry;
  final bool isRetrying;
  final Key? retryKey;

  @override
  Widget build(BuildContext context) {
    final display = ProcessingStatusDisplay.of(
      status,
      processingError: processingError,
    );
    final colors = _colorsFor(Theme.of(context).colorScheme, display.tone);
    final isFailed = status == ItemProcessingStatus.failed;
    final showRetry = isFailed && onRetry != null;
    return AppFadeIn(
      child: Card(
        key: keyPrefix,
        color: colors.background,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(display.tone._icon, color: colors.foreground),
                  const SizedBox(width: AppSpacing.sm + 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          display.label,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: colors.foreground,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          display.detailMessage,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: isFailed
                                    ? Theme.of(context).colorScheme.error
                                    : colors.foreground,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showRetry) ...[
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    key: retryKey ?? retryButtonKey,
                    onPressed: isRetrying ? null : onRetry,
                    icon: isRetrying
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(isRetrying ? 'Retrying…' : 'Retry'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ToneColors {
  const _ToneColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

_ToneColors _colorsFor(ColorScheme scheme, ProcessingStatusTone tone) {
  switch (tone) {
    case ProcessingStatusTone.pending:
      return _ToneColors(
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
        border: scheme.tertiary,
      );
    case ProcessingStatusTone.processing:
      return _ToneColors(
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
        border: scheme.secondary,
      );
    case ProcessingStatusTone.ready:
      return _ToneColors(
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
        border: scheme.primary,
      );
    case ProcessingStatusTone.failed:
      return _ToneColors(
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
        border: scheme.error,
      );
    case ProcessingStatusTone.unknown:
      return _ToneColors(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
        border: scheme.outline,
      );
  }
}

extension on ProcessingStatusTone {
  IconData get _icon {
    switch (this) {
      case ProcessingStatusTone.pending:
        return Icons.schedule;
      case ProcessingStatusTone.processing:
        return Icons.autorenew;
      case ProcessingStatusTone.ready:
        return Icons.check_circle_outline;
      case ProcessingStatusTone.failed:
        return Icons.error_outline;
      case ProcessingStatusTone.unknown:
        return Icons.help_outline;
    }
  }
}

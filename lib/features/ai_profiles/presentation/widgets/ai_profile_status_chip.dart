import 'package:flutter/material.dart';

import '../../domain/ai_profile.dart';
import '../../domain/ai_profile_status_display.dart';

/// Compact badge for [AiProfile.status] (READY / PROCESSING / FAILED).
class AiProfileStatusChip extends StatelessWidget {
  const AiProfileStatusChip({
    super.key,
    required this.status,
    this.compact = true,
  });

  final AiProfileStatus status;
  final bool compact;

  static Key chipKey(String profileId) => Key('ai_profile_status_$profileId');

  @override
  Widget build(BuildContext context) {
    final display = AiProfileStatusDisplay.of(status);
    final colors = _colorsFor(Theme.of(context).colorScheme, display.tone);
    return Chip(
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

_ToneColors _colorsFor(ColorScheme scheme, AiProfileStatusTone tone) {
  switch (tone) {
    case AiProfileStatusTone.pending:
      return _ToneColors(
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
        border: scheme.tertiary,
      );
    case AiProfileStatusTone.processing:
      return _ToneColors(
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
        border: scheme.secondary,
      );
    case AiProfileStatusTone.ready:
      return _ToneColors(
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
        border: scheme.primary,
      );
    case AiProfileStatusTone.failed:
      return _ToneColors(
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
        border: scheme.error,
      );
    case AiProfileStatusTone.unknown:
      return _ToneColors(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
        border: scheme.outline,
      );
  }
}

extension on AiProfileStatusTone {
  IconData get _icon {
    switch (this) {
      case AiProfileStatusTone.pending:
        return Icons.schedule;
      case AiProfileStatusTone.processing:
        return Icons.autorenew;
      case AiProfileStatusTone.ready:
        return Icons.check_circle_outline;
      case AiProfileStatusTone.failed:
        return Icons.error_outline;
      case AiProfileStatusTone.unknown:
        return Icons.help_outline;
    }
  }
}

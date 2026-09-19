import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_gloss.dart';
import '../../domain/inbox_copy.dart';
import '../../domain/job_event.dart';

/// One inbox row: READY success, FAILED error copy, PENDING still-processing.
class InboxEventTile extends StatelessWidget {
  const InboxEventTile({
    super.key,
    required this.event,
    required this.onOpen,
    required this.onDismiss,
  });

  final JobEvent event;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  static Key tileKey(String eventId) => Key('inbox_event_$eventId');

  static Key dismissKey(String eventId) => Key('inbox_dismiss_$eventId');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = _colorsFor(scheme, event.status);
    final title = InboxCopy.titleFor(event);
    final detail = InboxCopy.detailFor(event);

    return AppFadeIn(
      child: Dismissible(
        key: tileKey(event.eventId),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDismiss(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          color: scheme.errorContainer,
          child: Icon(Icons.close, color: scheme.onErrorContainer),
        ),
        child: Card(
          color: colors.background,
          clipBehavior: Clip.antiAlias,
          child: AppGloss(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              leading: Icon(colors.icon, color: colors.foreground),
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                detail,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: event.status.isFailed
                      ? scheme.error
                      : colors.foreground,
                ),
              ),
              trailing: IconButton(
                key: dismissKey(event.eventId),
                tooltip: InboxCopy.dismissTooltip,
                onPressed: onDismiss,
                icon: Icon(Icons.close, color: colors.foreground),
              ),
              onTap: onOpen,
            ),
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
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
}

_ToneColors _colorsFor(ColorScheme scheme, JobEventStatus status) {
  switch (status) {
    case JobEventStatus.ready:
      return _ToneColors(
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
        icon: Icons.check_circle_outline,
      );
    case JobEventStatus.failed:
      return _ToneColors(
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
        icon: Icons.error_outline,
      );
    case JobEventStatus.pending:
      return _ToneColors(
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
        icon: Icons.autorenew,
      );
    case JobEventStatus.unknown:
      return _ToneColors(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
        icon: Icons.notifications_outlined,
      );
  }
}

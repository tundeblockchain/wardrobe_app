import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../outfits/application/outfit_scope.dart';
import '../../application/outfit_worn_on_controller.dart';
import '../../application/worn_on_cache.dart';
import '../../application/worn_on_clock.dart';
import '../../domain/worn_on_date.dart';
import '../../domain/worn_on_entry.dart';

/// Outfit-detail worn-on log: mark today / pick a date / unmark.
class OutfitWornOnSection extends ConsumerWidget {
  const OutfitWornOnSection({
    super.key,
    required this.wardrobeId,
    required this.outfitId,
  });

  final String wardrobeId;
  final String outfitId;

  static const sectionKey = Key('outfit_worn_on_section');
  static const headingKey = Key('outfit_worn_on_heading');
  static const markTodayKey = Key('outfit_worn_on_mark_today');
  static const pickDateKey = Key('outfit_worn_on_pick_date');
  static const calendarLinkKey = Key('outfit_worn_on_calendar');
  static const retryKey = Key('outfit_worn_on_retry');
  static const errorKey = Key('outfit_worn_on_error');
  static const emptyKey = Key('outfit_worn_on_empty');
  static const listKey = Key('outfit_worn_on_list');
  static const loadingKey = Key('outfit_worn_on_loading');

  static Key entryKey(DateTime date) =>
      Key('outfit_worn_on_entry_${WornOnDate.formatWire(date)}');

  static Key unmarkKey(DateTime date) =>
      Key('outfit_worn_on_unmark_${WornOnDate.formatWire(date)}');

  OutfitScope get _scope =>
      OutfitScope(wardrobeId: wardrobeId, outfitId: outfitId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outfitWornOnControllerProvider(_scope));
    final today = WornOnDate.todayLocal(ref.watch(wornOnClockProvider)());
    final wornToday = state.hasDate(today);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppFadeIn(
      child: Column(
        key: sectionKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Worn on', key: headingKey, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Log the days you wore this look.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.icon(
                key: markTodayKey,
                onPressed: state.isSaving
                    ? null
                    : () => _mark(context, ref, today),
                icon: Icon(
                  wornToday
                      ? Icons.check_circle_outlined
                      : Icons.event_available_outlined,
                ),
                label: Text(wornToday ? 'Worn today' : 'Mark worn today'),
              ),
              OutlinedButton.icon(
                key: pickDateKey,
                onPressed: state.isSaving
                    ? null
                    : () => _pickDate(context, ref),
                icon: const Icon(Icons.calendar_today_outlined),
                label: const Text('Pick a date'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              key: calendarLinkKey,
              onPressed: () =>
                  context.push(AppRoutes.wardrobeWornOn(wardrobeId)),
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Wardrobe calendar'),
            ),
          ),
          if (state.isLoading && state.entries.isEmpty)
            const Padding(
              key: loadingKey,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.errorMessage != null && state.entries.isEmpty)
            AppErrorState(
              key: errorKey,
              message: state.errorMessage!,
              retryKey: retryKey,
              onRetry: () => ref
                  .read(outfitWornOnControllerProvider(_scope).notifier)
                  .refresh(),
            )
          else if (state.isEmpty)
            Text(
              'No worn dates yet.',
              key: emptyKey,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          else ...[
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  state.errorMessage!,
                  key: errorKey,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.error,
                  ),
                ),
              ),
            Column(
              key: listKey,
              children: [
                for (final entry in state.entries)
                  _WornOnDateTile(
                    entry: entry,
                    enabled: !state.isSaving,
                    onUnmark: () => _unmark(context, ref, entry.wornOn),
                  ),
              ],
            ),
          ],
          if (state.isSaving)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _mark(BuildContext context, WidgetRef ref, DateTime date) async {
    final ok = await ref
        .read(outfitWornOnControllerProvider(_scope).notifier)
        .markDate(date);
    if (!context.mounted) {
      return;
    }
    if (ok) {
      invalidateWornOnCaches(ref, wardrobeId: wardrobeId);
    } else {
      _showError(context, ref);
    }
  }

  Future<void> _unmark(
    BuildContext context,
    WidgetRef ref,
    DateTime date,
  ) async {
    final ok = await ref
        .read(outfitWornOnControllerProvider(_scope).notifier)
        .unmark(date);
    if (!context.mounted) {
      return;
    }
    if (ok) {
      invalidateWornOnCaches(ref, wardrobeId: wardrobeId);
    } else {
      _showError(context, ref);
    }
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final picked = await showWornOnDatePicker(context);
    if (picked == null || !context.mounted) {
      return;
    }
    await _mark(context, ref, WornOnDate.dateOnly(picked));
  }

  void _showError(BuildContext context, WidgetRef ref) {
    final message = ref
        .read(outfitWornOnControllerProvider(_scope))
        .errorMessage;
    if (message == null) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _WornOnDateTile extends StatelessWidget {
  const _WornOnDateTile({
    required this.entry,
    required this.enabled,
    required this.onUnmark,
  });

  final WornOnEntry entry;
  final bool enabled;
  final VoidCallback onUnmark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      key: OutfitWornOnSection.entryKey(entry.wornOn),
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        child: const Icon(Icons.checkroom_outlined),
      ),
      title: Text(WornOnDate.formatDisplay(entry.wornOn)),
      trailing: IconButton(
        key: OutfitWornOnSection.unmarkKey(entry.wornOn),
        tooltip: 'Unmark',
        onPressed: enabled ? onUnmark : null,
        icon: const Icon(Icons.close),
      ),
    );
  }
}

/// Burgundy/plum date picker for logging a worn-on day.
Future<DateTime?> showWornOnDatePicker(
  BuildContext context, {
  DateTime? initial,
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final lastDate = DateTime(today.year, today.month, today.day);
  final firstDate = DateTime(1970, 1, 1);
  var initialDate = initial == null
      ? lastDate
      : DateTime(initial.year, initial.month, initial.day);
  if (initialDate.isAfter(lastDate)) {
    initialDate = lastDate;
  }
  if (initialDate.isBefore(firstDate)) {
    initialDate = firstDate;
  }
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    helpText: 'Worn on',
  );
}

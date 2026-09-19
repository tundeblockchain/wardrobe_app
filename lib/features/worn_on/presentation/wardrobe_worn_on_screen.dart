import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_fade_in.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../search/presentation/app_search_gloss_bar.dart';
import '../application/wardrobe_worn_on_controller.dart';
import '../application/worn_on_cache.dart';
import '../domain/worn_on_date.dart';
import '../domain/worn_on_entry.dart';
import 'widgets/worn_on_month_calendar.dart';

/// Wardrobe month calendar / list of worn-on dates.
class WardrobeWornOnScreen extends ConsumerWidget {
  const WardrobeWornOnScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const retryButtonKey = Key('wardrobe_worn_on_retry');
  static const prevMonthKey = Key('wardrobe_worn_on_prev_month');
  static const nextMonthKey = Key('wardrobe_worn_on_next_month');
  static const monthLabelKey = Key('wardrobe_worn_on_month_label');
  static const listKey = Key('wardrobe_worn_on_list');
  static const emptyKey = Key('wardrobe_worn_on_empty');

  static Key entryKey(WornOnEntry entry) => Key(
    'wardrobe_worn_on_entry_${entry.outfitId}_${WornOnDate.formatWire(entry.wornOn)}',
  );

  static Key unmarkKey(WornOnEntry entry) => Key(
    'wardrobe_worn_on_unmark_${entry.outfitId}_${WornOnDate.formatWire(entry.wornOn)}',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wardrobeWornOnControllerProvider(wardrobeId));
    final outfits = ref.watch(outfitsControllerProvider(wardrobeId)).outfits;
    final names = {for (final outfit in outfits) outfit.id: outfit.name};

    return Scaffold(
      appBar: const AppSearchGlossBar(title: Text('Worn on')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref
              .read(wardrobeWornOnControllerProvider(wardrobeId).notifier)
              .refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.pageInsets,
            children: [
              _MonthHeader(
                month: state.visibleMonth,
                onPrev: state.isLoading
                    ? null
                    : () => ref
                          .read(
                            wardrobeWornOnControllerProvider(wardrobeId)
                                .notifier,
                          )
                          .shiftMonth(-1),
                onNext: state.isLoading
                    ? null
                    : () => ref
                          .read(
                            wardrobeWornOnControllerProvider(wardrobeId)
                                .notifier,
                          )
                          .shiftMonth(1),
              ),
              const SizedBox(height: AppSpacing.md),
              WornOnMonthCalendar(
                month: state.visibleMonth,
                markedDays: state.markedDays,
                selectedDay: state.selectedDay,
                onSelectDay: (day) => ref
                    .read(wardrobeWornOnControllerProvider(wardrobeId).notifier)
                    .selectDay(day),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.isLoading && state.entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.errorMessage != null && state.entries.isEmpty)
                AppErrorState(
                  message: state.errorMessage!,
                  retryKey: retryButtonKey,
                  onRetry: () => ref
                      .read(
                        wardrobeWornOnControllerProvider(wardrobeId).notifier,
                      )
                      .refresh(),
                )
              else ...[
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                if (state.visibleEntries.isEmpty)
                  AppEmptyState(
                    key: emptyKey,
                    icon: Icons.event_available_outlined,
                    title: state.selectedDay == null
                        ? 'No outfits logged'
                        : 'Nothing worn this day',
                    message: state.selectedDay == null
                        ? 'Mark an outfit as worn to fill this month.'
                        : 'Pick another day or mark an outfit as worn.',
                  )
                else
                  AppFadeIn(
                    child: Column(
                      key: listKey,
                      children: [
                        for (final entry in state.visibleEntries)
                          _CalendarEntryTile(
                            entry: entry,
                            outfitName: names[entry.outfitId] ?? 'Outfit',
                            enabled: !state.isSaving,
                            onOpen: () => context.push(
                              AppRoutes.outfitDetail(
                                wardrobeId,
                                entry.outfitId,
                              ),
                            ),
                            onUnmark: () => _unmark(context, ref, entry),
                          ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _unmark(
    BuildContext context,
    WidgetRef ref,
    WornOnEntry entry,
  ) async {
    final ok = await ref
        .read(wardrobeWornOnControllerProvider(wardrobeId).notifier)
        .unmark(outfitId: entry.outfitId, wornOn: entry.wornOn);
    if (!context.mounted) {
      return;
    }
    if (ok) {
      invalidateWornOnCaches(
        ref,
        wardrobeId: wardrobeId,
        outfitId: entry.outfitId,
      );
    } else {
      final message = ref
          .read(wardrobeWornOnControllerProvider(wardrobeId))
          .errorMessage;
      if (message != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          key: WardrobeWornOnScreen.prevMonthKey,
          tooltip: 'Previous month',
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            WornOnDate.formatMonth(month),
            key: WardrobeWornOnScreen.monthLabelKey,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          key: WardrobeWornOnScreen.nextMonthKey,
          tooltip: 'Next month',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _CalendarEntryTile extends StatelessWidget {
  const _CalendarEntryTile({
    required this.entry,
    required this.outfitName,
    required this.enabled,
    required this.onOpen,
    required this.onUnmark,
  });

  final WornOnEntry entry;
  final String outfitName;
  final bool enabled;
  final VoidCallback onOpen;
  final VoidCallback onUnmark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      key: WardrobeWornOnScreen.entryKey(entry),
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: const Icon(Icons.checkroom_outlined),
      ),
      title: Text(outfitName),
      subtitle: Text(WornOnDate.formatDisplay(entry.wornOn)),
      trailing: IconButton(
        key: WardrobeWornOnScreen.unmarkKey(entry),
        tooltip: 'Unmark',
        onPressed: enabled ? onUnmark : null,
        icon: const Icon(Icons.close),
      ),
      onTap: onOpen,
    );
  }
}

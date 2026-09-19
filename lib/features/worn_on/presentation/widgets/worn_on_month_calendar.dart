import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/worn_on_date.dart';

/// Compact month grid. Days with logs use the burgundy/plum container.
class WornOnMonthCalendar extends StatelessWidget {
  const WornOnMonthCalendar({
    super.key,
    required this.month,
    required this.markedDays,
    this.selectedDay,
    this.onSelectDay,
  });

  final DateTime month;
  final Set<DateTime> markedDays;
  final DateTime? selectedDay;
  final ValueChanged<DateTime>? onSelectDay;

  static const gridKey = Key('worn_on_month_grid');

  static Key dayKey(DateTime day) =>
      Key('worn_on_calendar_day_${WornOnDate.formatWire(day)}');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final localizations = MaterialLocalizations.of(context);
    final firstWeekday = localizations.firstDayOfWeekIndex;
    final labels = _weekdayLabels(localizations, firstWeekday);
    final cells = _monthCells(month, firstWeekday);

    return Column(
      key: gridKey,
      children: [
        Row(
          children: [
            for (final label in labels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        for (var row = 0; row < cells.length; row += 7)
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(child: _dayCell(context, cells[row + i])),
            ],
          ),
      ],
    );
  }

  Widget _dayCell(BuildContext context, DateTime? day) {
    if (day == null) {
      return const SizedBox(height: 40);
    }
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final marked = markedDays.contains(WornOnDate.dateOnly(day));
    final selected =
        selectedDay != null && WornOnDate.isSameDay(selectedDay!, day);

    final Color background;
    final Color foreground;
    if (selected) {
      background = scheme.primary;
      foreground = scheme.onPrimary;
    } else if (marked) {
      background = scheme.primaryContainer;
      foreground = scheme.onPrimaryContainer;
    } else {
      background = Colors.transparent;
      foreground = scheme.onSurface;
    }

    final child = AnimatedContainer(
      duration: AppMotion.reduce(context)
          ? Duration.zero
          : AppMotion.fadeDuration,
      curve: AppMotion.fadeCurve,
      height: 40,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.button,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: foreground,
          fontWeight: marked || selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );

    return InkWell(
      key: dayKey(day),
      onTap: onSelectDay == null ? null : () => onSelectDay!(day),
      borderRadius: AppRadii.button,
      child: child,
    );
  }
}

List<String> _weekdayLabels(
  MaterialLocalizations localizations,
  int firstWeekday,
) {
  const narrow = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  return [for (var i = 0; i < 7; i++) narrow[(firstWeekday + i) % 7]];
}

List<DateTime?> _monthCells(DateTime month, int firstWeekday) {
  final start = WornOnDate.monthOf(month);
  final last = WornOnDate.lastDayOfMonth(start);
  // DateTime.weekday: 1=Mon … 7=Sun. Material firstDayOfWeekIndex: 0=Sun.
  final dartWeekday = start.weekday % 7;
  var leading = dartWeekday - firstWeekday;
  if (leading < 0) {
    leading += 7;
  }
  final cells = <DateTime?>[
    for (var i = 0; i < leading; i++) null,
    for (var day = 1; day <= last.day; day++)
      DateTime.utc(start.year, start.month, day),
  ];
  while (cells.length % 7 != 0) {
    cells.add(null);
  }
  return cells;
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/item_acquired_at.dart';
import '../../domain/item_detail_meta.dart';

/// Optional acquired / purchased date. Empty is a valid choice (soft-omit).
class ItemAcquiredAtField extends StatelessWidget {
  const ItemAcquiredAtField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  static const fieldKey = Key('item_acquired_at_field');
  static const clearButtonKey = Key('item_acquired_at_clear');

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final acquired = ItemAcquiredAt.dateOnlyOrNull(value);
    final empty = acquired == null;
    return KeyedSubtree(
      key: fieldKey,
      child: InkWell(
        onTap: enabled ? () => _pick(context) : null,
        borderRadius: AppRadii.input,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Acquired / purchased (optional)',
            suffixIcon: empty
                ? Icon(
                    Icons.calendar_today_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                : IconButton(
                    key: clearButtonKey,
                    tooltip: 'Clear date',
                    onPressed: enabled ? () => onChanged(null) : null,
                    icon: const Icon(Icons.close),
                  ),
          ),
          child: Text(
            acquired == null
                ? ItemDetailMeta.emptyPlaceholder
                : ItemAcquiredAt.formatDisplay(acquired),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: acquired == null
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onSurface,
              fontStyle: acquired == null ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showItemAcquiredDatePicker(context, initial: value);
    if (picked != null) {
      onChanged(ItemAcquiredAt.dateOnly(picked));
    }
  }
}

/// Burgundy/plum [showDatePicker] shared by the form field and list filter.
Future<DateTime?> showItemAcquiredDatePicker(
  BuildContext context, {
  DateTime? initial,
}) {
  final now = DateTime.now();
  final lastDate = DateTime(now.year, now.month, now.day);
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
    helpText: 'Acquired / purchased',
  );
}

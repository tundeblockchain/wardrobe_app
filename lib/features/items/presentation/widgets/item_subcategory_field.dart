import 'package:flutter/material.dart';

import '../../domain/item.dart';
import '../../domain/item_detail_meta.dart';
import '../../domain/item_taxonomy.dart';

/// Optional subcategory dropdown. Empty / none is a valid choice.
///
/// Does not invent a dummy backend token. Edit save omits the field when
/// unchanged, sends JSON `null` to clear, and sends a trimmed string to set
/// (WARDROBE-87).
class ItemSubcategoryField extends StatelessWidget {
  const ItemSubcategoryField({
    super.key,
    required this.category,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  /// UI-only empty choice. Never written to the API.
  static const noneValue = '';

  static const fieldKey = Key('item_subcategory_field');
  static const noneItemKey = Key('item_subcategory_none');

  final ItemCategory? category;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final options = category == null
        ? const <ItemSubcategory>[]
        : ItemSubcategory.forCategory(category!);
    final current = value?.trim() ?? noneValue;
    final knownWires = [for (final option in options) option.wireValue];

    return KeyedSubtree(
      key: fieldKey,
      child: DropdownButtonFormField<String>(
        key: ValueKey<String>(
          'item_subcategory_${category?.wireValue ?? 'none'}_$current',
        ),
        initialValue: current,
        decoration: const InputDecoration(labelText: 'Subcategory (optional)'),
        items: [
          const DropdownMenuItem(
            key: noneItemKey,
            value: noneValue,
            child: Text('None'),
          ),
          for (final option in options)
            DropdownMenuItem(
              value: option.wireValue,
              child: Text(option.label),
            ),
          if (current.isNotEmpty && !knownWires.contains(current))
            DropdownMenuItem(
              value: current,
              child: Text(ItemDetailMeta.humanizeToken(current)),
            ),
        ],
        onChanged: enabled
            ? (selected) => onChanged(
                selected == null || selected == noneValue ? null : selected,
              )
            : null,
      ),
    );
  }
}

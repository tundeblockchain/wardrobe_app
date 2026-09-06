import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/item.dart';
import '../../domain/item_list_filters.dart';
import '../../domain/item_taxonomy.dart';

/// Category / colour / subcategory chips that map to WARDROBE-21 query params.
class ItemFilterBar extends StatelessWidget {
  const ItemFilterBar({
    super.key,
    required this.filters,
    required this.onChanged,
  });

  static const categoryRowKey = Key('item_filter_category');
  static const colourRowKey = Key('item_filter_colour');
  static const subcategoryRowKey = Key('item_filter_subcategory');
  static const clearButtonKey = Key('item_filter_clear');

  static Key categoryChipKey(ItemCategory category) =>
      Key('item_filter_category_${category.wireValue}');

  static Key colourChipKey(ItemColour colour) =>
      Key('item_filter_colour_${colour.wireValue}');

  static Key subcategoryChipKey(ItemSubcategory subcategory) =>
      Key('item_filter_subcategory_${subcategory.wireValue}');

  final ItemListFilters filters;
  final ValueChanged<ItemListFilters> onChanged;

  @override
  Widget build(BuildContext context) {
    final subcategories = filters.category == null
        ? const <ItemSubcategory>[]
        : ItemSubcategory.forCategory(filters.category!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChipRow(
          rowKey: categoryRowKey,
          label: 'Category',
          children: [
            for (final category in ItemCategory.values)
              FilterChip(
                key: categoryChipKey(category),
                label: Text(category.label),
                selected: filters.category == category,
                onSelected: (selected) {
                  onChanged(
                    filters.copyWith(
                      category: selected ? category : null,
                      clearCategory: !selected,
                      clearSubcategory: !selected,
                    ),
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _ChipRow(
          rowKey: colourRowKey,
          label: 'Colour',
          children: [
            for (final colour in ItemColour.values)
              FilterChip(
                key: colourChipKey(colour),
                label: Text(colour.label),
                selected: filters.colour == colour,
                onSelected: (selected) {
                  onChanged(
                    filters.copyWith(
                      colour: selected ? colour : null,
                      clearColour: !selected,
                    ),
                  );
                },
              ),
          ],
        ),
        if (subcategories.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          _ChipRow(
            rowKey: subcategoryRowKey,
            label: 'Subcategory',
            children: [
              for (final subcategory in subcategories)
                FilterChip(
                  key: subcategoryChipKey(subcategory),
                  label: Text(subcategory.label),
                  selected: filters.subcategory == subcategory,
                  onSelected: (selected) {
                    onChanged(
                      filters.copyWith(
                        subcategory: selected ? subcategory : null,
                        clearSubcategory: !selected,
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
        if (!filters.isEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: clearButtonKey,
              onPressed: () => onChanged(const ItemListFilters()),
              child: const Text('Clear filters'),
            ),
          ),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.rowKey,
    required this.label,
    required this.children,
  });

  final Key rowKey;
  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: rowKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../items/domain/item.dart';
import '../../../items/presentation/widgets/item_browse_image.dart';
import '../../domain/outfit.dart';

/// Horizontal cards for the items assigned to an outfit or suggestion.
class OutfitItemSlider extends StatelessWidget {
  const OutfitItemSlider({
    super.key,
    required this.assignments,
    required this.wardrobeItems,
    required this.onItemTap,
  });

  final List<OutfitItem> assignments;
  final List<Item> wardrobeItems;
  final ValueChanged<String> onItemTap;

  static const sliderKey = Key('outfit_item_slider');
  static const emptyKey = Key('outfit_item_slider_empty');

  static Key cardKey(String itemId) => Key('outfit_item_slider_card_$itemId');

  static const double cardWidth = 132;
  static const double photoHeight = 176;

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return Text(
        key: emptyKey,
        'No items in this look yet.',
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
    }

    final itemsById = {for (final item in wardrobeItems) item.id: item};
    return SizedBox(
      key: sliderKey,
      height: photoHeight + 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: assignments.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          final item = itemsById[assignment.itemId];
          return _ItemCard(
            assignment: assignment,
            item: item,
            onTap: () => onItemTap(assignment.itemId),
          );
        },
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.assignment,
    required this.item,
    required this.onTap,
  });

  final OutfitItem assignment;
  final Item? item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = item?.name ?? assignment.slot.label;
    return SizedBox(
      width: OutfitItemSlider.cardWidth,
      child: Card(
        key: OutfitItemSlider.cardKey(assignment.itemId),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: OutfitItemSlider.photoHeight,
                width: double.infinity,
                child: item == null
                    ? _SlotPlaceholder(slot: assignment.slot)
                    : ItemBrowseImage(item: item!),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.slot.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      label,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlotPlaceholder extends StatelessWidget {
  const _SlotPlaceholder({required this.slot});

  final ItemCategory slot;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.primaryContainer,
      child: Center(
        child: Text(
          slot.label[0],
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: scheme.onPrimaryContainer),
        ),
      ),
    );
  }
}

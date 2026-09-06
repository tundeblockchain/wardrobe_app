import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/item.dart';
import 'item_browse_image.dart';
import 'processing_status_chip.dart';

/// Large Tinder-style clothing card: photo, status badge, and metadata.
class ItemSwipeCard extends StatelessWidget {
  const ItemSwipeCard({
    super.key,
    required this.item,
    this.onTap,
    this.enabled = true,
  });

  final Item item;
  final VoidCallback? onTap;
  final bool enabled;

  static Key cardKey(String itemId) => Key('item_tile_$itemId');

  static Key swipeCardKey(String itemId) => Key('item_swipe_card_$itemId');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      key: swipeCardKey(item.id),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: enabled ? 2 : 0,
      child: InkWell(
        key: cardKey(item.id),
        onTap: enabled ? onTap : null,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ItemBrowseImage(item: item),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.inverseSurface.withValues(alpha: 0),
                    scheme.inverseSurface.withValues(alpha: 0.78),
                  ],
                  stops: const [0.55, 1],
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: ProcessingStatusChip(
                key: ProcessingStatusChip.chipKey(item.id),
                status: item.processingStatus,
                processingError: item.processingError,
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: scheme.onInverseSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    [
                      item.category.label,
                      if (item.brand != null && item.brand!.isNotEmpty)
                        item.brand,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onInverseSurface.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),
            if (!enabled)
              ColoredBox(color: scheme.surface.withValues(alpha: 0.04)),
          ],
        ),
      ),
    );
  }
}

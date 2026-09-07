import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/entity_delete.dart';
import '../../application/item_local_preview_cache.dart';
import '../../domain/item.dart';
import '../../domain/processing_status_display.dart';
import 'item_browse_image.dart';
import 'processing_status_chip.dart';

/// Large Tinder-style clothing card: photo, status badge, and metadata.
class ItemSwipeCard extends ConsumerWidget {
  const ItemSwipeCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
    this.enabled = true,
  });

  final Item item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool enabled;

  static Key cardKey(String itemId) => Key('item_tile_$itemId');

  static Key swipeCardKey(String itemId) => Key('item_swipe_card_$itemId');

  static Key deleteKey(String itemId) => Key('item_card_delete_$itemId');

  static Key processingErrorKey(String itemId) =>
      Key('item_processing_error_$itemId');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final localPreview = ref.watch(itemLocalPreviewCacheProvider)[item.id];
    return Card(
      key: swipeCardKey(item.id),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: enabled ? 2 : 0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            key: cardKey(item.id),
            onTap: enabled ? onTap : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ItemBrowseImage(item: item, localPreviewBytes: localPreview),
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
                          color: scheme.onInverseSurface.withValues(
                            alpha: 0.92,
                          ),
                        ),
                      ),
                      if (item.processingStatus ==
                          ItemProcessingStatus.failed) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          key: processingErrorKey(item.id),
                          ProcessingStatusDisplay.of(
                            item.processingStatus,
                            processingError: item.processingError,
                          ).detailMessage,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!enabled)
                  ColoredBox(color: scheme.surface.withValues(alpha: 0.04)),
              ],
            ),
          ),
          if (onDelete != null && enabled)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: EntityDeleteIconButton(
                key: deleteKey(item.id),
                tooltip: 'Delete item',
                overlay: true,
                onPressed: onDelete,
              ),
            ),
        ],
      ),
    );
  }
}

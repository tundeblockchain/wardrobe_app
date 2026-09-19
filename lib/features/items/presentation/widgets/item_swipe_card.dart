import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_gloss.dart';
import '../../../../core/widgets/entity_delete.dart';
import '../../application/item_local_preview_cache.dart';
import '../../domain/item.dart';
import '../../domain/processing_status_display.dart';
import 'item_browse_image.dart';

/// Large Tinder-style clothing card: photo and metadata.
///
/// FAILED items show [processingError] and a retry CTA (WARDROBE-124).
/// PENDING / PROCESSING chrome stays hidden unless a reprocess poll is active.
class ItemSwipeCard extends ConsumerWidget {
  const ItemSwipeCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
    this.onRetry,
    this.showProcessingProgress = false,
    this.isRetrying = false,
    this.enabled = true,
  });

  final Item item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRetry;
  final bool showProcessingProgress;
  final bool isRetrying;
  final bool enabled;

  static Key cardKey(String itemId) => Key('item_tile_$itemId');

  static Key swipeCardKey(String itemId) => Key('item_swipe_card_$itemId');

  static Key deleteKey(String itemId) => Key('item_card_delete_$itemId');

  static Key retryKey(String itemId) => Key('item_card_retry_$itemId');

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
      child: AppGloss(
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
            if (_showFailedOverlay || showProcessingProgress)
              Positioned(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                top: onDelete != null && enabled ? 52 : AppSpacing.sm,
                child: _ItemProcessingOverlay(
                  item: item,
                  onRetry: _showFailedOverlay ? onRetry : null,
                  isRetrying: isRetrying,
                  retryKey: retryKey(item.id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool get _showFailedOverlay => enabled && item.processingStatus.canReprocess;
}

class _ItemProcessingOverlay extends StatelessWidget {
  const _ItemProcessingOverlay({
    required this.item,
    required this.retryKey,
    this.onRetry,
    this.isRetrying = false,
  });

  final Item item;
  final Key retryKey;
  final VoidCallback? onRetry;
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final display = ProcessingStatusDisplay.of(
      item.processingStatus,
      processingError: item.processingError,
    );
    final failed = item.processingStatus.canReprocess;
    return AppFadeIn(
      child: Material(
        color: failed ? scheme.errorContainer : scheme.tertiaryContainer,
        borderRadius: AppRadii.button,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                failed ? Icons.error_outline : Icons.schedule,
                size: 18,
                color: failed
                    ? scheme.onErrorContainer
                    : scheme.onTertiaryContainer,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      display.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: failed
                            ? scheme.onErrorContainer
                            : scheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (failed) ...[
                      const SizedBox(height: 2),
                      Text(
                        display.detailMessage,
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
              if (onRetry != null) ...[
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  key: retryKey,
                  onPressed: isRetrying ? null : onRetry,
                  child: Text(isRetrying ? 'Retrying…' : 'Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

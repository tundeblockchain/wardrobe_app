import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_gloss.dart';
import '../../../../core/widgets/entity_delete.dart';
import '../../../items/domain/item.dart';
import '../../domain/outfit.dart';
import 'outfit_cover_preview.dart';
import 'outfit_list_tile.dart';

/// Horizontal slider of outfit cards: try-on photo, else an item photo, else hanger.
class OutfitCarousel extends StatelessWidget {
  const OutfitCarousel({
    super.key,
    required this.wardrobeId,
    required this.outfits,
    this.wardrobeItems = const [],
    this.onDelete,
    this.cardKeyFor,
  });

  final String wardrobeId;
  final List<Outfit> outfits;
  final List<Item> wardrobeItems;
  final ValueChanged<Outfit>? onDelete;
  final Key Function(Outfit outfit)? cardKeyFor;

  static const carouselKey = Key('outfit_carousel');

  static Key cardKey(String outfitId) => Key('outfit_carousel_card_$outfitId');

  static const double cardWidth = 168;
  static const double photoHeight = 224;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: carouselKey,
      height: photoHeight + 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: outfits.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final outfit = outfits[index];
          return _OutfitSlide(
            wardrobeId: wardrobeId,
            outfit: outfit,
            wardrobeItems: wardrobeItems,
            onDelete: onDelete == null ? null : () => onDelete!(outfit),
            cardKey: cardKeyFor?.call(outfit) ?? cardKey(outfit.id),
          );
        },
      ),
    );
  }
}

class _OutfitSlide extends StatelessWidget {
  const _OutfitSlide({
    required this.wardrobeId,
    required this.outfit,
    required this.wardrobeItems,
    required this.cardKey,
    this.onDelete,
  });

  final String wardrobeId;
  final Outfit outfit;
  final List<Item> wardrobeItems;
  final Key cardKey;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = outfit.items.length;
    return SizedBox(
      width: OutfitCarousel.cardWidth,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: AppGloss(
          sheen: true,
          child: Stack(
            children: [
              InkWell(
                key: cardKey,
                onTap: () =>
                    context.push(AppRoutes.outfitDetail(wardrobeId, outfit.id)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: OutfitCarousel.photoHeight,
                      width: double.infinity,
                      child: OutfitCoverPreview(
                        outfit: outfit,
                        wardrobeItems: wardrobeItems,
                        width: double.infinity,
                        height: double.infinity,
                      ),
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
                            outfit.name,
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            count == 1 ? '1 item' : '$count items',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: EntityDeleteIconButton(
                    key: OutfitListTile.deleteKey(outfit.id),
                    tooltip: 'Delete outfit',
                    overlay: true,
                    onPressed: onDelete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../items/domain/item.dart';
import '../../domain/outfit.dart';
import '../../domain/outfit_cover.dart';

export '../../domain/outfit_cover.dart' show outfitPreviewImageUrl;

/// Outfits-list leading: try-on URL, else an assigned item photo, else hanger.
class OutfitListPreview extends StatelessWidget {
  const OutfitListPreview({
    super.key,
    required this.outfit,
    this.wardrobeItems = const [],
    this.width = 56,
    this.height = 72,
  });

  final Outfit outfit;
  final List<Item> wardrobeItems;
  final double width;
  final double height;

  static Key imageKey(String outfitId) => Key('outfit_list_preview_$outfitId');

  static Key hangerKey(String outfitId) => Key('outfit_list_hanger_$outfitId');

  static Key urlKey(String url) => Key('outfit_list_preview_url_$url');

  static Key itemSourceKey(String itemId) =>
      Key('outfit_list_preview_item_$itemId');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cover = resolveOutfitCover(outfit, wardrobeItems);

    final Widget child;
    if (cover.hasPhoto) {
      child = Image.network(
        cover.networkUrl!,
        key: urlKey(cover.networkUrl!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return _Hanger(
            background: scheme.primaryContainer,
            foreground: scheme.onPrimaryContainer,
          );
        },
        loadingBuilder: (context, image, progress) {
          if (progress == null) {
            return image;
          }
          return ColoredBox(
            color: scheme.primaryContainer,
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: scheme.primary,
                ),
              ),
            ),
          );
        },
      );
    } else {
      child = _Hanger(
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
      );
    }

    final sourceKey = cover.kind == OutfitCoverKind.item && cover.item != null
        ? itemSourceKey(cover.item!.id)
        : null;

    return SizedBox(
      key: cover.hasPhoto ? imageKey(outfit.id) : hangerKey(outfit.id),
      width: width,
      height: height,
      child: ColoredBox(
        color: scheme.primaryContainer,
        child: sourceKey == null
            ? child
            : KeyedSubtree(key: sourceKey, child: child),
      ),
    );
  }
}

class _Hanger extends StatelessWidget {
  const _Hanger({required this.background, required this.foreground});

  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background,
      child: Center(child: Icon(Icons.checkroom_outlined, color: foreground)),
    );
  }
}

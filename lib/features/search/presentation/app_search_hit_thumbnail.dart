import 'package:flutter/material.dart';

import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/app_search.dart';

/// Leading thumbnail for a header-search hit (WARDROBE-97).
///
/// Clothing items use list/get `processedImageUrl`, else `originalImageUrl`.
/// Outfits use a cover already on the model. Missing or failed images
/// soft-fail to a kind icon so the row never breaks. [AppMotion.reduce]
/// skips the loading spinner.
class AppSearchHitThumbnail extends StatelessWidget {
  const AppSearchHitThumbnail({super.key, required this.hit});

  static const size = 48.0;

  static Key thumbnailKey(AppSearchHitKind kind, String id) =>
      Key('app_search_hit_thumb_${kind.name}_$id');

  static Key imageKey(String url) => Key('app_search_hit_thumb_url_$url');

  static Key placeholderKey(AppSearchHitKind kind, String id) =>
      Key('app_search_hit_thumb_placeholder_${kind.name}_$id');

  final AppSearchHit hit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = hit.imageUrl?.trim();
    final hasUrl = url != null && url.isNotEmpty;

    final Widget child;
    if (hasUrl) {
      child = Image.network(
        url,
        key: imageKey(url),
        fit: BoxFit.cover,
        width: size,
        height: size,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return _HitPlaceholder(hit: hit);
        },
        loadingBuilder: (context, image, progress) {
          if (progress == null) {
            return image;
          }
          if (AppMotion.reduce(context)) {
            return _HitPlaceholder(hit: hit);
          }
          return ColoredBox(
            color: scheme.primaryContainer,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
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
      child = _HitPlaceholder(hit: hit);
    }

    return ClipRRect(
      key: thumbnailKey(hit.kind, hit.id),
      borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm)),
      child: SizedBox(
        width: size,
        height: size,
        child: ColoredBox(color: scheme.primaryContainer, child: child),
      ),
    );
  }
}

class _HitPlaceholder extends StatelessWidget {
  const _HitPlaceholder({required this.hit});

  final AppSearchHit hit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      key: AppSearchHitThumbnail.placeholderKey(hit.kind, hit.id),
      color: scheme.primaryContainer,
      child: Center(
        child: Icon(_iconFor(hit.kind), color: scheme.onPrimaryContainer),
      ),
    );
  }
}

IconData _iconFor(AppSearchHitKind kind) {
  return switch (kind) {
    AppSearchHitKind.item => Icons.checkroom_outlined,
    AppSearchHitKind.outfit => Icons.layers_outlined,
    AppSearchHitKind.wardrobe => Icons.door_sliding_outlined,
  };
}

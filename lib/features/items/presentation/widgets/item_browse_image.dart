import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/item.dart';
import '../../domain/item_image_source.dart';

/// Item photo: processed URL when present, otherwise original.
///
/// Cards use [BoxFit.cover] so the picture fills the frame (WARDROBE-76).
/// Pass [BoxFit.contain] for the enlarged popup. Local upload bytes fill in
/// when the payload only has S3 object keys. Job status is never drawn.
class ItemBrowseImage extends StatelessWidget {
  const ItemBrowseImage({
    super.key,
    required this.item,
    this.localPreviewBytes,
    this.fit = BoxFit.cover,
  });

  final Item item;
  final Uint8List? localPreviewBytes;
  final BoxFit fit;

  static Key imageKey(String itemId) => Key('item_browse_image_$itemId');

  static Key sourceKey(String source) =>
      Key('item_browse_image_source_$source');

  static const missingSourceKey = Key('item_browse_image_source_none');

  static Key localSourceKey(String itemId) =>
      Key('item_browse_image_source_local_$itemId');

  @override
  Widget build(BuildContext context) {
    final source = ItemImageSource.fromItem(item);
    final preview = localPreviewBytes;
    final hasLocal = preview != null && preview.isNotEmpty;
    final Widget photo;
    final Key sourceSubtreeKey;
    if (source.networkUrl != null) {
      sourceSubtreeKey = sourceKey(source.key!);
      photo = Image.network(
        source.networkUrl!,
        fit: fit,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          if (hasLocal) {
            return _localImage(preview);
          }
          return _ItemImagePlaceholder(item: item);
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          if (hasLocal) {
            return _localImage(preview);
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } else if (hasLocal) {
      sourceSubtreeKey = localSourceKey(item.id);
      photo = _localImage(preview);
    } else {
      sourceSubtreeKey = source.key == null
          ? missingSourceKey
          : sourceKey(source.key!);
      photo = _ItemImagePlaceholder(item: item);
    }

    return ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: KeyedSubtree(
        key: imageKey(item.id),
        child: KeyedSubtree(key: sourceSubtreeKey, child: photo),
      ),
    );
  }

  Widget _localImage(Uint8List bytes) {
    return Image.memory(
      bytes,
      fit: fit,
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return _ItemImagePlaceholder(item: item);
      },
    );
  }
}

class _ItemImagePlaceholder extends StatelessWidget {
  const _ItemImagePlaceholder({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.secondaryContainer],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checkroom_outlined,
              size: 72,
              color: scheme.onPrimaryContainer,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.category.label,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: scheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

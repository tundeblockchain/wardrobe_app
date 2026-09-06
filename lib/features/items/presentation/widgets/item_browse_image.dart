import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/item.dart';
import '../../domain/item_image_source.dart';

/// Full-bleed item photo: processed key when present, otherwise original.
class ItemBrowseImage extends StatelessWidget {
  const ItemBrowseImage({super.key, required this.item});

  final Item item;

  static Key imageKey(String itemId) => Key('item_browse_image_$itemId');

  static Key sourceKey(String source) =>
      Key('item_browse_image_source_$source');

  static const missingSourceKey = Key('item_browse_image_source_none');

  @override
  Widget build(BuildContext context) {
    final source = ItemImageSource.fromItem(item);
    final child = source.networkUrl == null
        ? _ItemImagePlaceholder(item: item)
        : Image.network(
            source.networkUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return _ItemImagePlaceholder(item: item);
            },
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                return child;
              }
              return const Center(child: CircularProgressIndicator());
            },
          );

    return KeyedSubtree(
      key: imageKey(item.id),
      child: KeyedSubtree(
        key: source.key == null ? missingSourceKey : sourceKey(source.key!),
        child: child,
      ),
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

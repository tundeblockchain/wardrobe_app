import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_gloss.dart';
import '../../domain/shopping_link.dart';

/// Google Shopping–style product card. Opens [link.url] when tapped.
class ShoppingProductCard extends StatelessWidget {
  const ShoppingProductCard({
    super.key,
    required this.link,
    required this.onTap,
  });

  final ShoppingLink link;
  final VoidCallback onTap;

  static const cardWidth = 148.0;
  static const imageHeight = 148.0;
  static const placeholderKey = Key('shopping_product_image_placeholder');

  static Key cardKey(String url) => Key('shopping_product_card_$url');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox(
      width: cardWidth,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: AppGloss(
          child: InkWell(
            key: cardKey(link.url),
            onTap: onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: imageHeight,
                  child: ColoredBox(
                    color: scheme.primaryContainer,
                    child: _ProductImage(imageUrl: link.imageUrl),
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
                        link.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      if (link.merchant != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          link.merchant!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (link.displayPrice != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          link.displayPrice!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null) {
      return const _ShoppingImagePlaceholder();
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const _ShoppingImagePlaceholder();
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ShoppingImagePlaceholder extends StatelessWidget {
  const _ShoppingImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      key: ShoppingProductCard.placeholderKey,
      color: scheme.primaryContainer,
      child: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 40,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/enlarged_image_popup.dart';
import '../../domain/outfit.dart';
import '../../domain/outfit_cover.dart';

/// Outfit detail hero: try-on photo when Backend returned `render.imageUrl`,
/// otherwise a burgundy card that opens Try On.
class OutfitHeroCard extends StatelessWidget {
  const OutfitHeroCard({
    super.key,
    required this.outfit,
    required this.onTryOn,
  });

  final Outfit outfit;
  final VoidCallback onTryOn;

  static const cardKey = Key('outfit_hero_card');
  static const tryOnHintKey = Key('outfit_hero_try_on');
  static const imageKey = Key('outfit_hero_image');

  static Key urlKey(String url) => Key('outfit_hero_url_$url');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = outfitPreviewImageUrl(outfit);

    return Card(
      key: cardKey,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: url == null
            ? onTryOn
            : () => EnlargedImagePopup.showNetwork(context, url: url),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: url == null
              ? ColoredBox(
                  key: tryOnHintKey,
                  color: scheme.primaryContainer,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.checkroom_outlined,
                            size: 72,
                            color: scheme.onPrimaryContainer,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Tap to try on',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: scheme.onPrimaryContainer),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'No AI try-on photo yet',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: scheme.onPrimaryContainer),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ColoredBox(
                  key: imageKey,
                  color: scheme.primaryContainer,
                  child: Image.network(
                    url,
                    key: urlKey(url),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return ColoredBox(
                        color: scheme.primaryContainer,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(color: scheme.primary),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

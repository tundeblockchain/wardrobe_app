import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/enlarged_image_popup.dart';
import '../../domain/outfit.dart';
import '../../domain/try_on_history.dart';
import 'outfit_try_on_gallery.dart';

/// Outfit detail hero: swipeable try-ons when any exist, otherwise hanger.
class OutfitHeroCard extends StatelessWidget {
  const OutfitHeroCard({
    super.key,
    required this.outfit,
    required this.onTryOn,
    this.selectedHeroUrl,
    this.onSelectHero,
  });

  final Outfit outfit;
  final VoidCallback onTryOn;
  final String? selectedHeroUrl;
  final ValueChanged<String>? onSelectHero;

  static const cardKey = Key('outfit_hero_card');
  static const tryOnHintKey = Key('outfit_hero_try_on');
  static const imageKey = Key('outfit_hero_image');

  static Key urlKey(String url) => Key('outfit_hero_url_$url');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final urls = tryOnDisplayUrls(
      latestRender: outfit.render,
      renderImageUrls: outfit.renderImageUrls,
      history: outfit.renderHistory,
    );

    return Card(
      key: cardKey,
      clipBehavior: Clip.antiAlias,
      child: urls.isEmpty
          ? InkWell(
              onTap: onTryOn,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ColoredBox(
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
                ),
              ),
            )
          : urls.length == 1
          ? InkWell(
              onTap: () =>
                  EnlargedImagePopup.showNetwork(context, url: urls.single),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ColoredBox(
                  key: imageKey,
                  color: scheme.primaryContainer,
                  child: Image.network(
                    urls.single,
                    key: urlKey(urls.single),
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
            )
          : OutfitTryOnGallery(
              imageUrls: urls,
              selectedUrl:
                  outfitHeroImageUrl(
                    latestRender: outfit.render,
                    renderImageUrls: outfit.renderImageUrls,
                    history: outfit.renderHistory,
                    selectedUrl: selectedHeroUrl,
                  ) ??
                  urls.first,
              onSelect: onSelectHero,
            ),
    );
  }
}

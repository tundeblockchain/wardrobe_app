import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/enlarged_image_popup.dart';

/// Displays a READY try-on via the backend presigned [imageUrl].
///
/// The card crops with [BoxFit.cover]. Tap opens the full image.
class TryOnResultImage extends StatelessWidget {
  const TryOnResultImage({super.key, required this.imageUrl});

  final String imageUrl;

  static const imageKey = Key('try_on_result_image');

  static Key urlKey(String url) => Key('try_on_result_url_$url');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: imageKey,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => EnlargedImagePopup.showNetwork(context, url: imageUrl),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: ColoredBox(
            color: scheme.primaryContainer,
            child: Image.network(
              imageUrl,
              key: urlKey(imageUrl),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: scheme.primaryContainer,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: scheme.onPrimaryContainer,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Could not load the try-on image.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: scheme.onPrimaryContainer),
                          ),
                        ],
                      ),
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

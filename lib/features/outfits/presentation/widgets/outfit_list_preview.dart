import 'package:flutter/material.dart';

import '../../domain/outfit.dart';

/// Existing Backend try-on `imageUrl` when present. Never built from `imageKey`.
String? outfitPreviewImageUrl(Outfit outfit) {
  final url = outfit.render?.imageUrl?.trim();
  if (url == null || url.isEmpty) {
    return null;
  }
  return url;
}

/// Outfits-list leading: render preview when Backend returned a URL, else hanger.
class OutfitListPreview extends StatelessWidget {
  const OutfitListPreview({
    super.key,
    required this.outfit,
    this.width = 56,
    this.height = 72,
  });

  final Outfit outfit;
  final double width;
  final double height;

  static Key imageKey(String outfitId) => Key('outfit_list_preview_$outfitId');

  static Key hangerKey(String outfitId) => Key('outfit_list_hanger_$outfitId');

  static Key urlKey(String url) => Key('outfit_list_preview_url_$url');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = outfitPreviewImageUrl(outfit);

    final Widget child;
    if (url != null) {
      child = Image.network(
        url,
        key: urlKey(url),
        fit: BoxFit.contain,
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

    return SizedBox(
      key: url != null ? imageKey(outfit.id) : hangerKey(outfit.id),
      width: width,
      height: height,
      child: ColoredBox(color: scheme.primaryContainer, child: child),
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

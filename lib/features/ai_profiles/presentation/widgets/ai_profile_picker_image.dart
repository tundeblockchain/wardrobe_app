import 'package:flutter/material.dart';

import '../../domain/ai_profile.dart';

/// Burgundy/plum photo for an AI model or personal profile picker option.
///
/// Prefers the frontal GET URL from [AiProfile.pickerImageUrl] (`frontImageUrl`
/// / `front.*` via WARDROBE-71/73). Uses [BoxFit.cover] so the picture fills
/// the card (WARDROBE-76). Card sizes from WARDROBE-74 stay.
class AiProfilePickerImage extends StatelessWidget {
  const AiProfilePickerImage({super.key, required this.profile, this.radius});

  final AiProfile profile;

  /// Compact square slot. Null expands to fill the parent (card photo area).
  final double? radius;

  static Key imageKey(String id) => Key('ai_profile_picker_image_$id');

  static Key urlKey(String url) => Key('ai_profile_picker_url_$url');

  static Key placeholderKey(String id) =>
      Key('ai_profile_picker_placeholder_$id');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = profile.pickerImageUrl;
    final icon = profile.isGenericModel
        ? Icons.people_outline
        : Icons.person_outline;

    final Widget child;
    final Key sourceKey;
    if (url != null) {
      sourceKey = urlKey(url);
      child = Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return _Placeholder(
            icon: icon,
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
                width: 28,
                height: 28,
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
      sourceKey = placeholderKey(profile.id);
      child = _Placeholder(
        icon: icon,
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
      );
    }

    final photo = ColoredBox(
      color: scheme.primaryContainer,
      child: KeyedSubtree(key: sourceKey, child: child),
    );

    if (radius != null) {
      final side = radius! * 2;
      return SizedBox(
        key: imageKey(profile.id),
        width: side,
        height: side,
        child: photo,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded =
            constraints.hasBoundedWidth && constraints.hasBoundedHeight;
        if (bounded) {
          return SizedBox.expand(key: imageKey(profile.id), child: photo);
        }
        return SizedBox(
          key: imageKey(profile.id),
          width: constraints.hasBoundedWidth ? constraints.maxWidth : 120,
          height: 160,
          child: photo,
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background,
      child: Center(child: Icon(icon, color: foreground, size: 36)),
    );
  }
}

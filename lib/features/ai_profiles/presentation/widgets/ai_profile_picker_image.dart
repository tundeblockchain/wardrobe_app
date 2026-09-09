import 'package:flutter/material.dart';

import '../../domain/ai_profile.dart';

/// Burgundy/plum avatar for an AI model or personal profile picker option.
class AiProfilePickerImage extends StatelessWidget {
  const AiProfilePickerImage({
    super.key,
    required this.profile,
    this.radius = 28,
  });

  final AiProfile profile;
  final double radius;

  static Key imageKey(String id) => Key('ai_profile_picker_image_$id');

  static Key urlKey(String url) => Key('ai_profile_picker_url_$url');

  static Key placeholderKey(String id) =>
      Key('ai_profile_picker_placeholder_$id');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = profile.pickerImageUrl;
    final diameter = radius * 2;
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
        width: diameter,
        height: diameter,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: scheme.primaryContainer,
            child: Center(child: Icon(icon, color: scheme.onPrimaryContainer)),
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
                width: radius,
                height: radius,
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

    return SizedBox(
      key: imageKey(profile.id),
      width: diameter,
      height: diameter,
      child: ClipOval(
        child: KeyedSubtree(key: sourceKey, child: child),
      ),
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
      child: Center(child: Icon(icon, color: foreground)),
    );
  }
}

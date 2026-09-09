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
    if (url != null) {
      child = Image.network(
        url,
        key: urlKey(url),
        fit: BoxFit.cover,
        width: diameter,
        height: diameter,
        errorBuilder: (context, error, stackTrace) {
          return _Placeholder(
            profileId: profile.id,
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
      child = _Placeholder(
        profileId: profile.id,
        icon: icon,
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
      );
    }

    return SizedBox(
      key: imageKey(profile.id),
      width: diameter,
      height: diameter,
      child: ClipOval(child: child),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.profileId,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String profileId;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: AiProfilePickerImage.placeholderKey(profileId),
      color: background,
      child: Center(child: Icon(icon, color: foreground)),
    );
  }
}

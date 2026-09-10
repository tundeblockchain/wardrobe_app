import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Full-image lightbox for a clothing or try-on photo.
///
/// Cards crop with [BoxFit.cover]; this dialog uses [BoxFit.contain] so the
/// whole picture is visible. Burgundy/plum comes from the app color scheme.
class EnlargedImagePopup extends StatelessWidget {
  const EnlargedImagePopup({super.key, required this.image});

  final Widget image;

  static const dialogKey = Key('enlarged_image_popup');
  static const closeKey = Key('enlarged_image_popup_close');
  static const imageSlotKey = Key('enlarged_image_popup_image');

  static Future<void> show(BuildContext context, {required Widget image}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (context) => EnlargedImagePopup(image: image),
    );
  }

  static Future<void> showNetwork(BuildContext context, {required String url}) {
    return show(
      context,
      image: Image.network(
        url,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          final scheme = Theme.of(context).colorScheme;
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      key: dialogKey,
      backgroundColor: scheme.surface,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width,
          maxHeight: size.height * 0.86,
        ),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: scheme.primaryContainer,
                child: KeyedSubtree(key: imageSlotKey, child: image),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: IconButton.filledTonal(
                  key: closeKey,
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'destructive_confirm_dialog.dart';

/// Shared confirm copy and error handling for wardrobe / item / outfit deletes.
abstract final class EntityDelete {
  static const wardrobeTitle = 'Delete wardrobe?';
  static const wardrobeMessage =
      'This permanently deletes this wardrobe and all of its items, '
      'outfits, and photos. This cannot be undone.';
  static const wardrobeError = 'Could not delete this wardrobe.';

  static const itemTitle = 'Delete item?';
  static const itemMessage =
      'This permanently deletes this clothing item and its photos. '
      'This cannot be undone.';
  static const itemError = 'Could not delete this item.';

  static const outfitTitle = 'Delete outfit?';
  static const outfitMessage =
      'This permanently deletes this outfit. This cannot be undone.';
  static const outfitError = 'Could not delete this outfit.';

  /// Confirms, runs [action], and shows a snackbar when the delete fails.
  static Future<bool> confirmAndRun(
    BuildContext context, {
    required String title,
    required String message,
    required Future<bool> Function() action,
    required String fallbackError,
    String? Function()? errorMessage,
  }) async {
    final confirmed = await DestructiveConfirmDialog.show(
      context,
      title: title,
      message: message,
    );
    if (!confirmed) {
      return false;
    }
    final ok = await action();
    if (ok || !context.mounted) {
      return ok;
    }
    final text = errorMessage?.call() ?? fallbackError;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    return false;
  }
}

/// Trash icon used on cards and list rows.
class EntityDeleteIconButton extends StatelessWidget {
  const EntityDeleteIconButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.overlay = false,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final bool overlay;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final button = IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(Icons.delete_outline, color: scheme.error),
    );
    if (!overlay) {
      return button;
    }
    return Material(
      color: scheme.surface.withValues(alpha: 0.88),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: button,
    );
  }
}

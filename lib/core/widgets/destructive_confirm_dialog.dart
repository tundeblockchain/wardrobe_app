import 'package:flutter/material.dart';

/// Shared confirm sheet for wardrobe / item / outfit / account deletes.
class DestructiveConfirmDialog extends StatelessWidget {
  const DestructiveConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Delete',
  });

  final String title;
  final String message;
  final String confirmLabel;

  static const cancelButtonKey = Key('destructive_confirm_cancel');
  static const confirmButtonKey = Key('destructive_confirm_confirm');

  /// Returns `true` when the user confirms.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Delete',
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return DestructiveConfirmDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
        );
      },
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          key: cancelButtonKey,
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: confirmButtonKey,
          style: FilledButton.styleFrom(
            backgroundColor: errorColor,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

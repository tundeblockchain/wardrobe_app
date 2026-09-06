import 'package:flutter/material.dart';

/// Type-the-phrase confirm for irreversible account actions.
class TypeToConfirmDialog extends StatefulWidget {
  const TypeToConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.phrase,
    this.confirmLabel = 'Delete',
    this.fieldLabel,
  });

  final String title;
  final String message;
  final String phrase;
  final String confirmLabel;
  final String? fieldLabel;

  static const cancelButtonKey = Key('type_to_confirm_cancel');
  static const confirmButtonKey = Key('type_to_confirm_confirm');
  static const phraseFieldKey = Key('type_to_confirm_phrase');

  /// Returns `true` when the typed phrase matches and the user confirms.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String phrase,
    String confirmLabel = 'Delete',
    String? fieldLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return TypeToConfirmDialog(
          title: title,
          message: message,
          phrase: phrase,
          confirmLabel: confirmLabel,
          fieldLabel: fieldLabel,
        );
      },
    );
    return confirmed == true;
  }

  @override
  State<TypeToConfirmDialog> createState() => _TypeToConfirmDialogState();
}

class _TypeToConfirmDialogState extends State<TypeToConfirmDialog> {
  late final TextEditingController _controller;

  bool get _matches =>
      _controller.text.trim().toUpperCase() == widget.phrase.toUpperCase();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.message),
          const SizedBox(height: 16),
          Text('Type ${widget.phrase} to confirm.'),
          const SizedBox(height: 12),
          TextField(
            key: TypeToConfirmDialog.phraseFieldKey,
            controller: _controller,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: widget.fieldLabel ?? widget.phrase,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: TypeToConfirmDialog.cancelButtonKey,
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: TypeToConfirmDialog.confirmButtonKey,
          style: FilledButton.styleFrom(
            backgroundColor: errorColor,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: _matches ? () => Navigator.of(context).pop(true) : null,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

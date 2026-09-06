import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../application/edit_outfit_controller.dart';
import '../application/outfit_detail_controller.dart';
import '../application/outfit_scope.dart';
import '../domain/outfit_validators.dart';
import 'widgets/outfit_slot_picker.dart';

/// Edit outfit name and slot assignments.
class EditOutfitScreen extends ConsumerStatefulWidget {
  const EditOutfitScreen({
    super.key,
    required this.wardrobeId,
    required this.outfitId,
  });

  final String wardrobeId;
  final String outfitId;

  static const nameFieldKey = Key('edit_outfit_name');
  static const submitButtonKey = Key('edit_outfit_submit');

  @override
  ConsumerState<EditOutfitScreen> createState() => _EditOutfitScreenState();
}

class _EditOutfitScreenState extends ConsumerState<EditOutfitScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  var _nameSeeded = false;

  OutfitScope get _scope =>
      OutfitScope(wardrobeId: widget.wardrobeId, outfitId: widget.outfitId);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _seedName(String? name) {
    if (_nameSeeded || name == null) {
      return;
    }
    _nameController.text = name;
    _nameSeeded = true;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final updated = await ref
        .read(editOutfitControllerProvider(_scope).notifier)
        .submit(name: _nameController.text);
    if (updated != null && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(outfitDetailControllerProvider(_scope));
    final state = ref.watch(editOutfitControllerProvider(_scope));
    ref.listen(outfitDetailControllerProvider(_scope), (previous, next) {
      _seedName(next.outfit?.name);
    });
    if (!_nameSeeded && detail.outfit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _seedName(detail.outfit?.name);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit outfit')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: AppSpacing.pageInsets,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      key: EditOutfitScreen.nameFieldKey,
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: OutfitValidators.maxNameLength,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: OutfitValidators.name,
                      enabled: !state.isSaving,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Slots',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    OutfitSlotPicker(
                      wardrobeId: widget.wardrobeId,
                      assignments: state.items,
                      enabled: !state.isSaving,
                      onAssign: (slot, itemId) => ref
                          .read(editOutfitControllerProvider(_scope).notifier)
                          .assign(slot: slot, itemId: itemId),
                      onClear: (slot) => ref
                          .read(editOutfitControllerProvider(_scope).notifier)
                          .clearSlot(slot),
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      key: EditOutfitScreen.submitButtonKey,
                      onPressed: state.isSaving ? null : _submit,
                      child: state.isSaving
                          ? const AppButtonSpinner()
                          : const Text('Save changes'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

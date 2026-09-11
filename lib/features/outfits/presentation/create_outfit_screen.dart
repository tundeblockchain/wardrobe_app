import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../items/application/items_controller.dart';
import '../application/create_outfit_controller.dart';
import '../domain/outfit_validators.dart';
import 'widgets/outfit_slot_picker.dart';
import '../../../core/widgets/app_gloss.dart';

/// Name plus slot assignments that create an outfit from wardrobe items.
class CreateOutfitScreen extends ConsumerStatefulWidget {
  const CreateOutfitScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const nameFieldKey = Key('create_outfit_name');
  static const submitButtonKey = Key('create_outfit_submit');

  @override
  ConsumerState<CreateOutfitScreen> createState() => _CreateOutfitScreenState();
}

class _CreateOutfitScreenState extends ConsumerState<CreateOutfitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final created = await ref
        .read(createOutfitControllerProvider(widget.wardrobeId).notifier)
        .submit(name: _nameController.text);
    if (created != null && mounted) {
      context.go(AppRoutes.outfitDetail(widget.wardrobeId, created.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createOutfitControllerProvider(widget.wardrobeId));
    final itemsState = ref.watch(itemsControllerProvider(widget.wardrobeId));

    return Scaffold(
      appBar: AppGlossBar(title: const Text('Create outfit')),
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
                    Text(
                      'Name this look and pick items into slots.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: CreateOutfitScreen.nameFieldKey,
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      autofocus: true,
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
                    if (itemsState.isEmpty && !itemsState.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Add clothing items to this wardrobe before building an outfit.',
                        ),
                      ),
                    OutfitSlotPicker(
                      wardrobeId: widget.wardrobeId,
                      assignments: state.items,
                      enabled: !state.isSaving,
                      onAssign: (slot, itemId) => ref
                          .read(
                            createOutfitControllerProvider(widget.wardrobeId)
                                .notifier,
                          )
                          .assign(slot: slot, itemId: itemId),
                      onClear: (slot) => ref
                          .read(
                            createOutfitControllerProvider(widget.wardrobeId)
                                .notifier,
                          )
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
                      key: CreateOutfitScreen.submitButtonKey,
                      onPressed: state.isSaving ? null : _submit,
                      child: state.isSaving
                          ? const AppButtonSpinner()
                          : const Text('Save outfit'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/edit_item_controller.dart';
import '../application/item_detail_controller.dart';
import '../application/item_scope.dart';
import '../domain/item.dart';
import '../domain/item_validators.dart';

/// Edit clothing metadata and optionally replace the photo.
class EditItemScreen extends ConsumerStatefulWidget {
  const EditItemScreen({
    super.key,
    required this.wardrobeId,
    required this.itemId,
  });

  final String wardrobeId;
  final String itemId;

  static const nameFieldKey = Key('edit_item_name');
  static const submitButtonKey = Key('edit_item_submit');

  @override
  ConsumerState<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subcategoryController = TextEditingController();
  final _coloursController = TextEditingController();
  final _brandController = TextEditingController();
  ItemCategory? _category;
  var _didPrefill = false;

  ItemScope get _scope =>
      ItemScope(wardrobeId: widget.wardrobeId, itemId: widget.itemId);

  @override
  void dispose() {
    _nameController.dispose();
    _subcategoryController.dispose();
    _coloursController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  void _prefill(Item item) {
    if (_didPrefill) {
      return;
    }
    _didPrefill = true;
    _nameController.text = item.name;
    _subcategoryController.text = item.subcategory ?? '';
    _coloursController.text = item.colours.join(', ');
    _brandController.text = item.brand ?? '';
    _category = item.category;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final updated = await ref
        .read(editItemControllerProvider(_scope).notifier)
        .submit(
          name: _nameController.text,
          category: _category!,
          subcategory: _subcategoryController.text,
          colours: ItemValidators.parseColours(_coloursController.text),
          brand: _brandController.text,
        );
    if (updated != null && mounted) {
      context.go(AppRoutes.itemDetail(widget.wardrobeId, updated.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(itemDetailControllerProvider(_scope));
    final state = ref.watch(editItemControllerProvider(_scope));
    final item = detail.item;
    if (item != null) {
      _prefill(item);
    }
    final busy = state.isPicking || state.isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit item')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: item == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: busy
                                      ? null
                                      : () => ref
                                            .read(
                                              editItemControllerProvider(_scope)
                                                  .notifier,
                                            )
                                            .pickFromCamera(),
                                  icon: const Icon(Icons.photo_camera_outlined),
                                  label: const Text('New photo'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: busy
                                      ? null
                                      : () => ref
                                            .read(
                                              editItemControllerProvider(_scope)
                                                  .notifier,
                                            )
                                            .pickFromGallery(),
                                  icon: const Icon(
                                    Icons.photo_library_outlined,
                                  ),
                                  label: const Text('Gallery'),
                                ),
                              ),
                            ],
                          ),
                          if (state.replacementImage != null) ...[
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                state.replacementImage!.bytes,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          TextFormField(
                            key: EditItemScreen.nameFieldKey,
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            maxLength: ItemValidators.maxNameLength,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: ItemValidators.name,
                            enabled: !busy,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<ItemCategory>(
                            initialValue: _category,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              for (final category in ItemCategory.values)
                                DropdownMenuItem(
                                  value: category,
                                  child: Text(category.label),
                                ),
                            ],
                            onChanged: busy
                                ? null
                                : (value) => setState(() => _category = value),
                            validator: ItemValidators.category,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _subcategoryController,
                            maxLength: ItemValidators.maxSubcategoryLength,
                            decoration: const InputDecoration(
                              labelText: 'Subcategory (optional)',
                              border: OutlineInputBorder(),
                            ),
                            validator: ItemValidators.subcategory,
                            enabled: !busy,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _coloursController,
                            decoration: const InputDecoration(
                              labelText: 'Colours (optional)',
                              hintText: 'black, white',
                              border: OutlineInputBorder(),
                            ),
                            enabled: !busy,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _brandController,
                            maxLength: ItemValidators.maxBrandLength,
                            decoration: const InputDecoration(
                              labelText: 'Brand (optional)',
                              border: OutlineInputBorder(),
                            ),
                            validator: ItemValidators.brand,
                            enabled: !busy,
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
                            key: EditItemScreen.submitButtonKey,
                            onPressed: busy ? null : _submit,
                            child: state.isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
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

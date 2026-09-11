import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../application/edit_item_controller.dart';
import '../application/item_detail_controller.dart';
import '../application/item_scope.dart';
import '../domain/item.dart';
import '../domain/item_subcategory_patch.dart';
import '../domain/item_taxonomy.dart';
import '../domain/item_validators.dart';
import 'widgets/item_subcategory_field.dart';

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
  static const subcategoryFieldKey = ItemSubcategoryField.fieldKey;

  @override
  ConsumerState<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _coloursController = TextEditingController();
  final _brandController = TextEditingController();
  ItemCategory? _category;
  String? _subcategory;
  String? _originalSubcategory;
  var _didPrefill = false;

  ItemScope get _scope =>
      ItemScope(wardrobeId: widget.wardrobeId, itemId: widget.itemId);

  @override
  void dispose() {
    _nameController.dispose();
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
    _subcategory = ItemSubcategoryPatch.normalize(item.subcategory);
    _originalSubcategory = _subcategory;
    _coloursController.text = item.colours.join(', ');
    _brandController.text = item.brand ?? '';
    _category = item.category;
  }

  void _onCategoryChanged(ItemCategory? value) {
    setState(() {
      _category = value;
      final allowed = value == null
          ? const <String>{}
          : {
              for (final option in ItemSubcategory.forCategory(value))
                option.wireValue,
            };
      if (_subcategory != null && !allowed.contains(_subcategory)) {
        _subcategory = null;
      }
    });
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
          subcategory: ItemSubcategoryPatch.fromEdit(
            original: _originalSubcategory,
            edited: _subcategory,
          ),
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
                    padding: AppSpacing.pageInsets,
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
                            ),
                            validator: ItemValidators.name,
                            enabled: !busy,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<ItemCategory>(
                            initialValue: _category,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                            items: [
                              for (final category in ItemCategory.values)
                                DropdownMenuItem(
                                  value: category,
                                  child: Text(category.label),
                                ),
                            ],
                            onChanged: busy ? null : _onCategoryChanged,
                            validator: ItemValidators.category,
                          ),
                          const SizedBox(height: 16),
                          ItemSubcategoryField(
                            category: _category,
                            value: _subcategory,
                            enabled: !busy,
                            onChanged: (value) =>
                                setState(() => _subcategory = value),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _coloursController,
                            decoration: const InputDecoration(
                              labelText: 'Colours (optional)',
                              hintText: 'black, white',
                            ),
                            enabled: !busy,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _brandController,
                            maxLength: ItemValidators.maxBrandLength,
                            decoration: const InputDecoration(
                              labelText: 'Brand (optional)',
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

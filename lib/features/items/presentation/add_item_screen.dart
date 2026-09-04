import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/add_item_controller.dart';
import '../domain/item.dart';
import '../domain/item_validators.dart';

/// Camera / gallery pick, then metadata form that uploads and creates the item.
class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const cameraButtonKey = Key('add_item_camera');
  static const galleryButtonKey = Key('add_item_gallery');
  static const nameFieldKey = Key('add_item_name');
  static const categoryFieldKey = Key('add_item_category');
  static const submitButtonKey = Key('add_item_submit');

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subcategoryController = TextEditingController();
  final _coloursController = TextEditingController();
  final _brandController = TextEditingController();
  ItemCategory? _category;

  @override
  void dispose() {
    _nameController.dispose();
    _subcategoryController.dispose();
    _coloursController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final created = await ref
        .read(addItemControllerProvider(widget.wardrobeId).notifier)
        .submit(
          name: _nameController.text,
          category: _category!,
          subcategory: _subcategoryController.text,
          colours: ItemValidators.parseColours(_coloursController.text),
          brand: _brandController.text,
        );
    if (created != null && mounted) {
      context.go(AppRoutes.itemDetail(widget.wardrobeId, created.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addItemControllerProvider(widget.wardrobeId));
    final busy = state.isPicking || state.isSubmitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Add item')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Photograph a clothing item or choose one from your gallery.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            key: AddItemScreen.cameraButtonKey,
                            onPressed: busy
                                ? null
                                : () => ref
                                      .read(
                                        addItemControllerProvider(
                                          widget.wardrobeId,
                                        ).notifier,
                                      )
                                      .pickFromCamera(),
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: const Text('Camera'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            key: AddItemScreen.galleryButtonKey,
                            onPressed: busy
                                ? null
                                : () => ref
                                      .read(
                                        addItemControllerProvider(
                                          widget.wardrobeId,
                                        ).notifier,
                                      )
                                      .pickFromGallery(),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Gallery'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state.pickedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          state.pickedImage!.bytes,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 160,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: const Text('No photo selected'),
                      ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: AddItemScreen.nameFieldKey,
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
                      key: AddItemScreen.categoryFieldKey,
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
                      textCapitalization: TextCapitalization.characters,
                      maxLength: ItemValidators.maxSubcategoryLength,
                      decoration: const InputDecoration(
                        labelText: 'Subcategory (optional)',
                        hintText: 'T-shirt, jeans…',
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
                      textCapitalization: TextCapitalization.words,
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
                    if (state.progressLabel != null) ...[
                      const SizedBox(height: 8),
                      Text(state.progressLabel!),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      key: AddItemScreen.submitButtonKey,
                      onPressed: busy ? null : _submit,
                      child: state.isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save item'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../entitlements/domain/entitlement_action.dart';
import '../../entitlements/presentation/entitlement_guard.dart';
import '../../search/presentation/app_search_gloss_bar.dart';
import '../application/add_item_controller.dart';
import '../application/add_item_state.dart';
import '../domain/add_item_initial_pick.dart';
import '../domain/item.dart';
import '../domain/item_taxonomy.dart';
import '../domain/picked_image.dart';
import '../domain/item_validators.dart';
import 'widgets/item_acquired_at_field.dart';
import 'widgets/item_subcategory_field.dart';

/// Camera / gallery pick, then metadata form that uploads and creates the item.
class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key, required this.wardrobeId, this.initialPick});

  final String wardrobeId;
  final AddItemInitialPick? initialPick;

  static const cameraButtonKey = Key('add_item_camera');
  static const galleryButtonKey = Key('add_item_gallery');
  static const nameFieldKey = Key('add_item_name');
  static const categoryFieldKey = Key('add_item_category');
  static const submitButtonKey = Key('add_item_submit');
  static const batchStripKey = Key('add_item_batch_strip');
  static const batchResultKey = Key('add_item_batch_result');
  static const doneButtonKey = Key('add_item_batch_done');
  static const subcategoryFieldKey = ItemSubcategoryField.fieldKey;
  static const acquiredAtFieldKey = ItemAcquiredAtField.fieldKey;

  static Key batchNameFieldKey(int index) => Key('add_item_batch_name_$index');

  static Key batchResultRowKey(int index) =>
      Key('add_item_batch_result_$index');

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _coloursController = TextEditingController();
  final _brandController = TextEditingController();
  ItemCategory? _category;
  String? _subcategory;
  DateTime? _acquiredAt;
  var _didAutoPick = false;

  @override
  void initState() {
    super.initState();
    final pick = widget.initialPick;
    if (pick != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _didAutoPick) {
          return;
        }
        _didAutoPick = true;
        final notifier = ref.read(
          addItemControllerProvider(widget.wardrobeId).notifier,
        );
        switch (pick) {
          case AddItemInitialPick.gallery:
            notifier.pickFromGallery();
          case AddItemInitialPick.camera:
            notifier.pickFromCamera();
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _coloursController.dispose();
    _brandController.dispose();
    super.dispose();
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
    final allowed = await ensureEntitled(
      context,
      ref,
      EntitlementAction.createItem,
      wardrobeId: widget.wardrobeId,
    );
    if (!allowed || !mounted) {
      return;
    }
    final notifier = ref.read(
      addItemControllerProvider(widget.wardrobeId).notifier,
    );
    final state = ref.read(addItemControllerProvider(widget.wardrobeId));
    if (state.isBatch) {
      final outcome = await notifier.submitBatch(
        category: _category!,
        subcategory: _subcategory,
        colours: ItemValidators.parseColours(_coloursController.text),
        brand: _brandController.text,
        acquiredAt: _acquiredAt,
      );
      if (outcome != null && outcome.allSucceeded && mounted) {
        context.go(AppRoutes.wardrobeDetail(widget.wardrobeId));
      }
      return;
    }
    final created = await notifier.submit(
      name: _nameController.text,
      category: _category!,
      subcategory: _subcategory,
      colours: ItemValidators.parseColours(_coloursController.text),
      brand: _brandController.text,
      acquiredAt: _acquiredAt,
    );
    if (created != null && mounted) {
      context.go(AppRoutes.itemDetail(widget.wardrobeId, created.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addItemControllerProvider(widget.wardrobeId));
    final busy = state.isPicking || state.isSubmitting;
    final batchDone = state.batchResults.isNotEmpty && !state.isSubmitting;

    return Scaffold(
      appBar: AppSearchGlossBar(title: const Text('Add item')),
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
                      'Photograph a clothing item or pick several from your gallery.',
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
                    if (state.isBatch)
                      _BatchPhotoStrip(images: state.pickedImages)
                    else if (state.pickedImage != null)
                      ClipRRect(
                        borderRadius: AppRadii.card,
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
                          borderRadius: AppRadii.card,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerLow,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: const Text('No photo selected'),
                      ),
                    const SizedBox(height: 24),
                    if (state.isBatch)
                      _BatchNameFields(
                        names: state.itemNames,
                        enabled: !busy,
                        onChanged: (index, value) {
                          ref
                              .read(
                                addItemControllerProvider(widget.wardrobeId)
                                    .notifier,
                              )
                              .setItemName(index, value);
                        },
                      )
                    else
                      TextFormField(
                        key: AddItemScreen.nameFieldKey,
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        maxLength: ItemValidators.maxNameLength,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: ItemValidators.name,
                        enabled: !busy,
                      ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ItemCategory>(
                      key: AddItemScreen.categoryFieldKey,
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
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
                    ItemAcquiredAtField(
                      value: _acquiredAt,
                      enabled: !busy,
                      onChanged: (value) => setState(() => _acquiredAt = value),
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
                      textCapitalization: TextCapitalization.words,
                      maxLength: ItemValidators.maxBrandLength,
                      decoration: const InputDecoration(
                        labelText: 'Brand (optional)',
                      ),
                      validator: ItemValidators.brand,
                      enabled: !busy,
                    ),
                    if (state.batchResults.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _BatchResults(results: state.batchResults),
                    ],
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: state.batchResults.any((r) => r.failed)
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                    if (state.progressLabel != null) ...[
                      const SizedBox(height: 8),
                      Text(state.progressLabel!),
                    ],
                    const SizedBox(height: 24),
                    ..._actionButtons(state, busy, batchDone),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _actionButtons(AddItemState state, bool busy, bool batchDone) {
    final hasSuccesses = state.batchResults.any((result) => result.succeeded);
    final hasFailures = state.batchResults.any((result) => result.failed);
    if (batchDone && hasSuccesses) {
      return [
        FilledButton(
          key: AddItemScreen.doneButtonKey,
          onPressed: () =>
              context.go(AppRoutes.wardrobeDetail(widget.wardrobeId)),
          child: const Text('Done'),
        ),
        if (hasFailures) ...[
          const SizedBox(height: 12),
          OutlinedButton(
            key: AddItemScreen.submitButtonKey,
            onPressed: busy ? null : _submit,
            child: const Text('Retry failed'),
          ),
        ],
      ];
    }
    return [
      FilledButton(
        key: AddItemScreen.submitButtonKey,
        onPressed: busy ? null : _submit,
        child: state.isSubmitting
            ? const AppButtonSpinner()
            : Text(
                state.isBatch
                    ? (hasFailures
                          ? 'Retry failed'
                          : 'Save ${state.pickedImages.length} items')
                    : 'Save item',
              ),
      ),
    ];
  }
}

class _BatchPhotoStrip extends StatelessWidget {
  const _BatchPhotoStrip({required this.images});

  final List<PickedImage> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: AddItemScreen.batchStripKey,
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: AppRadii.card,
            child: Image.memory(
              images[index].bytes,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

class _BatchNameFields extends StatelessWidget {
  const _BatchNameFields({
    required this.names,
    required this.enabled,
    required this.onChanged,
  });

  final List<String> names;
  final bool enabled;
  final void Function(int index, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(names.length),
      children: [
        for (var i = 0; i < names.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          TextFormField(
            key: AddItemScreen.batchNameFieldKey(i),
            initialValue: names[i],
            textCapitalization: TextCapitalization.words,
            maxLength: ItemValidators.maxNameLength,
            decoration: InputDecoration(labelText: 'Name ${i + 1}'),
            validator: ItemValidators.name,
            enabled: enabled,
            onChanged: (value) => onChanged(i, value),
          ),
        ],
      ],
    );
  }
}

class _BatchResults extends StatelessWidget {
  const _BatchResults({required this.results});

  final List<BatchItemResult> results;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      key: AddItemScreen.batchResultKey,
      children: [
        for (final result in results)
          ListTile(
            key: AddItemScreen.batchResultRowKey(result.index),
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              result.succeeded
                  ? Icons.check_circle_outline
                  : Icons.error_outline,
              color: result.succeeded ? scheme.primary : scheme.error,
            ),
            title: Text(result.item?.name ?? result.displayName),
            subtitle: Text(result.succeeded ? 'Saved' : result.errorMessage!),
          ),
      ],
    );
  }
}

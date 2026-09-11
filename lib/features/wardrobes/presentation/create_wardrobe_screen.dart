import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../application/wardrobes_controller.dart';
import '../domain/wardrobe_validators.dart';
import '../../../core/widgets/app_gloss.dart';

/// Form to create a wardrobe by name.
class CreateWardrobeScreen extends ConsumerStatefulWidget {
  const CreateWardrobeScreen({super.key});

  static const nameFieldKey = Key('create_wardrobe_name');
  static const submitButtonKey = Key('create_wardrobe_submit');

  @override
  ConsumerState<CreateWardrobeScreen> createState() =>
      _CreateWardrobeScreenState();
}

class _CreateWardrobeScreenState extends ConsumerState<CreateWardrobeScreen> {
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
        .read(createWardrobeControllerProvider.notifier)
        .submit(name: _nameController.text);
    if (created != null && mounted) {
      context.go(AppRoutes.wardrobeDetail(created.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createWardrobeControllerProvider);

    return Scaffold(
      appBar: AppGlossBar(title: const Text('Create wardrobe')),
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
                      'Give this wardrobe a name.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      key: CreateWardrobeScreen.nameFieldKey,
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      autofocus: true,
                      maxLength: WardrobeValidators.maxNameLength,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: WardrobeValidators.name,
                      enabled: !state.isSaving,
                      onFieldSubmitted: (_) => _submit(),
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
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      key: CreateWardrobeScreen.submitButtonKey,
                      onPressed: state.isSaving ? null : _submit,
                      child: state.isSaving
                          ? const AppButtonSpinner()
                          : const Text('Create'),
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

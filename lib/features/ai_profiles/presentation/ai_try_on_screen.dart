import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/destructive_confirm_dialog.dart';
import '../application/generic_models_controller.dart';
import '../application/generic_models_state.dart';
import '../application/personal_ai_profiles_controller.dart';
import '../application/personal_ai_profiles_state.dart';
import '../application/selected_ai_profile.dart';
import '../domain/ai_profile.dart';
import 'widgets/ai_profile_picker_image.dart';
import 'widgets/generic_model_card.dart';
import 'widgets/personal_ai_profile_card.dart';

/// Phase-3 hub: manage a PERSONAL AI profile and pick a GENERIC_MODEL look.
///
/// Selection is stored in [selectedAiProfileIdProvider] for the dressing room.
class AiTryOnScreen extends ConsumerWidget {
  const AiTryOnScreen({super.key});

  static const screenKey = Key('ai_try_on_screen');
  static const createButtonKey = Key('ai_try_on_create_personal');
  static const retryPersonalKey = Key('ai_try_on_retry_personal');
  static const retryModelsKey = Key('ai_try_on_retry_models');
  static const selectedBannerKey = Key('ai_try_on_selected_banner');
  static const comingSoonKey = Key('ai_try_on_coming_soon');
  static const personalEmptyKey = Key('ai_try_on_personal_empty');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personal = ref.watch(personalAiProfilesControllerProvider);
    final models = ref.watch(genericModelsControllerProvider);
    final selected = ref.watch(selectedAiProfileProvider);

    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: const Text('AI try-on')),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(personalAiProfilesControllerProvider.notifier).refresh(),
            ref.read(genericModelsControllerProvider.notifier).refresh(),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pageInsets,
          children: [
            Text(
              'Create a personal look from your photos, or pick a model for try-on.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (selected != null) ...[
              const SizedBox(height: AppSpacing.md),
              _SelectedBanner(profile: selected),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Your AI profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Upload full-body reference photos. The app uses the same Photo '
              'Picker path as adding a clothing item.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _PersonalSection(personal: personal, selectedId: selected?.id),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Try-on models',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Pick a generic look for virtual try-on.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _ModelsSection(models: models, selectedId: selected?.id),
            const SizedBox(height: AppSpacing.lg),
            Text(
              key: comingSoonKey,
              'Open a wardrobe outfit and tap Try on.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedBanner extends ConsumerWidget {
  const _SelectedBanner({required this.profile});

  final AiProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: AiTryOnScreen.selectedBannerKey,
      color: scheme.primaryContainer,
      child: ListTile(
        leading: SizedBox(
          width: 56,
          height: 72,
          child: AiProfilePickerImage(profile: profile),
        ),
        minLeadingWidth: 56,
        title: Text('Selected: ${profile.displayName}'),
        subtitle: Text(
          profile.isGenericModel ? 'Generic model' : 'Personal profile',
        ),
        trailing: IconButton(
          tooltip: 'Clear selection',
          onPressed: () => ref.read(selectedAiProfileProvider.notifier).clear(),
          icon: const Icon(Icons.close),
        ),
      ),
    );
  }
}

class _PersonalSection extends ConsumerWidget {
  const _PersonalSection({required this.personal, required this.selectedId});

  final PersonalAiProfilesState personal;
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(personalAiProfilesControllerProvider.notifier);

    if (personal.isLoading && personal.profiles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (personal.errorMessage != null && personal.profiles.isEmpty) {
      return AppErrorState(
        message: personal.errorMessage!,
        retryKey: AiTryOnScreen.retryPersonalKey,
        onRetry: controller.refresh,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (personal.errorMessage != null) ...[
          Text(
            personal.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (personal.isEmpty)
          const AppEmptyState(
            key: AiTryOnScreen.personalEmptyKey,
            icon: Icons.face_retouching_natural_outlined,
            title: 'No personal profile yet',
            message: 'Create one, then add reference photos so try-on can use your look.',
          )
        else
          for (final profile in personal.profiles) ...[
            PersonalAiProfileCard(
              profile: profile,
              selected: selectedId == profile.id,
              busy: personal.isBusy,
              uploading: personal.uploadingProfileId == profile.id,
              deleting: personal.deletingProfileId == profile.id,
              onSelect: () =>
                  ref.read(selectedAiProfileProvider.notifier).select(profile),
              onCamera: () => controller.pickFromCamera(profile.id),
              onGallery: () => controller.pickFromGallery(profile.id),
              onDelete: () => _delete(context, ref, profile),
              onEditBody: () =>
                  context.push(AppRoutes.aiProfileBody(profile.id)),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        FilledButton.icon(
          key: AiTryOnScreen.createButtonKey,
          onPressed: personal.isBusy ? null : controller.createPersonal,
          icon: personal.isCreating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add),
          label: Text(
            personal.isEmpty
                ? 'Create personal profile'
                : 'Add another profile',
          ),
        ),
      ],
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    AiProfile profile,
  ) async {
    final confirmed = await DestructiveConfirmDialog.show(
      context,
      title: 'Delete this AI profile?',
      message:
          'This removes your personal AI profile and its reference photos. '
          'Generic models are not affected.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) {
      return;
    }
    await ref
        .read(personalAiProfilesControllerProvider.notifier)
        .deletePersonal(profile.id);
  }
}

class _ModelsSection extends ConsumerWidget {
  const _ModelsSection({required this.models, required this.selectedId});

  final GenericModelsState models;
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(genericModelsControllerProvider.notifier);

    if (models.isLoading && models.models.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (models.errorMessage != null && models.models.isEmpty) {
      return AppErrorState(
        message: models.errorMessage!,
        retryKey: AiTryOnScreen.retryModelsKey,
        onRetry: controller.refresh,
      );
    }
    if (models.isEmpty) {
      return const AppEmptyState(
        icon: Icons.people_outline,
        title: 'No models yet',
        message:
            'Generic try-on models will appear here when the catalog is live.',
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: models.models.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        final profile = models.models[index];
        return GenericModelCard(
          profile: profile,
          selected: selectedId == profile.id,
          onSelect: () =>
              ref.read(selectedAiProfileProvider.notifier).select(profile),
        );
      },
    );
  }
}

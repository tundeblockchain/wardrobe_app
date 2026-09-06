import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../ai_profiles/application/generic_models_controller.dart';
import '../../ai_profiles/application/personal_ai_profiles_controller.dart';
import '../../ai_profiles/application/selected_ai_profile.dart';
import '../../ai_profiles/domain/ai_profile.dart';
import '../../outfits/application/outfit_scope.dart';
import '../../outfits/domain/outfit.dart';
import '../application/try_on_controller.dart';
import '../application/try_on_state.dart';
import 'widgets/try_on_result_image.dart';
import 'widgets/try_on_status_banner.dart';

/// Outfit-scoped virtual try-on: pick a READY profile, POST, poll, show image.
class TryOnScreen extends ConsumerWidget {
  const TryOnScreen({
    super.key,
    required this.wardrobeId,
    required this.outfitId,
  });

  final String wardrobeId;
  final String outfitId;

  static const screenKey = Key('try_on_screen');
  static const submitButtonKey = Key('try_on_submit');
  static const retryButtonKey = Key('try_on_retry');
  static const chooseProfileButtonKey = Key('try_on_choose_profile');
  static const profileEmptyKey = Key('try_on_profile_empty');
  static const selectedProfileKey = Key('try_on_selected_profile');

  OutfitScope get _scope =>
      OutfitScope(wardrobeId: wardrobeId, outfitId: outfitId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tryOnControllerProvider(_scope));
    final selected = ref.watch(selectedAiProfileProvider);
    final personal = ref.watch(personalAiProfilesControllerProvider);
    final models = ref.watch(genericModelsControllerProvider);
    final outfit = state.outfit;
    final readyProfiles = [
      ...personal.profiles.where((profile) => profile.canUseForTryOn),
      ...models.models.where((profile) => profile.canUseForTryOn),
    ];

    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: Text(outfit?.name ?? 'Try on')),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(tryOnControllerProvider(_scope).notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pageInsets,
          children: [_buildBody(context, ref, state, selected, readyProfiles)],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TryOnState state,
    AiProfile? selected,
    List<AiProfile> readyProfiles,
  ) {
    if (state.isLoading && state.outfit == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.outfit == null) {
      return AppErrorState(
        message: state.errorMessage ?? 'Outfit not found.',
        retryKey: retryButtonKey,
        onRetry: () =>
            ref.read(tryOnControllerProvider(_scope).notifier).refresh(),
      );
    }

    final outfit = state.outfit!;
    final blocked = tryOnBlockReason(selected);
    final canSubmit = blocked == null && !state.isBusy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(outfit.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(_slotLabel(outfit)),
        const SizedBox(height: AppSpacing.lg),
        Text('AI profile', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        if (selected == null)
          AppEmptyState(
            key: profileEmptyKey,
            icon: Icons.face_retouching_natural_outlined,
            title: 'No profile selected',
            message:
                'Pick a ready personal look or a try-on model, then render '
                'this outfit.',
            actionLabel: 'Choose profile',
            actionKey: chooseProfileButtonKey,
            onAction: () => context.push(AppRoutes.aiTryOn),
          )
        else
          Card(
            key: selectedProfileKey,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              leading: Icon(
                selected.isGenericModel
                    ? Icons.people_outline
                    : Icons.person_outline,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              title: Text(selected.displayName),
              subtitle: Text(
                selected.isGenericModel
                    ? 'Generic model · ${selected.status.label}'
                    : 'Personal profile · ${selected.status.label}',
              ),
              trailing: TextButton(
                key: chooseProfileButtonKey,
                onPressed: () => context.push(AppRoutes.aiTryOn),
                child: const Text('Change'),
              ),
            ),
          ),
        if (readyProfiles.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final profile in readyProfiles)
                FilterChip(
                  key: Key('try_on_profile_chip_${profile.id}'),
                  selected: selected?.id == profile.id,
                  label: Text(profile.displayName),
                  onSelected: (_) => ref
                      .read(selectedAiProfileProvider.notifier)
                      .select(profile),
                ),
            ],
          ),
        ],
        if (blocked != null && selected != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            blocked,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          key: submitButtonKey,
          onPressed: canSubmit
              ? () =>
                    ref.read(tryOnControllerProvider(_scope).notifier).submit()
              : null,
          icon: state.isSubmitting || state.isPolling
              ? const AppButtonSpinner()
              : const Icon(Icons.checkroom_outlined),
          label: Text(
            state.isSubmitting || state.isPolling
                ? 'Rendering…'
                : 'Try this outfit on',
          ),
        ),
        if (state.render != null && !state.render!.hasDisplayImage) ...[
          const SizedBox(height: AppSpacing.lg),
          TryOnStatusBanner(render: state.render!),
        ],
        if (state.render?.hasDisplayImage == true) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Your look', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          TryOnResultImage(imageUrl: state.render!.imageUrl!),
        ],
        if (state.errorMessage != null && !state.isFailed) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            state.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}

String _slotLabel(Outfit outfit) {
  final count = outfit.items.length;
  return count == 1 ? '1 item' : '$count items';
}

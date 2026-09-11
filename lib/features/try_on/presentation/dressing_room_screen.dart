import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../ai_profiles/application/selected_ai_profile.dart';
import '../../ai_profiles/presentation/widgets/ai_profile_picker_image.dart';
import '../../items/application/items_controller.dart';
import '../../items/domain/item.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../outfits/domain/outfit.dart';
import '../../outfits/presentation/widgets/outfit_cover_preview.dart';

/// Wardrobe-level outfit picker that opens the try-on screen.
class DressingRoomScreen extends ConsumerWidget {
  const DressingRoomScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const screenKey = Key('dressing_room_screen');
  static const emptyStateKey = Key('dressing_room_empty');
  static const retryButtonKey = Key('dressing_room_retry');
  static const chooseProfileButtonKey = Key('dressing_room_choose_profile');
  static const createOutfitButtonKey = Key('dressing_room_create_outfit');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outfitsControllerProvider(wardrobeId));
    final selected = ref.watch(selectedAiProfileProvider);
    final wardrobeItems = ref.watch(itemsControllerProvider(wardrobeId)).items;

    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: const Text('Dressing room')),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(outfitsControllerProvider(wardrobeId).notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pageInsets,
          children: [
            Text(
              'Pick an outfit to try on with your selected AI profile.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            if (selected == null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.face_retouching_natural_outlined),
                  title: const Text('No AI profile selected'),
                  subtitle: const Text('Choose a personal look or a model.'),
                  trailing: TextButton(
                    key: chooseProfileButtonKey,
                    onPressed: () => context.push(AppRoutes.aiTryOn),
                    child: const Text('Choose'),
                  ),
                ),
              )
            else
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: ListTile(
                  leading: SizedBox(
                    width: 56,
                    height: 72,
                    child: AiProfilePickerImage(profile: selected),
                  ),
                  minLeadingWidth: 56,
                  title: Text('Selected: ${selected.displayName}'),
                  subtitle: Text(
                    selected.isGenericModel
                        ? 'Generic model'
                        : 'Personal profile',
                  ),
                  trailing: TextButton(
                    key: chooseProfileButtonKey,
                    onPressed: () => context.push(AppRoutes.aiTryOn),
                    child: const Text('Change'),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text('Outfits', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            if (state.isLoading && state.outfits.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null && state.outfits.isEmpty)
              AppErrorState(
                message: state.errorMessage!,
                retryKey: retryButtonKey,
                onRetry: () => ref
                    .read(outfitsControllerProvider(wardrobeId).notifier)
                    .refresh(),
              )
            else if (state.isEmpty)
              AppEmptyState(
                key: emptyStateKey,
                icon: Icons.checkroom_outlined,
                title: 'No outfits yet',
                message: 'Build a look first, then come back to try it on.',
                actionLabel: 'Create outfit',
                actionKey: createOutfitButtonKey,
                onAction: () =>
                    context.push(AppRoutes.createOutfit(wardrobeId)),
              )
            else ...[
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              for (final outfit in state.outfits)
                _DressingRoomOutfitTile(
                  wardrobeId: wardrobeId,
                  outfit: outfit,
                  wardrobeItems: wardrobeItems,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DressingRoomOutfitTile extends StatelessWidget {
  const _DressingRoomOutfitTile({
    required this.wardrobeId,
    required this.outfit,
    this.wardrobeItems = const [],
  });

  final String wardrobeId;
  final Outfit outfit;
  final List<Item> wardrobeItems;

  @override
  Widget build(BuildContext context) {
    final count = outfit.items.length;
    return Card(
      child: ListTile(
        key: Key('dressing_room_outfit_${outfit.id}'),
        leading: OutfitCoverPreview(
          outfit: outfit,
          wardrobeItems: wardrobeItems,
        ),
        minLeadingWidth: 56,
        title: Text(outfit.name),
        subtitle: Text(count == 1 ? '1 item' : '$count items'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.tryOn(wardrobeId, outfit.id)),
      ),
    );
  }
}

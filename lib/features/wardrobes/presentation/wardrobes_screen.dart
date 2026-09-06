import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../application/wardrobes_controller.dart';
import '../domain/wardrobe.dart';

/// Authenticated wardrobe list with empty state and create navigation.
class WardrobesScreen extends ConsumerWidget {
  const WardrobesScreen({super.key});

  static const profileButtonKey = Key('wardrobes_profile');
  static const createButtonKey = Key('wardrobes_create');
  static const emptyStateKey = Key('wardrobes_empty');
  static const retryButtonKey = Key('wardrobes_retry');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wardrobesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobes'),
        actions: [
          IconButton(
            key: profileButtonKey,
            tooltip: 'Account',
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: createButtonKey,
        onPressed: () => context.push(AppRoutes.createWardrobe),
        tooltip: 'Create wardrobe',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(wardrobesControllerProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pageInsets,
          children: [
            if (state.isLoading && state.wardrobes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null && state.wardrobes.isEmpty)
              AppErrorState(
                message: state.errorMessage!,
                retryKey: WardrobesScreen.retryButtonKey,
                onRetry: () =>
                    ref.read(wardrobesControllerProvider.notifier).refresh(),
              )
            else if (state.isEmpty)
              AppEmptyState(
                key: WardrobesScreen.emptyStateKey,
                icon: Icons.checkroom_outlined,
                title: 'No wardrobes yet',
                message: 'Create a wardrobe to get started.',
                actionLabel: 'Create wardrobe',
                onAction: () => context.push(AppRoutes.createWardrobe),
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
              for (final wardrobe in state.wardrobes)
                _WardrobeTile(wardrobe: wardrobe),
            ],
          ],
        ),
      ),
    );
  }
}

class _WardrobeTile extends StatelessWidget {
  const _WardrobeTile({required this.wardrobe});

  final Wardrobe wardrobe;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: Key('wardrobe_tile_${wardrobe.id}'),
        title: Text(wardrobe.name),
        subtitle: Text('Created ${_formatDate(wardrobe.createdAt)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.wardrobeDetail(wardrobe.id)),
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

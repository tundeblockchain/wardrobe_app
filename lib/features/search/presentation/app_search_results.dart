import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_fade_in.dart';
import '../../../core/widgets/app_gloss.dart';
import '../application/app_search_providers.dart';
import '../domain/app_search.dart';

/// Dropdown panel of header-search hits. Hidden by the caller when the query
/// is empty.
class AppSearchResultsPanel extends ConsumerWidget {
  const AppSearchResultsPanel({super.key, required this.onClose});

  static const panelKey = Key('app_search_results_panel');
  static const emptyKey = Key('app_search_results_empty');
  static const loadingKey = Key('app_search_results_loading');

  static Key tileKey(AppSearchHitKind kind, String id) =>
      Key('app_search_hit_${kind.name}_$id');

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(appSearchResultsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppFadeIn(
      child: Material(
        key: panelKey,
        color: scheme.surfaceContainerHigh,
        elevation: 4,
        shadowColor: scheme.shadow.withValues(alpha: 0.28),
        borderRadius: AppRadii.card,
        clipBehavior: Clip.antiAlias,
        child: AppGloss(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.5,
            ),
            child: _ResultsBody(results: results, onClose: onClose),
          ),
        ),
      ),
    );
  }
}

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({required this.results, required this.onClose});

  final AppSearchResults results;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty && results.isLoading) {
      return const Padding(
        key: AppSearchResultsPanel.loadingKey,
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Text('Searching…'),
      );
    }
    if (results.isEmpty) {
      return const Padding(
        key: AppSearchResultsPanel.emptyKey,
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Text('No matches'),
      );
    }

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      children: [
        if (results.items.isNotEmpty) ...[
          const _SectionLabel('Items'),
          for (final hit in results.items) _HitTile(hit: hit, onClose: onClose),
        ],
        if (results.outfits.isNotEmpty) ...[
          const _SectionLabel('Outfits'),
          for (final hit in results.outfits)
            _HitTile(hit: hit, onClose: onClose),
        ],
        if (results.wardrobes.isNotEmpty) ...[
          const _SectionLabel('Wardrobes'),
          for (final hit in results.wardrobes)
            _HitTile(hit: hit, onClose: onClose),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _HitTile extends StatelessWidget {
  const _HitTile({required this.hit, required this.onClose});

  final AppSearchHit hit;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: AppSearchResultsPanel.tileKey(hit.kind, hit.id),
      leading: Icon(_iconFor(hit.kind)),
      title: Text(hit.title),
      subtitle: hit.subtitle == null ? null : Text(hit.subtitle!),
      onTap: () {
        final location = hit.location;
        onClose();
        context.push(location);
      },
    );
  }
}

IconData _iconFor(AppSearchHitKind kind) {
  return switch (kind) {
    AppSearchHitKind.item => Icons.checkroom_outlined,
    AppSearchHitKind.outfit => Icons.layers_outlined,
    AppSearchHitKind.wardrobe => Icons.door_sliding_outlined,
  };
}

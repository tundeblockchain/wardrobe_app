import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../application/shopping_links_state.dart';
import '../../data/dio_shopping_links_repository.dart';
import '../../domain/shopping_link.dart';
import 'shopping_product_card.dart';

/// Compact Related shopping links strip. Never blocks parent screens.
class RelatedShoppingLinksSection extends ConsumerWidget {
  const RelatedShoppingLinksSection({
    super.key,
    required this.state,
    required this.onRetry,
  });

  final ShoppingLinksState state;
  final VoidCallback onRetry;

  static const sectionKey = Key('related_shopping_links_section');
  static const headingKey = Key('related_shopping_links_heading');
  static const emptyKey = Key('related_shopping_links_empty');
  static const errorKey = Key('related_shopping_links_error');
  static const retryKey = Key('related_shopping_links_retry');
  static const loadingKey = Key('related_shopping_links_loading');
  static const listKey = Key('related_shopping_links_list');

  static const heading = 'Related shopping links';
  static const emptyMessage = 'No similar products to shop yet.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppFadeIn(
      child: Padding(
        key: sectionKey,
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(heading, key: headingKey, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            if (state.isLoading && state.links.isEmpty)
              const Padding(
                key: loadingKey,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: LinearProgressIndicator(),
              )
            else if (state.isUnavailable)
              _UnavailableRow(
                message: state.errorMessage ?? emptyMessage,
                onRetry: onRetry,
              )
            else if (state.links.isEmpty)
              Text(
                emptyMessage,
                key: emptyKey,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              SizedBox(
                key: listKey,
                height: _stripHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.links.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final link = state.links[index];
                    return ShoppingProductCard(
                      link: link,
                      onTap: () => _open(ref, link),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  static const _stripHeight = ShoppingProductCard.imageHeight + 120;

  Future<void> _open(WidgetRef ref, ShoppingLink link) async {
    final uri = tryParseShoppingUrl(link.url);
    if (uri == null) {
      return;
    }
    await ref.read(shoppingLinkOpenerProvider).open(uri);
  }
}

class _UnavailableRow extends StatelessWidget {
  const _UnavailableRow({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            message,
            key: RelatedShoppingLinksSection.errorKey,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        TextButton(
          key: RelatedShoppingLinksSection.retryKey,
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}

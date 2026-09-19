import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../search/presentation/app_search_gloss_bar.dart';
import '../application/inbox_controller.dart';
import '../domain/inbox_copy.dart';
import '../domain/inbox_deep_link.dart';
import '../domain/job_event.dart';
import 'widgets/inbox_event_tile.dart';

/// In-app processing inbox. Works without FCM via `GET /me/events`.
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  static const screenKey = Key('inbox_screen');
  static const emptyStateKey = Key('inbox_empty');
  static const retryButtonKey = Key('inbox_retry');
  static const refreshButtonKey = Key('inbox_refresh');
  static const emptyRefreshKey = Key('inbox_empty_refresh');

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final controller = ref.read(inboxControllerProvider.notifier);
      controller.setInboxVisible(true);
      controller.refresh();
    });
  }

  @override
  void deactivate() {
    ref.read(inboxControllerProvider.notifier).setInboxVisible(false);
    super.deactivate();
  }

  Future<void> _open(JobEvent event) async {
    await ref.read(inboxControllerProvider.notifier).open(event);
    if (!mounted) {
      return;
    }
    final location = InboxDeepLink.locationFor(event);
    if (location != null) {
      context.push(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inboxControllerProvider);
    final rows = state.visibleEvents;

    return Scaffold(
      key: InboxScreen.screenKey,
      appBar: AppSearchGlossBar(
        title: const Text(InboxCopy.screenTitle),
        actions: [
          IconButton(
            key: InboxScreen.refreshButtonKey,
            tooltip: InboxCopy.refreshLabel,
            onPressed: state.isBusy
                ? null
                : () => ref.read(inboxControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(inboxControllerProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pageInsets,
          children: [
            if (state.errorMessage != null) ...[
              AppErrorState(
                message: state.errorMessage!,
                onRetry: () =>
                    ref.read(inboxControllerProvider.notifier).refresh(),
                retryKey: InboxScreen.retryButtonKey,
              ),
            ] else if (state.isLoading && rows.isEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
            ] else if (rows.isEmpty) ...[
              AppEmptyState(
                key: InboxScreen.emptyStateKey,
                icon: Icons.notifications_outlined,
                title: state.contractUnavailable
                    ? InboxCopy.unavailableTitle
                    : InboxCopy.emptyTitle,
                message: state.contractUnavailable
                    ? InboxCopy.unavailableMessage
                    : InboxCopy.emptyMessage,
                actionLabel: InboxCopy.refreshLabel,
                actionKey: InboxScreen.emptyRefreshKey,
                onAction: () =>
                    ref.read(inboxControllerProvider.notifier).refresh(),
              ),
            ] else ...[
              for (final event in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InboxEventTile(
                    event: event,
                    onOpen: () => _open(event),
                    onDismiss: () => ref
                        .read(inboxControllerProvider.notifier)
                        .dismiss(event),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

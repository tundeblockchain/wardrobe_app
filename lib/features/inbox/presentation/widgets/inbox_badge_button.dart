import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../application/inbox_controller.dart';
import '../../domain/inbox_copy.dart';

/// Home / Account entry that shows unread job-done count.
class InboxBadgeButton extends ConsumerWidget {
  const InboxBadgeButton({super.key});

  static const buttonKey = Key('inbox_home_button');
  static const badgeKey = Key('inbox_unread_badge');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(inboxControllerProvider).unreadCount;
    return IconButton(
      key: buttonKey,
      tooltip: InboxCopy.homeTooltip,
      onPressed: () => context.push(AppRoutes.inbox),
      icon: Badge(
        key: unread > 0 ? badgeKey : null,
        isLabelVisible: unread > 0,
        label: Text(unread > 99 ? '99+' : '$unread'),
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}

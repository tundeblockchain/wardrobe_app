import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/auth_redirect.dart';
import '../../auth/application/auth_controller.dart';
import '../application/device_registration_controller.dart';
import '../application/inbox_controller.dart';
import '../domain/inbox_deep_link.dart';

/// Starts inbox polling + optional FCM registration after sign-in.
///
/// Device registration never blocks the inbox. Push taps deep-link to item
/// detail or the try-on route and ack the event.
class InboxSessionBinder extends ConsumerStatefulWidget {
  const InboxSessionBinder({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<InboxSessionBinder> createState() => _InboxSessionBinderState();
}

class _InboxSessionBinderState extends ConsumerState<InboxSessionBinder> {
  final _subscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _bindPush();
      _startInboxIfSignedIn();
    });
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void _startInboxIfSignedIn() {
    if (ref.read(authControllerProvider).status != AuthStatus.authenticated) {
      return;
    }
    ref.read(deviceRegistrationControllerProvider);
    ref.read(inboxControllerProvider.notifier).refresh();
  }

  void _bindPush() {
    final source = ref.read(pushTokenSourceProvider);
    _subscriptions.add(source.openedMessages.listen(_openFromPush));
    _subscriptions.add(
      source.foregroundMessages.listen((data) {
        ref.read(inboxControllerProvider.notifier).applyPushData(data);
      }),
    );
    source.initialMessage().then((data) {
      if (data != null && mounted) {
        _openFromPush(data);
      }
    });
  }

  void _openFromPush(Map<String, String> data) {
    final event = InboxDeepLink.fromPushData(data);
    if (event == null) {
      return;
    }
    ref.read(inboxControllerProvider.notifier).applyPushData(data);
    ref.read(inboxControllerProvider.notifier).open(event);
    final location = InboxDeepLink.locationFor(event);
    if (location == null) {
      return;
    }
    final router = ref.read(routerProvider);
    router.go(location);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated &&
          previous?.status != AuthStatus.authenticated) {
        _startInboxIfSignedIn();
      }
    });
    return widget.child;
  }
}

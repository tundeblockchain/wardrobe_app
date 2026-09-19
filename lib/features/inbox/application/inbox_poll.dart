import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interval for `GET /me/events` while the tray is visible or PENDING.
class InboxPollConfig {
  const InboxPollConfig({this.interval = const Duration(seconds: 8)});

  final Duration interval;
}

typedef InboxDelay = Future<void> Function(Duration duration);

final inboxPollConfigProvider = Provider<InboxPollConfig>((ref) {
  return const InboxPollConfig();
});

final inboxDelayProvider = Provider<InboxDelay>((ref) {
  return Future<void>.delayed;
});

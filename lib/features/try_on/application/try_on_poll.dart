import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interval and overall deadline for GET `/render` polling.
class TryOnPollConfig {
  const TryOnPollConfig({
    this.interval = const Duration(seconds: 2),
    this.timeout = const Duration(seconds: 90),
  });

  final Duration interval;
  final Duration timeout;
}

typedef TryOnDelay = Future<void> Function(Duration duration);

final tryOnPollConfigProvider = Provider<TryOnPollConfig>((ref) {
  return const TryOnPollConfig();
});

final tryOnDelayProvider = Provider<TryOnDelay>((ref) {
  return Future<void>.delayed;
});

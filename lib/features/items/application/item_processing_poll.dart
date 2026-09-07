import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interval and overall deadline for clothing-item processing polls.
///
/// WARDROBE-59: list/get until `processingStatus` is `READY` or `FAILED`.
class ItemProcessingPollConfig {
  const ItemProcessingPollConfig({
    this.interval = const Duration(seconds: 2),
    this.timeout = const Duration(minutes: 3),
  });

  final Duration interval;
  final Duration timeout;
}

typedef ItemProcessingDelay = Future<void> Function(Duration duration);

final itemProcessingPollConfigProvider = Provider<ItemProcessingPollConfig>((
  ref,
) {
  return const ItemProcessingPollConfig();
});

final itemProcessingDelayProvider = Provider<ItemProcessingDelay>((ref) {
  return Future<void>.delayed;
});

import 'package:flutter_riverpod/misc.dart';
import 'package:wardrobe_app/features/worn_on/application/worn_on_clock.dart';
import 'package:wardrobe_app/features/worn_on/data/dio_worn_on_repository.dart';

import 'fake_worn_on_repository.dart';

/// Fixed local clock so "mark worn today" is deterministic in tests.
final testWornOnNow = DateTime(2026, 9, 19, 15, 30);

List<Override> wornOnTestOverrides({
  FakeWornOnRepository? repository,
  DateTime? now,
}) {
  return [
    wornOnRepositoryProvider.overrideWithValue(
      repository ?? FakeWornOnRepository(),
    ),
    wornOnClockProvider.overrideWithValue(() => now ?? testWornOnNow),
  ];
}

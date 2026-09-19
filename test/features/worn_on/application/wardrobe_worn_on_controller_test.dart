import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/worn_on/application/wardrobe_worn_on_controller.dart';
import 'package:wardrobe_app/features/worn_on/data/dio_worn_on_repository.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_errors.dart';

import '../../../helpers/fake_worn_on_repository.dart';
import '../../../helpers/worn_on_test_overrides.dart';

void main() {
  late FakeWornOnRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeWornOnRepository(
      seed: [
        testWornOnEntry(),
        testWornOnEntry(
          outfitId: 'outfit_other',
          wornOn: DateTime.utc(2026, 8, 2),
        ),
      ],
    );
    container = ProviderContainer.test(
      overrides: wornOnTestOverrides(repository: repository),
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads the visible month and joins only that window', () async {
    container.read(wardrobeWornOnControllerProvider('wd_abc123'));
    await settle();

    final state = container.read(wardrobeWornOnControllerProvider('wd_abc123'));
    expect(state.visibleMonth, DateTime.utc(2026, 9, 1));
    expect(state.entries, hasLength(1));
    expect(state.entries.single.outfitId, 'outfit_123');
    expect(repository.lastFrom, DateTime.utc(2026, 9, 1));
    expect(repository.lastTo, DateTime.utc(2026, 9, 30));
  });

  test('selectDay filters the month list and toggling clears it', () async {
    container.read(wardrobeWornOnControllerProvider('wd_abc123'));
    await settle();

    container
        .read(wardrobeWornOnControllerProvider('wd_abc123').notifier)
        .selectDay(DateTime.utc(2026, 9, 18));
    expect(
      container
          .read(wardrobeWornOnControllerProvider('wd_abc123'))
          .visibleEntries,
      hasLength(1),
    );

    container
        .read(wardrobeWornOnControllerProvider('wd_abc123').notifier)
        .selectDay(DateTime.utc(2026, 9, 18));
    expect(
      container.read(wardrobeWornOnControllerProvider('wd_abc123')).selectedDay,
      isNull,
    );
  });

  test('unmark drops the row', () async {
    container.read(wardrobeWornOnControllerProvider('wd_abc123'));
    await settle();

    final ok = await container
        .read(wardrobeWornOnControllerProvider('wd_abc123').notifier)
        .unmark(outfitId: 'outfit_123', wornOn: DateTime.utc(2026, 9, 18));

    expect(ok, isTrue);
    expect(repository.removeCalls, 1);
    expect(
      container.read(wardrobeWornOnControllerProvider('wd_abc123')).entries,
      isEmpty,
    );
  });

  test('maps WARDROBE_NOT_FOUND on load', () async {
    repository.nextFailure = const ApiException(
      message: 'missing',
      code: 'WARDROBE_NOT_FOUND',
      statusCode: 404,
    );

    container.read(wardrobeWornOnControllerProvider('wd_abc123'));
    await settle();

    expect(
      container
          .read(wardrobeWornOnControllerProvider('wd_abc123'))
          .errorMessage,
      WornOnErrors.wardrobeNotFound,
    );
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/outfits/application/outfit_scope.dart';
import 'package:wardrobe_app/features/worn_on/application/outfit_worn_on_controller.dart';
import 'package:wardrobe_app/features/worn_on/data/dio_worn_on_repository.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_errors.dart';

import '../../../helpers/fake_worn_on_repository.dart';
import '../../../helpers/worn_on_test_overrides.dart';

void main() {
  const scope = OutfitScope(wardrobeId: 'wd_abc123', outfitId: 'outfit_123');

  late FakeWornOnRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeWornOnRepository(seed: [testWornOnEntry()]);
    container = ProviderContainer.test(
      overrides: wornOnTestOverrides(repository: repository),
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads the outfit worn-on log', () async {
    container.read(outfitWornOnControllerProvider(scope));
    await settle();

    final state = container.read(outfitWornOnControllerProvider(scope));
    expect(state.entries, hasLength(1));
    expect(state.entries.single.wornOn, DateTime.utc(2026, 9, 18));
    expect(repository.listOutfitCalls, 1);
  });

  test('markToday posts today and prepends the entry', () async {
    container.read(outfitWornOnControllerProvider(scope));
    await settle();

    final ok = await container
        .read(outfitWornOnControllerProvider(scope).notifier)
        .markToday();

    expect(ok, isTrue);
    expect(repository.setCalls, 1);
    expect(repository.lastWornOn, DateTime.utc(2026, 9, 19));
    final state = container.read(outfitWornOnControllerProvider(scope));
    expect(state.entries.first.wornOn, DateTime.utc(2026, 9, 19));
    expect(state.hasDate(DateTime.utc(2026, 9, 19)), isTrue);
  });

  test('unmark removes the date', () async {
    container.read(outfitWornOnControllerProvider(scope));
    await settle();

    final ok = await container
        .read(outfitWornOnControllerProvider(scope).notifier)
        .unmark(DateTime.utc(2026, 9, 18));

    expect(ok, isTrue);
    expect(repository.removeCalls, 1);
    expect(
      container.read(outfitWornOnControllerProvider(scope)).entries,
      isEmpty,
    );
  });

  test('maps 404 OUTFIT_NOT_FOUND on load', () async {
    repository.nextFailure = const ApiException(
      message: 'Outfit not found.',
      code: 'OUTFIT_NOT_FOUND',
      statusCode: 404,
    );

    container.read(outfitWornOnControllerProvider(scope));
    await settle();

    expect(
      container.read(outfitWornOnControllerProvider(scope)).errorMessage,
      WornOnErrors.outfitNotFound,
    );
  });

  test('maps 401 on mark', () async {
    container.read(outfitWornOnControllerProvider(scope));
    await settle();
    repository.nextFailure = const ApiException(
      message: 'Sign in.',
      code: 'UNAUTHENTICATED',
      statusCode: 401,
    );

    final ok = await container
        .read(outfitWornOnControllerProvider(scope).notifier)
        .markToday();

    expect(ok, isFalse);
    expect(
      container.read(outfitWornOnControllerProvider(scope)).errorMessage,
      WornOnErrors.unauthenticated,
    );
  });
}

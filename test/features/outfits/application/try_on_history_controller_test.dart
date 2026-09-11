import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/outfits/application/outfit_scope.dart';
import 'package:wardrobe_app/features/outfits/application/try_on_history_controller.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';

import '../../../helpers/fake_outfit_repository.dart';

void main() {
  const scope = OutfitScope(wardrobeId: 'wd_abc123', outfitId: 'outfit_123');

  late FakeOutfitRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeOutfitRepository(seed: [testOutfit()]);
    container = ProviderContainer.test(
      overrides: [outfitRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads history entries from the repository', () async {
    repository.tryOnHistory.add(
      testTryOnHistoryEntry(
        render: testOutfitRender(
          imageUrl: 'https://cdn.example.com/try-on/latest.png',
        ),
      ),
    );

    container.read(tryOnHistoryControllerProvider(scope));
    await settle();

    final state = container.read(tryOnHistoryControllerProvider(scope));
    expect(repository.listTryOnHistoryCalls, 1);
    expect(state.entries, hasLength(1));
    expect(
      state.entries.single.imageUrl,
      'https://cdn.example.com/try-on/latest.png',
    );
    expect(state.isUnavailable, isFalse);
  });

  test('treats a missing history route as a soft empty gallery', () async {
    repository.nextHistoryFailure = const ApiException(
      message: 'Not found.',
      code: 'NOT_FOUND',
      statusCode: 404,
    );

    container.read(tryOnHistoryControllerProvider(scope));
    await settle();

    final state = container.read(tryOnHistoryControllerProvider(scope));
    expect(state.entries, isEmpty);
    expect(state.isUnavailable, isTrue);
    expect(state.errorMessage, isNull);
  });

  test('surfaces unexpected history errors without inventing rows', () async {
    repository.nextHistoryFailure = const ApiException(
      message: 'Server error.',
      code: 'BAD_RESPONSE',
      statusCode: 500,
    );

    container.read(tryOnHistoryControllerProvider(scope));
    await settle();

    final state = container.read(tryOnHistoryControllerProvider(scope));
    expect(state.entries, isEmpty);
    expect(state.isUnavailable, isFalse);
    expect(state.errorMessage, 'Server error.');
  });
}

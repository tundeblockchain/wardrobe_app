import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/recommendations/application/recommendations_controller.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';

import '../../../helpers/fake_recommendation_repository.dart';

void main() {
  late FakeRecommendationRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeRecommendationRepository();
    container = ProviderContainer.test(
      overrides: [
        recommendationRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads suggestions for the wardrobe', () async {
    repository.recommendations.add(testRecommendation());

    final first = container.read(
      recommendationsControllerProvider('wd_abc123'),
    );
    expect(first.isLoading, isTrue);

    await settle();

    final state = container.read(
      recommendationsControllerProvider('wd_abc123'),
    );
    expect(state.isLoading, isFalse);
    expect(state.recommendations, hasLength(1));
    expect(state.recommendations.single.name, 'Navy + Beige look');
    expect(repository.listCalls, 1);
  });

  test(
    'refresh records ApiException without leaking into wardrobe state',
    () async {
      repository.nextFailure = const ApiException(
        message: 'Unable to reach the server. Check your connection.',
        code: 'NETWORK_ERROR',
      );

      container.read(recommendationsControllerProvider('wd_abc123'));
      await settle();

      final state = container.read(
        recommendationsControllerProvider('wd_abc123'),
      );
      expect(state.errorMessage, contains('connection'));
      expect(state.isUnavailable, isTrue);
      expect(state.recommendations, isEmpty);
    },
  );

  test('empty list is a successful empty state, not unavailable', () async {
    container.read(recommendationsControllerProvider('wd_abc123'));
    await settle();

    final state = container.read(
      recommendationsControllerProvider('wd_abc123'),
    );
    expect(state.isEmpty, isTrue);
    expect(state.isUnavailable, isFalse);
    expect(state.errorMessage, isNull);
  });
}

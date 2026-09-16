import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/entitlements/data/dio_entitlement_repository.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement.dart';
import 'package:wardrobe_app/features/entitlements/domain/subscription_tier.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  DioEntitlementRepository buildRepository(List<HttpScript> scripts) {
    final adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioEntitlementRepository(dio);
  }

  test('GET /me/entitlements maps the Backend snapshot', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'tier': 'premium',
          'limits': {
            'maxWardrobes': null,
            'maxItems': null,
            'maxOutfits': null,
          },
          'flags': {'aiTryOn': true, 'otherAi': true},
        },
      ),
    ]);

    final entitlement = await repository.fetchEntitlements();
    expect(entitlement.tier, SubscriptionTier.premium);
    expect(entitlement.canUseAiTryOn, isTrue);
  });

  test('non-map payload becomes INVALID_RESPONSE', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 200, body: []),
    ]);

    expect(
      () => repository.fetchEntitlements(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'INVALID_RESPONSE',
        ),
      ),
    );
  });

  test(
    'Switching repository falls back on 404 until Backend is live',
    () async {
      final remote = buildRepository([
        const HttpScript(
          statusCode: 404,
          body: {'code': 'NOT_FOUND', 'message': 'missing'},
        ),
      ]);
      final switching = SwitchingEntitlementRepository(
        remote: remote,
        fallback: const CatalogEntitlementRepository(),
      );

      final entitlement = await switching.fetchEntitlements();
      expect(entitlement, Entitlement.free);
    },
  );

  test('Switching repository skips remote when useRemote is false', () async {
    final switching = SwitchingEntitlementRepository(
      remote: buildRepository(const []),
      fallback: CatalogEntitlementRepository(seed: Entitlement.basic),
      useRemote: false,
    );

    expect(await switching.fetchEntitlements(), Entitlement.basic);
  });
}

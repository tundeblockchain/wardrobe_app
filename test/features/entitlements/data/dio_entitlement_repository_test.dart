import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/entitlements/data/dio_entitlement_repository.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_wire.dart';
import 'package:wardrobe_app/features/entitlements/domain/subscription_tier.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  late ScriptedHttpAdapter adapter;

  DioEntitlementRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioEntitlementRepository(dio);
  }

  test('GET /me maps Free catalog caps and no AI', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'userId': 'uid-free',
          'tier': 'FREE',
          'status': 'NONE',
          'features': {
            'unlimitedCatalog': false,
            'aiTryOn': false,
            'otherAi': false,
          },
          'limits': {'wardrobes': 1, 'items': 5, 'outfits': 5},
          'usage': {'wardrobes': 1, 'items': 5, 'outfits': 0},
        },
      ),
    ]);

    final entitlement = await repository.fetchEntitlements();
    expect(entitlement.userId, 'uid-free');
    expect(entitlement.tier, SubscriptionTier.free);
    expect(entitlement.status, EntitlementStatus.none);
    expect(entitlement.limits?.items, 5);
    expect(entitlement.canCreateItem(5), isFalse);
    expect(entitlement.canUseAiTryOn, isFalse);
    expect(adapter.requests.single.path, EntitlementWire.mePath);
  });

  test('GET /me maps the locked Backend entitlement DTO', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'userId': 'uid-1',
          'tier': 'PREMIUM',
          'status': 'ACTIVE',
          'features': {
            'unlimitedCatalog': true,
            'aiTryOn': true,
            'otherAi': true,
          },
          'limits': null,
          'usage': {'wardrobes': 1, 'items': 2, 'outfits': 0},
          'updatedAt': '2026-09-16T12:00:00.000Z',
        },
      ),
    ]);

    final entitlement = await repository.fetchEntitlements();
    expect(entitlement.userId, 'uid-1');
    expect(entitlement.tier, SubscriptionTier.premium);
    expect(entitlement.status, EntitlementStatus.active);
    expect(entitlement.canUseAiTryOn, isTrue);
    expect(entitlement.limits, isNull);
    expect(entitlement.usage.items, 2);
    expect(adapter.requests.single.path, EntitlementWire.mePath);
  });

  test('GET /me 404 is an API error, not a local stub', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {'code': 'NOT_FOUND', 'message': 'missing'},
        },
      ),
    ]);

    await expectLater(
      repository.fetchEntitlements(),
      throwsA(
        isA<ApiException>().having((error) => error.statusCode, 'status', 404),
      ),
    );
    expect(adapter.requests.single.path, EntitlementWire.mePath);
  });

  test('non-map payload becomes INVALID_RESPONSE', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 200, body: []),
    ]);

    await expectLater(
      repository.fetchEntitlements(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'INVALID_RESPONSE',
        ),
      ),
    );
  });
}

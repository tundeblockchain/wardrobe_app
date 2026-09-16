import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/shopping_link.dart';
import '../domain/shopping_link_opener.dart';
import '../domain/shopping_links_repository.dart';
import 'shopping_link_dtos.dart';
import 'stub_shopping_links_repository.dart';
import 'url_launcher_shopping_link_opener.dart';

/// Provisional WARDROBE-96 paths. Flip [liveEnabled] when Backend posts SHA.
abstract final class ShoppingLinksApi {
  /// `false` until Backend confirms endpoints. Swap the repository provider.
  static const liveEnabled = false;

  static const homePath = '/shopping-links';

  static String itemPath({
    required String wardrobeId,
    required String itemId,
  }) => '/wardrobes/$wardrobeId/items/$itemId/shopping-links';
}

/// Dio implementation of [ShoppingLinksRepository].
class DioShoppingLinksRepository implements ShoppingLinksRepository {
  DioShoppingLinksRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<ShoppingLink>> listHomeShoppingLinks() {
    return _getList(ShoppingLinksApi.homePath);
  }

  @override
  Future<List<ShoppingLink>> listItemShoppingLinks({
    required String wardrobeId,
    required String itemId,
  }) {
    return _getList(
      ShoppingLinksApi.itemPath(wardrobeId: wardrobeId, itemId: itemId),
    );
  }

  Future<List<ShoppingLink>> _getList(String path) async {
    try {
      final response = await _dio.get<dynamic>(path);
      return parseShoppingLinkList(response.data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const [];
      }
      throw ApiException.fromDio(error);
    }
  }
}

/// Defaults to the empty stub. Point at Dio when WARDROBE-96 confirms paths.
final shoppingLinksRepositoryProvider = Provider<ShoppingLinksRepository>((
  ref,
) {
  if (!ShoppingLinksApi.liveEnabled) {
    return const StubShoppingLinksRepository();
  }
  return DioShoppingLinksRepository(ref.watch(dioProvider));
});

final shoppingLinkOpenerProvider = Provider<ShoppingLinkOpener>((ref) {
  return const UrlLauncherShoppingLinkOpener();
});

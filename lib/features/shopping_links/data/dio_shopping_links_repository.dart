import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/shopping_link.dart';
import '../domain/shopping_link_opener.dart';
import '../domain/shopping_links_contract.dart';
import '../domain/shopping_links_repository.dart';
import 'shopping_link_dtos.dart';
import 'stub_shopping_links_repository.dart';
import 'url_launcher_shopping_link_opener.dart';

export '../domain/shopping_links_contract.dart';

/// Dio implementation of the locked WARDROBE-96 shopping-links contract.
class DioShoppingLinksRepository implements ShoppingLinksRepository {
  DioShoppingLinksRepository(this._dio);

  final Dio _dio;

  @override
  Future<HomeShoppingLinks> listHomeShoppingLinks({
    int limit = ShoppingLinksContract.defaultLimit,
    int linksPerItem = ShoppingLinksContract.defaultLinksPerItem,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ShoppingLinksContract.homePath,
        queryParameters: ShoppingLinksContract.homeQueryParameters(
          limit: limit,
          linksPerItem: linksPerItem,
        ),
      );
      return parseHomeShoppingLinks(response.data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const HomeShoppingLinks();
      }
      throw ApiException.fromDio(error);
    }
  }

  @override
  Future<ShoppingLinksItemResult> listItemShoppingLinks({
    required String wardrobeId,
    required String itemId,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ShoppingLinksContract.itemPath(wardrobeId: wardrobeId, itemId: itemId),
      );
      return parseItemShoppingLinks(
        response.data,
        fallbackItemId: itemId,
        fallbackWardrobeId: wardrobeId,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return ShoppingLinksItemResult(itemId: itemId, wardrobeId: wardrobeId);
      }
      throw ApiException.fromDio(error);
    }
  }
}

/// Live Dio against wardrobe-backend#47 squash `aaf46cd` on main. Override in tests.
final shoppingLinksRepositoryProvider = Provider<ShoppingLinksRepository>((
  ref,
) {
  if (!ShoppingLinksContract.liveEnabled) {
    return const StubShoppingLinksRepository();
  }
  return DioShoppingLinksRepository(ref.watch(dioProvider));
});

final shoppingLinkOpenerProvider = Provider<ShoppingLinkOpener>((ref) {
  return const UrlLauncherShoppingLinkOpener();
});

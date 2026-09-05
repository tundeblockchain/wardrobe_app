import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/item.dart';
import '../domain/item_list_filters.dart';
import '../domain/item_repository.dart';
import 'item_dtos.dart';

/// Dio implementation of [ItemRepository] against `/wardrobes/{id}/items`.
class DioItemRepository implements ItemRepository {
  DioItemRepository(this._dio);

  final Dio _dio;

  String _collectionPath(String wardrobeId) => '/wardrobes/$wardrobeId/items';

  String _itemPath(String wardrobeId, String itemId) =>
      '${_collectionPath(wardrobeId)}/$itemId';

  @override
  Future<List<Item>> listItems(
    String wardrobeId, {
    ItemListFilters filters = const ItemListFilters(),
  }) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        _collectionPath(wardrobeId),
        queryParameters: filters.toQueryParameters(),
      );
      return parseItemList(response.data);
    });
  }

  @override
  Future<Item> getItem({required String wardrobeId, required String itemId}) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(_itemPath(wardrobeId, itemId));
      return parseItem(response.data);
    });
  }

  @override
  Future<Item> createItem({
    required String wardrobeId,
    required String name,
    required ItemCategory category,
    String? subcategory,
    List<String>? colours,
    String? brand,
    required String imageKey,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        _collectionPath(wardrobeId),
        data: CreateItemRequest(
          name: name,
          category: category.wireValue,
          subcategory: _optional(subcategory),
          colours: _optionalList(colours),
          brand: _optional(brand),
          imageKey: imageKey,
        ).toJson(),
      );
      return parseItem(response.data);
    });
  }

  @override
  Future<Item> updateItem({
    required String wardrobeId,
    required String itemId,
    String? name,
    ItemCategory? category,
    String? subcategory,
    List<String>? colours,
    String? brand,
    String? imageKey,
  }) {
    return _guard(() async {
      final response = await _dio.patch<dynamic>(
        _itemPath(wardrobeId, itemId),
        data: UpdateItemRequest(
          name: name,
          category: category?.wireValue,
          subcategory: subcategory,
          colours: colours,
          brand: brand,
          imageKey: imageKey,
        ).toJson(),
      );
      return parseItem(response.data);
    });
  }

  @override
  Future<void> deleteItem({
    required String wardrobeId,
    required String itemId,
  }) {
    return _guard(() async {
      await _dio.delete<dynamic>(_itemPath(wardrobeId, itemId));
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

/// Parses `GET /wardrobes/{id}/items` as `{ "items": [...] }` or a bare array.
List<Item> parseItemList(dynamic data) {
  if (data is List) {
    return data.whereType<Map>().map((item) => parseItem(item)).toList();
  }
  if (data is Map) {
    return ItemListResponse.fromJson(Map<String, dynamic>.from(data))
        .toDomain();
  }
  throw const ApiException(
    message: 'Unexpected items response.',
    code: 'INVALID_RESPONSE',
  );
}

Item parseItem(dynamic data) {
  if (data is Map) {
    return ItemResponse.fromJson(Map<String, dynamic>.from(data)).toDomain();
  }
  throw const ApiException(
    message: 'Unexpected item response.',
    code: 'INVALID_RESPONSE',
  );
}

String? _optional(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

List<String>? _optionalList(List<String>? values) {
  if (values == null || values.isEmpty) {
    return null;
  }
  return values;
}

/// Default [ItemRepository] using the shared authenticated Dio client.
final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return DioItemRepository(ref.watch(dioProvider));
});

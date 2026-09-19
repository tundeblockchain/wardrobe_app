import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/worn_on_contract.dart';
import '../domain/worn_on_date.dart';
import '../domain/worn_on_entry.dart';
import '../domain/worn_on_errors.dart';
import '../domain/worn_on_repository.dart';
import 'stub_worn_on_repository.dart';
import 'worn_on_dtos.dart';

export '../domain/worn_on_contract.dart';

/// Dio implementation of [WornOnRepository] against WARDROBE-120.
class DioWornOnRepository implements WornOnRepository {
  DioWornOnRepository(this._dio);

  final Dio _dio;

  @override
  Future<WornOnEntry> setWornOn({
    required String wardrobeId,
    required String outfitId,
    required DateTime wornOn,
  }) {
    final wire = WornOnDate.tryParseStrict(WornOnDate.toWire(wornOn));
    if (wire == null) {
      throw WornOnErrors.validationException();
    }
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        WornOnContract.outfitPath(wardrobeId: wardrobeId, outfitId: outfitId),
        data: SetWornOnRequest.fromDomain(wire).toJson(),
      );
      return parseWornOnEntryRequired(response.data);
    });
  }

  @override
  Future<List<WornOnEntry>> listOutfitWornOn({
    required String wardrobeId,
    required String outfitId,
  }) {
    return _guardList(() async {
      final response = await _dio.get<dynamic>(
        WornOnContract.outfitPath(wardrobeId: wardrobeId, outfitId: outfitId),
      );
      return parseWornOnList(response.data);
    });
  }

  @override
  Future<void> removeWornOn({
    required String wardrobeId,
    required String outfitId,
    required DateTime wornOn,
  }) {
    final wire = WornOnDate.toWire(wornOn);
    if (wire == null || WornOnDate.tryParseStrict(wire) == null) {
      throw WornOnErrors.validationException();
    }
    return _guard(() async {
      await _dio.delete<dynamic>(
        WornOnContract.outfitDatePath(
          wardrobeId: wardrobeId,
          outfitId: outfitId,
          date: wire,
        ),
      );
    });
  }

  @override
  Future<List<WornOnEntry>> listWardrobeWornOn({
    required String wardrobeId,
    DateTime? from,
    DateTime? to,
  }) {
    final fromWire = WornOnDate.toWire(from);
    final toWire = WornOnDate.toWire(to);
    if (fromWire != null && toWire != null && fromWire.compareTo(toWire) > 0) {
      throw WornOnErrors.validationException(WornOnErrors.range);
    }
    return _guardList(() async {
      final response = await _dio.get<dynamic>(
        WornOnContract.wardrobePath(wardrobeId),
        queryParameters: WornOnContract.calendarQuery(
          from: fromWire,
          to: toWire,
        ),
      );
      return parseWornOnList(response.data);
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  /// Soft-empty when the Backend route is not deployed yet.
  Future<List<WornOnEntry>> _guardList(
    Future<List<WornOnEntry>> Function() action,
  ) async {
    try {
      return await action();
    } on DioException catch (error) {
      final mapped = ApiException.fromDio(error);
      if (WornOnErrors.isUndeployedRoute(mapped)) {
        return const [];
      }
      throw mapped;
    }
  }
}

/// Default [WornOnRepository]. Live Dio unless [WornOnContract.liveEnabled] is off.
final wornOnRepositoryProvider = Provider<WornOnRepository>((ref) {
  if (!WornOnContract.liveEnabled) {
    return const StubWornOnRepository();
  }
  return DioWornOnRepository(ref.watch(dioProvider));
});

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../domain/worn_on_date.dart';
import '../domain/worn_on_entry.dart';

part 'worn_on_dtos.freezed.dart';
part 'worn_on_dtos.g.dart';

String? _optionalString(dynamic value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

DateTime? _optionalDateTime(dynamic value) {
  if (value is DateTime) {
    return value.toUtc();
  }
  if (value is! String) {
    return null;
  }
  return DateTime.tryParse(value.trim())?.toUtc();
}

/// `POST .../worn-on` body. Wire field is date-only `YYYY-MM-DD`.
@freezed
abstract class SetWornOnRequest with _$SetWornOnRequest {
  @JsonSerializable(explicitToJson: true)
  const factory SetWornOnRequest({required String wornOn}) = _SetWornOnRequest;

  factory SetWornOnRequest.fromJson(Map<String, dynamic> json) =>
      _$SetWornOnRequestFromJson(json);

  factory SetWornOnRequest.fromDomain(DateTime wornOn) {
    return SetWornOnRequest(wornOn: WornOnDate.formatWire(wornOn));
  }
}

/// Entry DTO. Unused optionals are omitted; never JSON `null`.
@freezed
abstract class WornOnEntryResponse with _$WornOnEntryResponse {
  const WornOnEntryResponse._();

  const factory WornOnEntryResponse({
    required String outfitId,
    required String wardrobeId,
    required String wornOn,
    required DateTime createdAt,
  }) = _WornOnEntryResponse;

  factory WornOnEntryResponse.fromJson(Map<String, dynamic> json) =>
      _$WornOnEntryResponseFromJson(json);

  WornOnEntry? toDomain() {
    final date = WornOnDate.tryParse(wornOn);
    if (date == null) {
      return null;
    }
    return WornOnEntry(
      outfitId: outfitId,
      wardrobeId: wardrobeId,
      wornOn: date,
      createdAt: createdAt.toUtc(),
    );
  }
}

/// `GET .../worn-on` envelope `{ "entries": [...] }`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WornOnListResponse with _$WornOnListResponse {
  const WornOnListResponse._();

  const factory WornOnListResponse({
    required List<WornOnEntryResponse> entries,
  }) = _WornOnListResponse;

  factory WornOnListResponse.fromJson(Map<String, dynamic> json) =>
      _$WornOnListResponseFromJson(json);

  List<WornOnEntry> toDomain() => [
    for (final entry in entries) ?entry.toDomain(),
  ];
}

/// Parses one entry. Soft-omits junk so a bad row cannot blank the log.
WornOnEntry? parseWornOnEntry(dynamic data) {
  if (data is! Map) {
    return null;
  }
  final json = Map<String, dynamic>.from(data);
  final outfitId = _optionalString(json['outfitId']);
  final wardrobeId = _optionalString(json['wardrobeId']);
  final wornOn = WornOnDate.tryParse(json['wornOn']);
  final createdAt = _optionalDateTime(json['createdAt']);
  if (outfitId == null ||
      wardrobeId == null ||
      wornOn == null ||
      createdAt == null) {
    return null;
  }
  return WornOnEntry(
    outfitId: outfitId,
    wardrobeId: wardrobeId,
    wornOn: wornOn,
    createdAt: createdAt,
  );
}

/// Parses `{ "entries": [...] }` or a bare array. Newest-first when sortable.
List<WornOnEntry> parseWornOnList(dynamic data) {
  if (data == null) {
    return const [];
  }
  if (data is List) {
    return sortWornOnEntries([
      for (final item in data) ?parseWornOnEntry(item),
    ]);
  }
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final nested = map['entries'];
    if (nested == null) {
      return const [];
    }
    if (nested is! List) {
      throw const ApiException(
        message: 'Unexpected worn-on response.',
        code: 'INVALID_RESPONSE',
      );
    }
    return sortWornOnEntries([
      for (final item in nested) ?parseWornOnEntry(item),
    ]);
  }
  throw const ApiException(
    message: 'Unexpected worn-on response.',
    code: 'INVALID_RESPONSE',
  );
}

WornOnEntry parseWornOnEntryRequired(dynamic data) {
  final entry = parseWornOnEntry(data);
  if (entry == null) {
    throw const ApiException(
      message: 'Unexpected worn-on response.',
      code: 'INVALID_RESPONSE',
    );
  }
  return entry;
}

List<WornOnEntry> sortWornOnEntries(List<WornOnEntry> entries) {
  final next = [...entries];
  next.sort((left, right) {
    final date = right.wornOn.compareTo(left.wornOn);
    if (date != 0) {
      return date;
    }
    return left.outfitId.compareTo(right.outfitId);
  });
  return next;
}

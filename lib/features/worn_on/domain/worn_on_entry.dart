import 'package:freezed_annotation/freezed_annotation.dart';

part 'worn_on_entry.freezed.dart';

/// One outfit worn-on date. Backend `outfitId` stays a foreign key.
@freezed
abstract class WornOnEntry with _$WornOnEntry {
  const factory WornOnEntry({
    required String outfitId,
    required String wardrobeId,
    required DateTime wornOn,
    required DateTime createdAt,
  }) = _WornOnEntry;
}

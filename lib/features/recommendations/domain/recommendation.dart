import 'package:freezed_annotation/freezed_annotation.dart';

import '../../outfits/domain/outfit.dart';

part 'recommendation.freezed.dart';

/// Suggested outfit from `GET /wardrobes/{id}/recommendations`.
///
/// Not persisted until the user saves it via the existing outfit create API.
@freezed
abstract class Recommendation with _$Recommendation {
  const factory Recommendation({
    required String name,
    @Default([]) List<OutfitItem> items,
  }) = _Recommendation;
}

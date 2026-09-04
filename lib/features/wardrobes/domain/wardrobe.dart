import 'package:freezed_annotation/freezed_annotation.dart';

part 'wardrobe.freezed.dart';

/// Wardrobe as used by controllers and UI. Backend `wardrobeId` is [id].
@freezed
abstract class Wardrobe with _$Wardrobe {
  const factory Wardrobe({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Wardrobe;
}

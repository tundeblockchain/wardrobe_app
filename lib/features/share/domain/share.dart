import 'package:freezed_annotation/freezed_annotation.dart';

part 'share.freezed.dart';

/// Backend `resourceType` on create (WARDROBE-126).
enum ShareResourceType {
  item('ITEM'),
  outfit('OUTFIT');

  const ShareResourceType(this.wireValue);

  final String wireValue;

  static ShareResourceType? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    for (final type in ShareResourceType.values) {
      if (type.wireValue == value) {
        return type;
      }
    }
    return null;
  }
}

/// Owner-created share token. Flutter never calls public GET.
@freezed
abstract class Share with _$Share {
  const factory Share({
    required String token,
    required ShareResourceType resourceType,
    required String wardrobeId,
    String? itemId,
    String? outfitId,
    required String sharePath,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _Share;
}

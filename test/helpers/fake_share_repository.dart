import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/share/domain/share.dart';
import 'package:wardrobe_app/features/share/domain/share_repository.dart';

/// In-memory [ShareRepository] for unit tests.
class FakeShareRepository implements ShareRepository {
  FakeShareRepository({this.nextShare, this.nextFailure});

  Share? nextShare;
  ApiException? nextFailure;
  int createItemCalls = 0;
  int createOutfitCalls = 0;
  int revokeCalls = 0;
  String? lastWardrobeId;
  String? lastItemId;
  String? lastOutfitId;
  String? lastRevokedToken;

  @override
  Future<Share> createItemShare({
    required String wardrobeId,
    required String itemId,
  }) async {
    createItemCalls++;
    lastWardrobeId = wardrobeId;
    lastItemId = itemId;
    _maybeFail();
    return nextShare ??
        testShare(
          resourceType: ShareResourceType.item,
          wardrobeId: wardrobeId,
          itemId: itemId,
        );
  }

  @override
  Future<Share> createOutfitShare({
    required String wardrobeId,
    required String outfitId,
  }) async {
    createOutfitCalls++;
    lastWardrobeId = wardrobeId;
    lastOutfitId = outfitId;
    _maybeFail();
    return nextShare ??
        testShare(
          resourceType: ShareResourceType.outfit,
          wardrobeId: wardrobeId,
          outfitId: outfitId,
        );
  }

  @override
  Future<void> revokeShare(String token) async {
    revokeCalls++;
    lastRevokedToken = token;
    _maybeFail();
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

Share testShare({
  String token = 'shr_abc123xyz',
  ShareResourceType resourceType = ShareResourceType.item,
  String wardrobeId = 'wd_abc123',
  String? itemId = 'item_xyz123',
  String? outfitId,
  String sharePath = '/share/shr_abc123xyz',
}) {
  return Share(
    token: token,
    resourceType: resourceType,
    wardrobeId: wardrobeId,
    itemId: resourceType == ShareResourceType.item ? itemId : null,
    outfitId: resourceType == ShareResourceType.outfit
        ? (outfitId ?? 'outfit_123')
        : null,
    sharePath: sharePath,
    expiresAt: DateTime.utc(2026, 10, 19, 12),
    createdAt: DateTime.utc(2026, 9, 19, 12),
  );
}

import '../../../core/network/api_exception.dart';
import '../domain/share.dart';
import '../domain/share_errors.dart';
import '../domain/share_repository.dart';

/// Soft-stub when [ShareContract.liveEnabled] is off. Never invents a token.
class StubShareRepository implements ShareRepository {
  const StubShareRepository();

  @override
  Future<Share> createItemShare({
    required String wardrobeId,
    required String itemId,
  }) {
    throw const ApiException(
      message: ShareErrors.unavailable,
      code: 'SHARE_UNAVAILABLE',
      statusCode: 404,
    );
  }

  @override
  Future<Share> createOutfitShare({
    required String wardrobeId,
    required String outfitId,
  }) {
    throw const ApiException(
      message: ShareErrors.unavailable,
      code: 'SHARE_UNAVAILABLE',
      statusCode: 404,
    );
  }

  @override
  Future<void> revokeShare(String token) async {}
}

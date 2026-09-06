import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/account/domain/account_repository.dart';
import 'package:wardrobe_app/features/account/domain/account_wipe_summary.dart';

/// In-memory [AccountRepository] for unit and widget tests.
class FakeAccountRepository implements AccountRepository {
  ApiException? nextFailure;
  int clearCalls = 0;
  int deleteCalls = 0;
  AccountWipeSummary clearResult = const AccountWipeSummary(
    keepAccount: true,
    deletedWardrobes: 1,
    deletedItems: 2,
    deletedOutfits: 1,
    deletedS3Objects: 3,
    s3Failures: 0,
  );
  AccountWipeSummary deleteResult = const AccountWipeSummary(
    keepAccount: false,
    deletedWardrobes: 1,
    deletedItems: 2,
    deletedOutfits: 1,
    deletedS3Objects: 3,
    s3Failures: 0,
  );

  @override
  Future<AccountWipeSummary> clearContent() async {
    clearCalls++;
    _maybeFail();
    return clearResult;
  }

  @override
  Future<AccountWipeSummary> deleteAccount() async {
    deleteCalls++;
    _maybeFail();
    return deleteResult;
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

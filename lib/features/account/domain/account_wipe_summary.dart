/// Success body from `DELETE /me/content` and `DELETE /me` (WARDROBE-36).
class AccountWipeSummary {
  const AccountWipeSummary({
    required this.keepAccount,
    required this.deletedWardrobes,
    required this.deletedItems,
    required this.deletedOutfits,
    this.deletedAiProfiles = 0,
    required this.deletedS3Objects,
    required this.s3Failures,
  });

  final bool keepAccount;
  final int deletedWardrobes;
  final int deletedItems;
  final int deletedOutfits;
  final int deletedAiProfiles;
  final int deletedS3Objects;
  final int s3Failures;

  bool get hadS3Failures => s3Failures > 0;

  factory AccountWipeSummary.fromJson(Map<String, dynamic> json) {
    return AccountWipeSummary(
      keepAccount: json['keepAccount'] == true,
      deletedWardrobes: _asInt(json['deletedWardrobes']),
      deletedItems: _asInt(json['deletedItems']),
      deletedOutfits: _asInt(json['deletedOutfits']),
      deletedAiProfiles: _asInt(json['deletedAiProfiles']),
      deletedS3Objects: _asInt(json['deletedS3Objects']),
      s3Failures: _asInt(json['s3Failures']),
    );
  }

  static int _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }

  String get feedbackMessage {
    final parts = <String>[
      if (deletedWardrobes == 1)
        '1 wardrobe'
      else
        '$deletedWardrobes wardrobes',
      if (deletedItems == 1) '1 item' else '$deletedItems items',
      if (deletedOutfits == 1) '1 outfit' else '$deletedOutfits outfits',
      if (deletedAiProfiles == 1)
        '1 AI profile'
      else if (deletedAiProfiles > 0)
        '$deletedAiProfiles AI profiles',
    ];
    final summary = 'Removed ${parts.join(', ')}.';
    if (hadS3Failures) {
      return '$summary Some photos could not be removed from storage.';
    }
    return summary;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AccountWipeSummary &&
            keepAccount == other.keepAccount &&
            deletedWardrobes == other.deletedWardrobes &&
            deletedItems == other.deletedItems &&
            deletedOutfits == other.deletedOutfits &&
            deletedAiProfiles == other.deletedAiProfiles &&
            deletedS3Objects == other.deletedS3Objects &&
            s3Failures == other.s3Failures;
  }

  @override
  int get hashCode => Object.hash(
    keepAccount,
    deletedWardrobes,
    deletedItems,
    deletedOutfits,
    deletedAiProfiles,
    deletedS3Objects,
    s3Failures,
  );
}

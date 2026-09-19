import 'package:flutter_riverpod/misc.dart';
import 'package:wardrobe_app/core/config/app_config.dart';
import 'package:wardrobe_app/features/share/data/dio_share_image_downloader.dart';
import 'package:wardrobe_app/features/share/data/dio_share_repository.dart';
import 'package:wardrobe_app/features/share/data/share_plus_sheet.dart';

import 'fake_share_repository.dart';
import 'fake_share_sheet.dart';

const testShareLandingBaseUrl = 'https://share.example.com';

/// Share fakes so detail screens never hit live Dio or the platform sheet.
List<Override> shareTestOverrides({
  FakeShareRepository? repository,
  FakeShareSheet? sheet,
  FakeShareImageDownloader? images,
  String landingBaseUrl = testShareLandingBaseUrl,
}) {
  return [
    appConfigProvider.overrideWithValue(
      AppConfig(
        apiBaseUrl: 'https://api.example.com',
        shareLandingBaseUrl: landingBaseUrl,
      ),
    ),
    shareRepositoryProvider.overrideWithValue(
      repository ?? FakeShareRepository(),
    ),
    nativeShareSheetProvider.overrideWithValue(sheet ?? FakeShareSheet()),
    shareImageDownloaderProvider.overrideWithValue(
      images ?? FakeShareImageDownloader(),
    ),
  ];
}

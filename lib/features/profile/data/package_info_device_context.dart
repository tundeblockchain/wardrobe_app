import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../domain/device_context.dart';

/// Loads OS + app version for optional support context.
class PackageInfoDeviceContext implements DeviceContext {
  const PackageInfoDeviceContext();

  @override
  Future<DeviceAppInfo> load() async {
    String? appVersion;
    try {
      final info = await PackageInfo.fromPlatform();
      final build = info.buildNumber.trim();
      appVersion = build.isEmpty ? info.version : '${info.version}+$build';
    } catch (_) {
      appVersion = null;
    }

    final device = kIsWeb
        ? 'web'
        : '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';

    return DeviceAppInfo(device: device, appVersion: appVersion);
  }
}

/// Default [DeviceContext]. Override in tests with a fake.
final deviceContextProvider = Provider<DeviceContext>((ref) {
  return const PackageInfoDeviceContext();
});

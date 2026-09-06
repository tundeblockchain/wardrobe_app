/// Optional app / device fields sent as WARDROBE-38 `meta`.
class DeviceAppInfo {
  const DeviceAppInfo({
    this.appVersion,
    this.platform,
    this.deviceModel,
    this.osVersion,
  });

  final String? appVersion;
  final String? platform;
  final String? deviceModel;
  final String? osVersion;

  /// String map for `meta` (max 20 keys on the backend). Omits blanks.
  Map<String, String>? toMeta() {
    final meta = <String, String>{
      if (_present(appVersion)) 'appVersion': appVersion!.trim(),
      if (_present(platform)) 'platform': platform!.trim(),
      if (_present(deviceModel)) 'deviceModel': deviceModel!.trim(),
      if (_present(osVersion)) 'osVersion': osVersion!.trim(),
    };
    return meta.isEmpty ? null : meta;
  }

  String get summary {
    final parts = <String>[
      if (_present(platform)) platform!,
      if (_present(deviceModel)) deviceModel!,
      if (_present(osVersion)) osVersion!,
      if (_present(appVersion)) appVersion!,
    ];
    return parts.join(' · ');
  }

  static bool _present(String? value) =>
      value != null && value.trim().isNotEmpty;
}

/// Loads device / app version for support `meta`. Override in tests.
abstract interface class DeviceContext {
  Future<DeviceAppInfo> load();
}

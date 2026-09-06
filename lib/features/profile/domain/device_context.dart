/// Optional device + app version attached to support POSTs.
class DeviceAppInfo {
  const DeviceAppInfo({this.device, this.appVersion});

  final String? device;
  final String? appVersion;

  bool get isEmpty =>
      (device == null || device!.isEmpty) &&
      (appVersion == null || appVersion!.isEmpty);

  String get summary {
    final parts = <String>[
      if (device != null && device!.isNotEmpty) device!,
      if (appVersion != null && appVersion!.isNotEmpty) appVersion!,
    ];
    return parts.join(' · ');
  }
}

/// Loads device / app version for support forms. Override in tests.
abstract interface class DeviceContext {
  Future<DeviceAppInfo> load();
}

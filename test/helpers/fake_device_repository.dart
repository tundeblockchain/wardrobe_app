import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/inbox/domain/device_registration.dart';
import 'package:wardrobe_app/features/inbox/domain/device_repository.dart';
import 'package:wardrobe_app/features/inbox/domain/push_token_source.dart';

/// In-memory [DeviceRepository] for unit tests.
class FakeDeviceRepository implements DeviceRepository {
  FakeDeviceRepository();

  DeviceRegistration? lastRegistration;
  String? lastToken;
  final List<String> deletedIds = [];
  ApiException? nextFailure;
  int registerCalls = 0;
  int unregisterCalls = 0;

  @override
  Future<DeviceRegistration> register({
    required String token,
    required DevicePlatform platform,
    String? deviceId,
  }) async {
    registerCalls++;
    lastToken = token;
    _maybeFail();
    final registration = DeviceRegistration(
      deviceId: deviceId ?? 'dev_test1234567890',
      platform: platform,
      updatedAt: DateTime.utc(2026, 9, 19, 12),
    );
    lastRegistration = registration;
    return registration;
  }

  @override
  Future<void> unregister(String deviceId) async {
    unregisterCalls++;
    deletedIds.add(deviceId);
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

/// Scripted [PushTokenSource] for tests. Never touches Firebase Messaging.
class FakePushTokenSource implements PushTokenSource {
  FakePushTokenSource({this.token});

  PushToken? token;
  int currentCalls = 0;

  @override
  Future<PushToken?> current() async {
    currentCalls++;
    return token;
  }

  @override
  Stream<String> get tokenRefresh => const Stream.empty();

  @override
  Stream<Map<String, String>> get openedMessages => const Stream.empty();

  @override
  Stream<Map<String, String>> get foregroundMessages => const Stream.empty();

  @override
  Future<Map<String, String>?> initialMessage() async => null;
}

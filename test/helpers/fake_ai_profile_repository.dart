import 'dart:typed_data';

import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_repository.dart';
import 'package:wardrobe_app/features/items/domain/upload_ticket.dart';

AiProfile testPersonalProfile({
  String id = 'profile_personal_1',
  AiProfileStatus status = AiProfileStatus.ready,
  List<String> referenceImages = const [],
  String? previewImageUrl,
}) {
  return AiProfile(
    id: id,
    type: AiProfileType.personal,
    referenceImages: referenceImages,
    status: status,
    previewImageUrl: previewImageUrl,
    createdAt: DateTime.utc(2026, 9, 6, 8),
    updatedAt: DateTime.utc(2026, 9, 6, 8),
  );
}

AiProfile testGenericModel({
  String id = 'profile_generic_01',
  String label = 'Alex',
  String imageKey = 'shared/ai-profiles/generic/alex/front.jpg',
  String? previewImageUrl,
}) {
  return AiProfile(
    id: id,
    type: AiProfileType.genericModel,
    label: label,
    referenceImages: [imageKey],
    status: AiProfileStatus.ready,
    previewImageUrl: previewImageUrl,
    createdAt: DateTime.utc(2026, 9, 6),
    updatedAt: DateTime.utc(2026, 9, 6),
  );
}

List<AiProfile> seededGenericModels() {
  return [
    testGenericModel(),
    testGenericModel(
      id: 'profile_generic_02',
      label: 'Jordan',
      imageKey: 'shared/ai-profiles/generic/jordan/front.jpg',
    ),
    testGenericModel(
      id: 'profile_generic_03',
      label: 'Sam',
      imageKey: 'shared/ai-profiles/generic/sam/front.jpg',
    ),
    testGenericModel(
      id: 'profile_generic_04',
      label: 'Riley',
      imageKey: 'shared/ai-profiles/generic/riley/front.jpg',
    ),
  ];
}

/// In-memory [AiProfileRepository] for unit and widget tests.
class FakeAiProfileRepository implements AiProfileRepository {
  FakeAiProfileRepository({List<AiProfile>? personal, List<AiProfile>? models})
    : personal = [...?personal],
      models = models ?? seededGenericModels();

  final List<AiProfile> personal;
  final List<AiProfile> models;
  ApiException? nextFailure;
  int listPersonalCalls = 0;
  int listModelsCalls = 0;
  int getCalls = 0;
  int createCalls = 0;
  int deleteCalls = 0;
  int createUploadCalls = 0;
  int uploadCalls = 0;
  int attachCalls = 0;
  String? lastContentType;
  int? lastContentLength;
  String? lastUploadUrl;
  Uint8List? lastBytes;
  String? lastObjectKey;

  @override
  Future<List<AiProfile>> listPersonal() async {
    listPersonalCalls++;
    _maybeFail();
    return [...personal];
  }

  @override
  Future<List<AiProfile>> listGenericModels() async {
    listModelsCalls++;
    _maybeFail();
    return [...models];
  }

  @override
  Future<AiProfile> getProfile(String aiProfileId) async {
    getCalls++;
    _maybeFail();
    return _require(aiProfileId);
  }

  @override
  Future<AiProfile> createPersonal() async {
    createCalls++;
    _maybeFail();
    final created = testPersonalProfile(id: 'profile_$createCalls');
    personal.add(created);
    return created;
  }

  @override
  Future<void> deletePersonal(String aiProfileId) async {
    deleteCalls++;
    _maybeFail();
    personal.removeWhere((profile) => profile.id == aiProfileId);
  }

  @override
  Future<UploadTicket> createReferenceUpload({
    required String aiProfileId,
    required String contentType,
    int? contentLength,
  }) async {
    createUploadCalls++;
    lastContentType = contentType;
    lastContentLength = contentLength;
    _maybeFail();
    return UploadTicket(
      uploadUrl: 'https://s3.example.com/ai-profiles/$aiProfileId.jpg',
      objectKey: 'users/uid/ai-profiles/$aiProfileId/ref.jpg',
      expiresIn: 900,
    );
  }

  @override
  Future<void> uploadFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String contentType,
  }) async {
    uploadCalls++;
    lastUploadUrl = uploadUrl;
    lastBytes = bytes;
    lastContentType = contentType;
    _maybeFail();
  }

  @override
  Future<AiProfile> attachReferenceImages({
    required String aiProfileId,
    String? objectKey,
    List<String>? objectKeys,
  }) async {
    attachCalls++;
    lastObjectKey = objectKey ?? objectKeys?.first;
    _maybeFail();
    final keys = <String>[?objectKey, ...?objectKeys];
    final current = _require(aiProfileId);
    final nextKeys = [...current.referenceImages];
    for (final key in keys) {
      if (!nextKeys.contains(key)) {
        nextKeys.add(key);
      }
    }
    final updated = current.copyWith(
      referenceImages: nextKeys,
      updatedAt: DateTime.utc(2026, 9, 6, 9),
    );
    final index = personal.indexWhere((profile) => profile.id == aiProfileId);
    if (index >= 0) {
      personal[index] = updated;
    }
    return updated;
  }

  AiProfile _require(String aiProfileId) {
    for (final profile in [...personal, ...models]) {
      if (profile.id == aiProfileId) {
        return profile;
      }
    }
    throw const ApiException(
      message: 'AI profile not found.',
      code: 'AI_PROFILE_NOT_FOUND',
    );
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

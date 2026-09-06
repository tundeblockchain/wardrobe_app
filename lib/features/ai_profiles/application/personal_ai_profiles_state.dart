import '../domain/ai_profile.dart';

/// Steps shown while attaching a PERSONAL reference photo.
enum AiProfileUploadPhase { idle, uploading, attaching }

/// Immutable list + upload state for PERSONAL AI profiles.
class PersonalAiProfilesState {
  const PersonalAiProfilesState({
    this.profiles = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.uploadingProfileId,
    this.deletingProfileId,
    this.phase = AiProfileUploadPhase.idle,
    this.errorMessage,
  });

  final List<AiProfile> profiles;
  final bool isLoading;
  final bool isCreating;
  final String? uploadingProfileId;
  final String? deletingProfileId;
  final AiProfileUploadPhase phase;
  final String? errorMessage;

  bool get isEmpty => profiles.isEmpty;

  bool get isBusy =>
      isLoading ||
      isCreating ||
      uploadingProfileId != null ||
      deletingProfileId != null;

  String? get progressLabel {
    return switch (phase) {
      AiProfileUploadPhase.uploading => 'Uploading photo…',
      AiProfileUploadPhase.attaching => 'Saving reference photo…',
      AiProfileUploadPhase.idle => null,
    };
  }

  PersonalAiProfilesState copyWith({
    List<AiProfile>? profiles,
    bool? isLoading,
    bool? isCreating,
    String? uploadingProfileId,
    bool clearUploading = false,
    String? deletingProfileId,
    bool clearDeleting = false,
    AiProfileUploadPhase? phase,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PersonalAiProfilesState(
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      uploadingProfileId: clearUploading
          ? null
          : (uploadingProfileId ?? this.uploadingProfileId),
      deletingProfileId: clearDeleting
          ? null
          : (deletingProfileId ?? this.deletingProfileId),
      phase: phase ?? this.phase,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PersonalAiProfilesState &&
            isLoading == other.isLoading &&
            isCreating == other.isCreating &&
            uploadingProfileId == other.uploadingProfileId &&
            deletingProfileId == other.deletingProfileId &&
            phase == other.phase &&
            errorMessage == other.errorMessage &&
            _listEquals(profiles, other.profiles);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(profiles),
    isLoading,
    isCreating,
    uploadingProfileId,
    deletingProfileId,
    phase,
    errorMessage,
  );
}

bool _listEquals(List<AiProfile> a, List<AiProfile> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

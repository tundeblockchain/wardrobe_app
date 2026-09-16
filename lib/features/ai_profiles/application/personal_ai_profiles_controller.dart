import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../items/data/image_picker_item_image_picker.dart';
import '../../items/domain/item_image_picker.dart';
import '../../items/domain/picked_image.dart';
import '../data/dio_ai_profile_repository.dart';
import '../domain/ai_profile.dart';
import '../domain/ai_profile_body_context.dart';
import '../domain/ai_profile_repository.dart';
import 'personal_ai_profiles_state.dart';
import 'selected_ai_profile.dart';

/// Loads PERSONAL AI profiles and handles create / upload / delete.
class PersonalAiProfilesController extends Notifier<PersonalAiProfilesState> {
  @override
  PersonalAiProfilesState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const PersonalAiProfilesState();
    }
    Future<void>.microtask(refresh);
    return const PersonalAiProfilesState(isLoading: true);
  }

  AiProfileRepository get _repository => ref.read(aiProfileRepositoryProvider);

  ItemImagePicker get _picker => ref.read(itemImagePickerProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final profiles = await _repository.listPersonal();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, profiles: profiles);
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<AiProfile?> createPersonal({
    AiProfileBodyContext body = AiProfileBodyContext.empty,
  }) async {
    state = state.copyWith(isCreating: true, clearError: true);
    try {
      final profile = await _repository.createPersonal(body: body);
      if (!ref.mounted) {
        return profile;
      }
      _upsert(profile);
      state = state.copyWith(isCreating: false);
      return profile;
    } on ApiException catch (error) {
      return _failCreate(error.message);
    } catch (_) {
      return _failCreate('Something went wrong. Please try again.');
    }
  }

  Future<void> pickFromCamera(String aiProfileId) =>
      _uploadPicked(aiProfileId, _picker.pickFromCamera);

  Future<void> pickFromGallery(String aiProfileId) =>
      _uploadPicked(aiProfileId, _picker.pickFromGallery);

  Future<void> _uploadPicked(
    String aiProfileId,
    Future<PickedImage?> Function() pick,
  ) async {
    final current = _find(aiProfileId);
    if (current != null && !current.canAddReferenceImage) {
      state = state.copyWith(
        errorMessage:
            'You can add up to $maxAiProfileReferenceImages reference photos.',
      );
      return;
    }

    PickedImage? image;
    try {
      image = await pick();
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(errorMessage: 'Could not open the photo picker.');
      return;
    }
    if (image == null || !ref.mounted) {
      return;
    }

    state = state.copyWith(
      uploadingProfileId: aiProfileId,
      phase: AiProfileUploadPhase.uploading,
      clearError: true,
    );
    try {
      final ticket = await _repository.createReferenceUpload(
        aiProfileId: aiProfileId,
        contentType: image.contentType,
        contentLength: image.bytes.length,
      );
      await _repository.uploadFile(
        uploadUrl: ticket.uploadUrl,
        bytes: image.bytes,
        contentType: image.contentType,
      );
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(phase: AiProfileUploadPhase.attaching);
      final updated = await _repository.attachReferenceImages(
        aiProfileId: aiProfileId,
        objectKey: ticket.objectKey,
      );
      if (!ref.mounted) {
        return;
      }
      _upsert(updated);
      state = state.copyWith(
        clearUploading: true,
        phase: AiProfileUploadPhase.idle,
      );
    } on ApiException catch (error) {
      _failUpload(error.message);
    } catch (_) {
      _failUpload('Something went wrong. Please try again.');
    }
  }

  /// Persists optional body/context fields via `PATCH /ai-profiles/{id}`.
  ///
  /// Empty [bodyContext] clears stored values and does not block try-on.
  Future<bool> updateBodyContext(
    String aiProfileId,
    AiProfileBodyContext bodyContext,
  ) async {
    final current = _find(aiProfileId);
    if (current == null || !current.isPersonal) {
      return false;
    }
    state = state.copyWith(updatingProfileId: aiProfileId, clearError: true);
    try {
      final updated = await _repository.updatePersonal(
        aiProfileId: aiProfileId,
        body: bodyContext,
      );
      if (!ref.mounted) {
        return true;
      }
      _upsert(updated);
      state = state.copyWith(clearUpdating: true);
      return true;
    } on ApiException catch (error) {
      return _failUpdate(error.message);
    } catch (_) {
      return _failUpdate('Something went wrong. Please try again.');
    }
  }

  Future<bool> deletePersonal(String aiProfileId) async {
    state = state.copyWith(deletingProfileId: aiProfileId, clearError: true);
    try {
      await _repository.deletePersonal(aiProfileId);
      if (!ref.mounted) {
        return true;
      }
      state = state.copyWith(
        profiles: [
          for (final profile in state.profiles)
            if (profile.id != aiProfileId) profile,
        ],
        clearDeleting: true,
      );
      final selected = ref.read(selectedAiProfileProvider);
      if (selected?.id == aiProfileId) {
        ref.read(selectedAiProfileProvider.notifier).clear();
      }
      return true;
    } on ApiException catch (error) {
      return _failDelete(error.message);
    } catch (_) {
      return _failDelete('Something went wrong. Please try again.');
    }
  }

  /// Drops the in-memory list after a successful `DELETE /me/content`.
  void clearLocal() {
    state = state.copyWith(
      profiles: const [],
      clearError: true,
      clearUploading: true,
      clearDeleting: true,
      clearUpdating: true,
      phase: AiProfileUploadPhase.idle,
    );
  }

  void _upsert(AiProfile profile) {
    final next = [...state.profiles];
    final index = next.indexWhere((item) => item.id == profile.id);
    if (index >= 0) {
      next[index] = profile;
    } else {
      next.add(profile);
    }
    state = state.copyWith(profiles: next, clearError: true);
    _syncSelected(profile);
  }

  void _syncSelected(AiProfile profile) {
    final selected = ref.read(selectedAiProfileProvider);
    if (selected?.id == profile.id) {
      ref.read(selectedAiProfileProvider.notifier).select(profile);
    }
  }

  AiProfile? _find(String aiProfileId) {
    for (final profile in state.profiles) {
      if (profile.id == aiProfileId) {
        return profile;
      }
    }
    return null;
  }

  AiProfile? _failCreate(String message) {
    if (!ref.mounted) {
      return null;
    }
    state = state.copyWith(isCreating: false, errorMessage: message);
    return null;
  }

  void _failUpload(String message) {
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(
      clearUploading: true,
      phase: AiProfileUploadPhase.idle,
      errorMessage: message,
    );
  }

  bool _failUpdate(String message) {
    if (!ref.mounted) {
      return false;
    }
    state = state.copyWith(clearUpdating: true, errorMessage: message);
    return false;
  }

  bool _failDelete(String message) {
    if (!ref.mounted) {
      return false;
    }
    state = state.copyWith(clearDeleting: true, errorMessage: message);
    return false;
  }
}

final personalAiProfilesControllerProvider =
    NotifierProvider<PersonalAiProfilesController, PersonalAiProfilesState>(
      PersonalAiProfilesController.new,
    );

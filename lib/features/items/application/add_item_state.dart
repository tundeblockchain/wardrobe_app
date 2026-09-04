import '../domain/picked_image.dart';

/// Steps shown while creating an item after the photo is chosen.
enum AddItemPhase { idle, uploading, creating }

/// Immutable add-item form state owned by [AddItemController].
class AddItemState {
  const AddItemState({
    this.pickedImage,
    this.isPicking = false,
    this.isSubmitting = false,
    this.phase = AddItemPhase.idle,
    this.errorMessage,
  });

  final PickedImage? pickedImage;
  final bool isPicking;
  final bool isSubmitting;
  final AddItemPhase phase;
  final String? errorMessage;

  String? get progressLabel {
    return switch (phase) {
      AddItemPhase.uploading => 'Uploading photo…',
      AddItemPhase.creating => 'Saving item…',
      AddItemPhase.idle => null,
    };
  }

  AddItemState copyWith({
    PickedImage? pickedImage,
    bool clearImage = false,
    bool? isPicking,
    bool? isSubmitting,
    AddItemPhase? phase,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddItemState(
      pickedImage: clearImage ? null : (pickedImage ?? this.pickedImage),
      isPicking: isPicking ?? this.isPicking,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      phase: phase ?? this.phase,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AddItemState &&
            pickedImage == other.pickedImage &&
            isPicking == other.isPicking &&
            isSubmitting == other.isSubmitting &&
            phase == other.phase &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode =>
      Object.hash(pickedImage, isPicking, isSubmitting, phase, errorMessage);
}

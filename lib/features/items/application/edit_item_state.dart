import '../domain/picked_image.dart';

/// Immutable edit-form state owned by [EditItemController].
class EditItemState {
  const EditItemState({
    this.replacementImage,
    this.isPicking = false,
    this.isSaving = false,
    this.errorMessage,
  });

  final PickedImage? replacementImage;
  final bool isPicking;
  final bool isSaving;
  final String? errorMessage;

  EditItemState copyWith({
    PickedImage? replacementImage,
    bool clearImage = false,
    bool? isPicking,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditItemState(
      replacementImage: clearImage
          ? null
          : (replacementImage ?? this.replacementImage),
      isPicking: isPicking ?? this.isPicking,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EditItemState &&
            replacementImage == other.replacementImage &&
            isPicking == other.isPicking &&
            isSaving == other.isSaving &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode =>
      Object.hash(replacementImage, isPicking, isSaving, errorMessage);
}

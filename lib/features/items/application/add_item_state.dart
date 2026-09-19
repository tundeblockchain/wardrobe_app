import 'package:flutter/foundation.dart';

import '../domain/item.dart';
import '../domain/picked_image.dart';

/// Steps shown while creating an item after the photo is chosen.
enum AddItemPhase { idle, uploading, creating }

/// One photo in a gallery multi-add batch (WARDROBE-113).
class BatchItemResult {
  const BatchItemResult({
    required this.index,
    required this.image,
    required this.displayName,
    this.item,
    this.errorMessage,
  });

  final int index;
  final PickedImage image;
  final String displayName;
  final Item? item;
  final String? errorMessage;

  bool get succeeded => item != null;

  bool get failed => errorMessage != null;

  BatchItemResult copyWith({Item? item, String? errorMessage}) {
    return BatchItemResult(
      index: index,
      image: image,
      displayName: displayName,
      item: item ?? this.item,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BatchItemResult &&
            index == other.index &&
            image == other.image &&
            displayName == other.displayName &&
            item == other.item &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode =>
      Object.hash(index, image, displayName, item, errorMessage);
}

/// Outcome of a sequential multi-add. Successes are never discarded.
class BatchSubmitResult {
  const BatchSubmitResult({required this.results});

  final List<BatchItemResult> results;

  int get succeededCount => results.where((result) => result.succeeded).length;

  int get failedCount => results.where((result) => result.failed).length;

  bool get allSucceeded => failedCount == 0 && succeededCount > 0;

  bool get hasSuccesses => succeededCount > 0;

  String get summary {
    if (failedCount == 0) {
      return succeededCount == 1
          ? '1 item saved.'
          : '$succeededCount items saved.';
    }
    if (succeededCount == 0) {
      return failedCount == 1 ? '1 item failed.' : '$failedCount items failed.';
    }
    return '$succeededCount saved. $failedCount failed.';
  }
}

/// Immutable add-item form state owned by [AddItemController].
class AddItemState {
  const AddItemState({
    this.pickedImage,
    this.pickedImages = const [],
    this.itemNames = const [],
    this.batchResults = const [],
    this.batchIndex = 0,
    this.isPicking = false,
    this.isSubmitting = false,
    this.phase = AddItemPhase.idle,
    this.errorMessage,
  });

  final PickedImage? pickedImage;
  final List<PickedImage> pickedImages;
  final List<String> itemNames;
  final List<BatchItemResult> batchResults;
  final int batchIndex;
  final bool isPicking;
  final bool isSubmitting;
  final AddItemPhase phase;
  final String? errorMessage;

  bool get isBatch => pickedImages.length > 1;

  int get batchTotal => pickedImages.length;

  String? get progressLabel {
    if (isBatch && isSubmitting) {
      return 'Saving ${batchIndex + 1} of $batchTotal…';
    }
    return switch (phase) {
      AddItemPhase.uploading => 'Uploading photo…',
      AddItemPhase.creating => 'Saving item…',
      AddItemPhase.idle => null,
    };
  }

  AddItemState copyWith({
    PickedImage? pickedImage,
    List<PickedImage>? pickedImages,
    List<String>? itemNames,
    List<BatchItemResult>? batchResults,
    int? batchIndex,
    bool clearImage = false,
    bool? isPicking,
    bool? isSubmitting,
    AddItemPhase? phase,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddItemState(
      pickedImage: clearImage ? null : (pickedImage ?? this.pickedImage),
      pickedImages: clearImage ? const [] : (pickedImages ?? this.pickedImages),
      itemNames: clearImage ? const [] : (itemNames ?? this.itemNames),
      batchResults: clearImage ? const [] : (batchResults ?? this.batchResults),
      batchIndex: batchIndex ?? this.batchIndex,
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
            listEquals(pickedImages, other.pickedImages) &&
            listEquals(itemNames, other.itemNames) &&
            listEquals(batchResults, other.batchResults) &&
            batchIndex == other.batchIndex &&
            isPicking == other.isPicking &&
            isSubmitting == other.isSubmitting &&
            phase == other.phase &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    pickedImage,
    Object.hashAll(pickedImages),
    Object.hashAll(itemNames),
    Object.hashAll(batchResults),
    batchIndex,
    isPicking,
    isSubmitting,
    phase,
    errorMessage,
  );
}

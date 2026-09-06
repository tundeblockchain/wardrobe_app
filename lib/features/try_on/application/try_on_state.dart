import '../../outfits/domain/outfit.dart';
import '../../outfits/domain/outfit_render.dart';

/// Dressing-room screen state owned by [TryOnController].
class TryOnState {
  const TryOnState({
    this.outfit,
    this.render,
    this.isLoading = false,
    this.isSubmitting = false,
    this.isPolling = false,
    this.errorMessage,
  });

  final Outfit? outfit;
  final OutfitRender? render;
  final bool isLoading;
  final bool isSubmitting;
  final bool isPolling;
  final String? errorMessage;

  bool get isBusy => isLoading || isSubmitting || isPolling;

  bool get isInProgress => render?.status.isInProgress ?? false;

  bool get isReady => render?.status == OutfitRenderStatus.ready;

  bool get isFailed => render?.status == OutfitRenderStatus.failed;

  TryOnState copyWith({
    Outfit? outfit,
    bool clearOutfit = false,
    OutfitRender? render,
    bool clearRender = false,
    bool? isLoading,
    bool? isSubmitting,
    bool? isPolling,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TryOnState(
      outfit: clearOutfit ? null : (outfit ?? this.outfit),
      render: clearRender ? null : (render ?? this.render),
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPolling: isPolling ?? this.isPolling,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TryOnState &&
            outfit == other.outfit &&
            render == other.render &&
            isLoading == other.isLoading &&
            isSubmitting == other.isSubmitting &&
            isPolling == other.isPolling &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    outfit,
    render,
    isLoading,
    isSubmitting,
    isPolling,
    errorMessage,
  );
}

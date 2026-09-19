import '../domain/worn_on_date.dart';
import '../domain/worn_on_entry.dart';

/// Outfit-detail worn-on log owned by [OutfitWornOnController].
class OutfitWornOnState {
  const OutfitWornOnState({
    this.entries = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
  });

  final List<WornOnEntry> entries;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;

  bool get isEmpty => entries.isEmpty;

  bool hasDate(DateTime date) {
    final day = WornOnDate.dateOnly(date);
    return entries.any((entry) => WornOnDate.isSameDay(entry.wornOn, day));
  }

  OutfitWornOnState copyWith({
    List<WornOnEntry>? entries,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OutfitWornOnState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OutfitWornOnState &&
            _listEquals(entries, other.entries) &&
            isLoading == other.isLoading &&
            isSaving == other.isSaving &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(entries), isLoading, isSaving, errorMessage);
}

bool _listEquals(List<WornOnEntry> left, List<WornOnEntry> right) {
  if (identical(left, right)) {
    return true;
  }
  if (left.length != right.length) {
    return false;
  }
  for (var i = 0; i < left.length; i++) {
    if (left[i] != right[i]) {
      return false;
    }
  }
  return true;
}

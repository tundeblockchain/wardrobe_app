import '../domain/worn_on_date.dart';
import '../domain/worn_on_entry.dart';

/// Wardrobe calendar state owned by [WardrobeWornOnController].
class WardrobeWornOnState {
  const WardrobeWornOnState({
    required this.visibleMonth,
    this.entries = const [],
    this.selectedDay,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
  });

  final DateTime visibleMonth;
  final List<WornOnEntry> entries;
  final DateTime? selectedDay;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;

  bool get isEmpty => entries.isEmpty;

  List<WornOnEntry> get visibleEntries {
    final selected = selectedDay;
    if (selected == null) {
      return entries;
    }
    return [
      for (final entry in entries)
        if (WornOnDate.isSameDay(entry.wornOn, selected)) entry,
    ];
  }

  Set<DateTime> get markedDays => {
    for (final entry in entries) WornOnDate.dateOnly(entry.wornOn),
  };

  WardrobeWornOnState copyWith({
    DateTime? visibleMonth,
    List<WornOnEntry>? entries,
    DateTime? selectedDay,
    bool clearSelectedDay = false,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WardrobeWornOnState(
      visibleMonth: visibleMonth ?? this.visibleMonth,
      entries: entries ?? this.entries,
      selectedDay: clearSelectedDay ? null : (selectedDay ?? this.selectedDay),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WardrobeWornOnState &&
            visibleMonth == other.visibleMonth &&
            _listEquals(entries, other.entries) &&
            selectedDay == other.selectedDay &&
            isLoading == other.isLoading &&
            isSaving == other.isSaving &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    visibleMonth,
    Object.hashAll(entries),
    selectedDay,
    isLoading,
    isSaving,
    errorMessage,
  );
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

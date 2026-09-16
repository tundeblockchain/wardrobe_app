import '../domain/shopping_link.dart';

/// Immutable shopping-links section state. Failures stay local to this UI.
class ShoppingLinksState {
  const ShoppingLinksState({
    this.links = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ShoppingLink> links;
  final bool isLoading;
  final String? errorMessage;

  bool get isEmpty => links.isEmpty;

  /// True when the API failed and there is nothing to show.
  bool get isUnavailable => errorMessage != null && links.isEmpty;

  ShoppingLinksState copyWith({
    List<ShoppingLink>? links,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ShoppingLinksState(
      links: links ?? this.links,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ShoppingLinksState &&
            isLoading == other.isLoading &&
            errorMessage == other.errorMessage &&
            _listEquals(links, other.links);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(links), isLoading, errorMessage);
}

bool _listEquals(List<ShoppingLink> a, List<ShoppingLink> b) {
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

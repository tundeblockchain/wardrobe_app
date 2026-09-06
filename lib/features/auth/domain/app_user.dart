/// Authenticated user as seen by the presentation/controller layers.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.providerId,
  });

  final String uid;
  final String? email;
  final String? displayName;

  /// Firebase provider id, e.g. `password` or `google.com`.
  final String? providerId;

  /// Human-readable sign-in method when [providerId] is known.
  String? get providerLabel {
    switch (providerId) {
      case 'password':
        return 'Email';
      case 'google.com':
        return 'Google';
      case 'apple.com':
        return 'Apple';
      case null:
      case '':
        return null;
      default:
        return providerId;
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppUser &&
            uid == other.uid &&
            email == other.email &&
            displayName == other.displayName &&
            providerId == other.providerId;
  }

  @override
  int get hashCode => Object.hash(uid, email, displayName, providerId);

  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, displayName: $displayName, '
      'providerId: $providerId)';
}

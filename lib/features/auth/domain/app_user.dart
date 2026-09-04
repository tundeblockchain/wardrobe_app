/// Authenticated user as seen by the presentation/controller layers.
class AppUser {
  const AppUser({required this.uid, this.email});

  final String uid;
  final String? email;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppUser && uid == other.uid && email == other.email;
  }

  @override
  int get hashCode => Object.hash(uid, email);

  @override
  String toString() => 'AppUser(uid: $uid, email: $email)';
}

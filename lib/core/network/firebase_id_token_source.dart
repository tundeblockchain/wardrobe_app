import 'package:firebase_auth/firebase_auth.dart';

import 'id_token_source.dart';

/// Reads a fresh ID token from [FirebaseAuth.currentUser] on each call.
class FirebaseIdTokenSource implements IdTokenSource {
  const FirebaseIdTokenSource(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) {
    final user = _auth.currentUser;
    if (user == null) {
      return Future<String?>.value(null);
    }
    return user.getIdToken(forceRefresh);
  }
}

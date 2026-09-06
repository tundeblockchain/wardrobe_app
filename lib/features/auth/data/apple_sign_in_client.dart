import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Tokens returned by the native Sign in with Apple sheet.
class AppleIdTokens {
  const AppleIdTokens({
    required this.identityToken,
    required this.authorizationCode,
    this.givenName,
    this.familyName,
  });

  final String? identityToken;
  final String authorizationCode;
  final String? givenName;
  final String? familyName;
}

/// Abstraction over [SignInWithApple.getAppleIDCredential] for tests.
abstract class AppleSignInClient {
  Future<AppleIdTokens> getAppleIdCredential({required String nonce});
}

/// Production client that opens the system Sign in with Apple UI.
class PluginAppleSignInClient implements AppleSignInClient {
  const PluginAppleSignInClient();

  @override
  Future<AppleIdTokens> getAppleIdCredential({required String nonce}) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    return AppleIdTokens(
      identityToken: credential.identityToken,
      authorizationCode: credential.authorizationCode,
      givenName: credential.givenName,
      familyName: credential.familyName,
    );
  }
}

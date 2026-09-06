# Local configuration (no secrets in git)

Copy these placeholders into a **local** file that is **not committed**
(for example `dart_defines.json`, which matches `.gitignore` patterns such as
`*.secret` / env files — keep it outside the repo or gitignored).

`lib/firebase_options.dart` is gitignored. Do not commit real
`google-services.json` or `GoogleService-Info.plist`.

## Dart defines

```json
{
  "API_BASE_URL": "https://your-api.example.com",
  "FIREBASE_API_KEY": "your-firebase-api-key",
  "FIREBASE_APP_ID": "1:000000000000:web:your-app-id",
  "FIREBASE_MESSAGING_SENDER_ID": "000000000000",
  "FIREBASE_PROJECT_ID": "your-project-id",
  "FIREBASE_AUTH_DOMAIN": "your-project-id.firebaseapp.com",
  "FIREBASE_STORAGE_BUCKET": "your-project-id.appspot.com",
  "GOOGLE_SERVER_CLIENT_ID": "your-web-client-id.apps.googleusercontent.com",
  "IOS_APP_STORE_ID": "your-ios-app-store-id"
}
```

Run:

```bash
flutter run --dart-define-from-file=dart_defines.json
```

Or generate `lib/firebase_options.dart` locally with FlutterFire CLI and keep it
gitignored. This app reads options from dart-defines so CI never needs real keys.

Optional `GOOGLE_SERVER_CLIENT_ID` is the **Web** OAuth client ID from
Firebase (Google provider). Android needs it to mint an ID token for
`signInWithCredential`. See [docs/google-sign-in.md](google-sign-in.md).
Do **not** commit real client IDs or `google-services.json` /
`GoogleService-Info.plist`.

Optional `IOS_APP_STORE_ID` is used when in-app review is unavailable and the
client opens the App Store listing. It is not a secret.

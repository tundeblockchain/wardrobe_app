# Google / Gmail sign-in (WARDROBE-25)

The app signs in with Google on-device, then sends the Firebase ID token to the
backend the same way as email/password (`Authorization: Bearer <idToken>`).
**No backend change is required** if the API already accepts Google-linked
Firebase ID tokens.

Do **not** commit secrets, `google-services.json`, `GoogleService-Info.plist`,
or `lib/firebase_options.dart` (they are gitignored).

## What Tunde must do in Firebase / Google Cloud

### 1. Enable the Google provider

1. Open [Firebase Console](https://console.firebase.google.com/) → the Wardrobe
   project.
2. **Authentication** → **Sign-in method**.
3. Enable **Google**.
4. Set a support email (project owner is fine).
5. Save. Firebase creates a **Web** OAuth 2.0 client automatically. Copy the
   **Web client ID** (`….apps.googleusercontent.com`). Android needs this as
   `GOOGLE_SERVER_CLIENT_ID` so `GoogleSignIn` can mint an ID token for
   `FirebaseAuth.signInWithCredential`.

### 2. Android: SHA-1 + OAuth client

Google Sign-In on Android fails with `10:` / `DEVELOPER_ERROR` unless the
debug (and later release) SHA-1 is registered.

1. From the repo:

   ```bash
   cd android
   ./gradlew signingReport
   ```

   Copy the **SHA-1** for the `debug` variant (and later the release keystore).

2. Firebase Console → **Project settings** → your Android app
   (`com.example.wardrobe_app` unless you changed `applicationId`).
3. **Add fingerprint** → paste SHA-1 → Save.
4. Download a fresh **`google-services.json`** and keep it **local only**
   (`android/app/google-services.json` is gitignored).
5. Confirm Google Cloud → **APIs & Services** → **Credentials** has:
   - Android OAuth client (package name + SHA-1)
   - Web OAuth client (used as `serverClientId`)

If you change package name or signing keys, add a new SHA-1 / OAuth client.

### 3. iOS: URL scheme + GoogleService-Info

1. Firebase Console → **Project settings** → iOS app (bundle ID must match
   Xcode, typically `com.example.wardrobeApp`).
2. Download **`GoogleService-Info.plist`** and keep it **local only**
   (`ios/Runner/GoogleService-Info.plist` is gitignored).
3. Open the plist and copy `REVERSED_CLIENT_ID`
   (`com.googleusercontent.apps.…`).
4. In Xcode → Runner → **Info** → **URL Types**, add a URL scheme equal to
   that `REVERSED_CLIENT_ID`. Equivalently, in `ios/Runner/Info.plist`:

   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```

   Use the real value from the plist. Do not commit a production client ID.

### 4. Local dart-defines

See [local-config.example.md](local-config.example.md). Add:

```json
"GOOGLE_SERVER_CLIENT_ID": "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com"
```

Then:

```bash
flutter run --dart-define-from-file=dart_defines.json
```

Email/password and password reset keep working without this define; Google
sign-in on Android typically needs it.

### 5. Authorized domains (if you also test web)

Firebase **Authentication** → **Settings** → **Authorized domains** should
include `localhost` for local web. This PR does not add a web Google button
flow.

## App behaviour

- Login and signup both offer **Continue with Google**.
- Cancel / dismiss of the account picker is silent (no error banner).
- `account-exists-with-different-credential` tells the user to sign in with
  email and password.
- Sign-out calls `GoogleSignIn.disconnect()` (best-effort) so the next Google
  pick is not stuck on the previous account, then `FirebaseAuth.signOut()`.

## Out of scope

Apple sign-in and Phase-3 try-on.

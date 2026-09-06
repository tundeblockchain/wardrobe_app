# Google / Gmail sign-in (WARDROBE-25 / WARDROBE-39)

The app signs in with Google on-device, then sends the Firebase ID token to the
backend the same way as email/password (`Authorization: Bearer <idToken>`).
**No backend change is required** if the API already accepts Google-linked
Firebase ID tokens.

Do **not** commit secrets, `google-services.json`, `GoogleService-Info.plist`,
or `lib/firebase_options.dart` (they are gitignored).

## Canonical app id

Both mobile platforms now use the same identifier
([WARDROBE-39](https://tundetunde000.atlassian.net/browse/WARDROBE-39)):

| Platform | Setting | Value |
| --- | --- | --- |
| Android | `applicationId` and `namespace` | `com.tundetunde.wardrobe` |
| iOS | `PRODUCT_BUNDLE_IDENTIFIER` / `CFBundleIdentifier` | `com.tundetunde.wardrobe` |

If Firebase, Google Sign-In, Play Console, or App Store Connect still list
`com.example.wardrobe_app` or `com.example.wardrobeApp`, add (or recreate) apps
and OAuth clients for **`com.tundetunde.wardrobe`**. The old example ids will
not match this binary.

## What Tunde must do in Firebase / Google Cloud

### 1. Add Android and iOS apps with this id (if they are not already there)

1. Open [Firebase Console](https://console.firebase.google.com/) → the Wardrobe
   project.
2. **Project settings** → **Your apps**.
3. **Add app** → Android. Package name must be exactly
   `com.tundetunde.wardrobe`. Nickname can be "Wardrobe Android".
4. **Add app** → iOS. Bundle ID must be exactly `com.tundetunde.wardrobe`.
   Nickname can be "Wardrobe iOS". App Store ID can wait until the listing
   exists.
5. If an older app still uses `com.example.wardrobe_app` /
   `com.example.wardrobeApp`, leave it or delete it later — **do not** point
   this Flutter client at those ids. Download configs only from the
   `com.tundetunde.wardrobe` apps.

### 2. Enable the Google provider

1. **Authentication** → **Sign-in method**.
2. Enable **Google**.
3. Set a support email (project owner is fine).
4. Save. Firebase creates a **Web** OAuth 2.0 client automatically. Copy the
   **Web client ID** (`….apps.googleusercontent.com`). Android needs this as
   `GOOGLE_SERVER_CLIENT_ID` so `GoogleSignIn` can mint an ID token for
   `FirebaseAuth.signInWithCredential`.

### 3. Android: download config + SHA-1 OAuth client

Google Sign-In on Android fails with `10:` / `DEVELOPER_ERROR` unless the
debug (and later release) SHA-1 is registered on the
`com.tundetunde.wardrobe` Android app.

1. From the repo:

   ```bash
   cd android
   ./gradlew signingReport
   ```

   Copy the **SHA-1** for the `debug` variant (and later the release keystore).

2. Firebase Console → **Project settings** → Android app
   **`com.tundetunde.wardrobe`**.
3. **Add fingerprint** → paste SHA-1 → Save.
4. Download a fresh **`google-services.json`** for this package name and keep
   it **local only** (`android/app/google-services.json` is gitignored).
5. Confirm Google Cloud → **APIs & Services** → **Credentials** has:
   - Android OAuth client (package name `com.tundetunde.wardrobe` + SHA-1)
   - Web OAuth client (used as `serverClientId`)

If you change package name or signing keys, add a new SHA-1 / OAuth client
and download a new `google-services.json`. The committed `applicationId` is
now `com.tundetunde.wardrobe`; an OAuth client for the old example package
will not work.

### 4. iOS: download config + URL scheme

1. Firebase Console → **Project settings** → iOS app
   **`com.tundetunde.wardrobe`** (must match Xcode
   `PRODUCT_BUNDLE_IDENTIFIER`).
2. Download **`GoogleService-Info.plist`** and keep it **local only**
   (`ios/Runner/GoogleService-Info.plist` is gitignored). Confirm
   `BUNDLE_ID` inside the plist is `com.tundetunde.wardrobe`.
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

### 5. Store listings (Play Console / App Store Connect)

Create the store apps with the same id before a first upload:

- **Google Play Console** → Create app → package name
  `com.tundetunde.wardrobe` (cannot change after the first upload).
- **App Store Connect** → New app → Bundle ID
  `com.tundetunde.wardrobe` (register it first in
  [Apple Developer](https://developer.apple.com/account/resources/identifiers/list)
  if it is not already there).
- After the iOS listing exists, paste the numeric App Store ID into local
  `IOS_APP_STORE_ID` (see [local-config.example.md](local-config.example.md))
  so Rate the app can open the store listing.

### 6. Local dart-defines

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

After adding the Firebase Android/iOS apps, refresh local dart-defines
(`FIREBASE_APP_ID` and related values) from the **new** apps. Do not commit
`lib/firebase_options.dart`.

### 7. Authorized domains (if you also test web)

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

Phase-3 try-on. Sign in with Apple is documented in
[apple-sign-in.md](apple-sign-in.md) ([WARDROBE-52](https://tundetunde000.atlassian.net/browse/WARDROBE-52)).

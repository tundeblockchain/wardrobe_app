# Sign in with Apple (WARDROBE-52)

The app offers **Sign in with Apple on iOS only**. The native sheet comes from
`sign_in_with_apple`. The identity token is exchanged with Firebase Auth via
`OAuthProvider('apple.com')` + `signInWithCredential`. The client then sends the
Firebase ID token to the backend the same way as email/password and Google
(`Authorization: Bearer <idToken>`). **No backend change is required.**

The Apple button is **hidden on Android**. Do **not** commit secrets, `.p8`
keys, `google-services.json`, `GoogleService-Info.plist`, or
`lib/firebase_options.dart` (they are gitignored).

## Canonical app id

| Platform | Setting | Value |
| --- | --- | --- |
| iOS | `PRODUCT_BUNDLE_IDENTIFIER` / `CFBundleIdentifier` | `com.tundetunde.wardrobe` |
| Android | `applicationId` / `namespace` | `com.tundetunde.wardrobe` (no Apple button) |

## What operators must do in Apple Developer + Firebase

A paid [Apple Developer Program](https://developer.apple.com/programs/)
membership is required. Sign in with Apple is not available on a free Apple ID.

### 1. App ID capability

1. Open [Identifiers](https://developer.apple.com/account/resources/identifiers/list)
   → App IDs → **`com.tundetunde.wardrobe`**.
2. Enable **Sign In with Apple**.
   - For this single app, leave **Enable as a primary App ID**.
3. Save. If Xcode does not manage signing automatically, regenerate the
   provisioning profile so it includes the new capability.

This repo already ships `ios/Runner/Runner.entitlements` with
`com.apple.developer.applesignin`. In Xcode → Runner → **Signing &
Capabilities**, confirm **Sign in with Apple** is listed.

### 2. Services ID (Firebase Apple provider)

Firebase still needs a Services ID even though this client only shows the
button on iOS.

1. [Identifiers](https://developer.apple.com/account/resources/identifiers/list/serviceId)
   → **+** → **Services IDs**.
2. Description: `Wardrobe Sign in with Apple`.
3. Identifier (example — pick one you do not already use):
   `com.tundetunde.wardrobe.signin`.
4. Register, then open the new Services ID.
5. Enable **Sign In with Apple** → **Configure**:
   - Primary App ID: `com.tundetunde.wardrobe`.
   - **Domains and Subdomains**: `{FIREBASE_PROJECT_ID}.firebaseapp.com`
   - **Return URLs**:
     `https://{FIREBASE_PROJECT_ID}.firebaseapp.com/__/auth/handler`
6. Save. Copy the Services ID string — it is the Firebase **Service ID**.

Replace `{FIREBASE_PROJECT_ID}` with the real Firebase project id (Project
settings). Do not invent a domain.

### 3. Sign in with Apple key

1. [Keys](https://developer.apple.com/account/resources/authkeys/list) → **+**.
2. Key Name: `Wardrobe Sign in with Apple`.
3. Enable **Sign In with Apple** → **Configure** → Primary App ID
   `com.tundetunde.wardrobe` → Save.
4. Continue → Register.
5. **Download the `.p8` once** and store it in a password manager. It cannot
   be downloaded again. **Do not commit it** (`.gitignore` already blocks
   `*.p8`).
6. Note the **Key ID** shown on that page.
7. Note the **Team ID** (Membership / top-right of the developer account).

### 4. Enable Apple in Firebase Auth

1. [Firebase Console](https://console.firebase.google.com/) → Wardrobe project.
2. Confirm an iOS app exists with bundle id **`com.tundetunde.wardrobe`**
   (see [google-sign-in.md](google-sign-in.md)).
3. **Authentication** → **Sign-in method** → **Apple** → Enable.
4. **Service ID**: the Services ID from step 2
   (`com.tundetunde.wardrobe.signin`).
5. **OAuth code flow configuration**:
   - Apple Team ID
   - Key ID
   - Private key (paste the `.p8` contents into the Firebase field — do not
     put that file in git)
6. Save.

### 5. Private email relay (recommended)

Users can hide their email; Apple then gives
`…@privaterelay.appleid.com`. If Firebase (or the app) emails those users:

1. Apple Developer → **More** / Services → **Sign in with Apple for Email
   Communication** (private email relay).
2. Register `noreply@{FIREBASE_PROJECT_ID}.firebaseapp.com` (or your custom
   Firebase email template domain).

### 6. Local dart-defines

No extra dart-define is required for Apple. Keep using the existing
`FIREBASE_*` values from [local-config.example.md](local-config.example.md)
and [google-sign-in.md](google-sign-in.md). Refresh `FIREBASE_APP_ID` from
the `com.tundetunde.wardrobe` iOS app if it is still pointing at the old
example bundle id.

## App behaviour

- Login and signup show **Continue with Apple** on iOS, under Google.
- Android never shows the Apple button.
- Cancel / dismiss of the Apple sheet is silent (no error banner).
- `account-exists-with-different-credential` tells the user to sign in with
  email and password.
- Email/password and Google flows are unchanged.
- The backend still sees a Firebase ID token. Apple vs Google vs password is
  a Firebase provider, not an API-Gateway contract change.

## Out of scope

Android / web Apple sign-in. Token revocation extras beyond the existing
delete-account flow.

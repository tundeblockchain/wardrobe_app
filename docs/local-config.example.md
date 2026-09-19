# Local configuration (no secrets in git)

Copy these placeholders into a **local** file that is **not committed**
(for example `dart_defines.json`, which matches `.gitignore` patterns such as
`*.secret` / env files — keep it outside the repo or gitignored).

`lib/firebase_options.dart` is gitignored. Do not commit real
`google-services.json` or `GoogleService-Info.plist`.

Firebase Android/iOS apps and store listings must use app id
`com.tundetunde.wardrobe`. See [google-sign-in.md](google-sign-in.md).

## Dart defines

```json
{
  "API_BASE_URL": "https://your-api.example.com",
  "SHARE_LANDING_BASE_URL": "https://share.example.com",
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

Sign in with Apple (iOS) does not add a dart-define. Operators still need the
Apple Developer capability, Services ID, and Firebase Apple provider — see
[apple-sign-in.md](apple-sign-in.md). Never commit the Apple `.p8` key.

Optional `IOS_APP_STORE_ID` is used when in-app review is unavailable and the
client opens the App Store listing. It is not a secret.

Optional `SHARE_LANDING_BASE_URL` is the public landing-site origin used
to turn Backend `sharePath` (`/share/{token}`) into an absolute URL for
the native share sheet
([WARDROBE-128](https://tundetunde000.atlassian.net/browse/WARDROBE-128)).
It is not a secret. Do **not** hardcode a production host in source.
Missing or invalid values soft-fail with a snackbar.

## Superwall (WARDROBE-90)

Public Superwall API keys and store product IDs are dart-defines — never commit
dashboard secrets. Product IDs stay placeholders until App Store / Play
products exist.

```json
{
  "SUPERWALL_API_KEY": "your-superwall-public-api-key",
  "SUPERWALL_IOS_API_KEY": "your-ios-superwall-key",
  "SUPERWALL_ANDROID_API_KEY": "your-android-superwall-key",
  "SUPERWALL_PRODUCT_BASIC_MONTHLY": "wardrobe_basic_monthly",
  "SUPERWALL_PRODUCT_BASIC_YEARLY": "wardrobe_basic_yearly",
  "SUPERWALL_PRODUCT_PREMIUM_MONTHLY": "wardrobe_premium_monthly",
  "SUPERWALL_PRODUCT_PREMIUM_YEARLY": "wardrobe_premium_yearly"
}
```

Target prices for dashboard offerings:

- Basic: £5/month or £50/year
- Premium: £15/month or £150/year

Placement hooks the app registers: `wardrobe_limit`, `item_limit`,
`outfit_limit` (Basic), `ai_try_on`, `other_ai` (Premium), plus
`upgrade_basic` / `upgrade_premium` from Account.

Entitlements are read from `GET /me` only (wardrobe-backend#46, merged
`a837463`). Dynamo via Backend is the source of truth — no Firebase custom
claims. Superwall `identify` uses the Firebase UID. The Superwall webhook
is Backend-side.

`tier` is `FREE` | `BASIC` | `PREMIUM`. Denial `code` + `message` on 403
map to Superwall (`ENTITLEMENT_WARDROBE_LIMIT` / `ENTITLEMENT_ITEM_LIMIT` /
`ENTITLEMENT_OUTFIT_LIMIT` → Basic; `ENTITLEMENT_AI_REQUIRED` → Premium).
Unknown `ENTITLEMENT_*` codes soft-fail to a generic Upgrade / See plans
CTA ([WARDROBE-117](https://tundetunde000.atlassian.net/browse/WARDROBE-117)).
The themed fallback sheet and Account **Restore purchases** action call
the same Superwall / store restore hook, then refresh `GET /me` — use
this after delete or reinstall. Do not put dashboard secrets in git.

Account delete also calls Superwall cancel when the SDK exposes it
([WARDROBE-102](https://tundetunde000.atlassian.net/browse/WARDROBE-102)).
Today the Flutter SDK has no store-cancel API, so the client hook returns
skipped and Backend `DELETE /me` (WARDROBE-103, wardrobe-backend#49 merge
SHA `3f9b38a`, not pre-merge `e312d55`) owns cancel/revoke. Flutter types
that locked 200 body. Unset `subscription` optionals are omitted.

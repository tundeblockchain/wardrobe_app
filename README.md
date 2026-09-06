# wardrobe_app

Digital Wardrobe mobile client (Flutter). Phase 1 currently includes repo
bootstrap ([WARDROBE-10](https://tundetunde000.atlassian.net/browse/WARDROBE-10)),
the Firebase auth shell
([WARDROBE-9](https://tundetunde000.atlassian.net/browse/WARDROBE-9)),
wardrobe list / create / detail
([WARDROBE-12](https://tundetunde000.atlassian.net/browse/WARDROBE-12)), and
clothing items with camera/gallery upload
([WARDROBE-13](https://tundetunde000.atlassian.net/browse/WARDROBE-13)),
Android Photo Picker without `READ_MEDIA_IMAGES`
([WARDROBE-40](https://tundetunde000.atlassian.net/browse/WARDROBE-40)), and
outfit build / save
([WARDROBE-14](https://tundetunde000.atlassian.net/browse/WARDROBE-14)), and
AI outfit recommendations
([WARDROBE-24](https://tundetunde000.atlassian.net/browse/WARDROBE-24)), and
profile menu / support forms
([WARDROBE-34](https://tundetunde000.atlassian.net/browse/WARDROBE-34)), and
clear-all / delete-account flows
([WARDROBE-35](https://tundetunde000.atlassian.net/browse/WARDROBE-35)), and
Phase-3 AI profile setup / generic-model picker
([WARDROBE-50](https://tundetunde000.atlassian.net/browse/WARDROBE-50)).

## Architecture

Layers (dependencies point downward only):

1. **Presentation** — screens (`login`, `signup`, `forgot-password`, splash, wardrobes list / create / detail, add item / item detail / edit item, outfits list / create / detail / edit, profile / contact us / report a bug / AI try-on)
2. **Controller / Provider** — Riverpod auth, wardrobe, item, outfit, recommendation, support / rate-app, account, and AI-profile controllers
3. **Repository** — `AuthRepository`, `WardrobeRepository`, `ItemRepository`, `UploadRepository`, `OutfitRepository`, `RecommendationRepository`, `SupportRepository`, `AccountRepository`, `AiProfileRepository`
4. **API client / Firebase** — `FirebaseAuthRepository` (email/password + Google), Dio + ID-token interceptor, wardrobe/item/upload/outfit/recommendation/support/account/AI-profile Dio repositories, `image_picker` behind `ItemImagePicker`, `in_app_review` behind `AppReviewer`

## Auth shell

- Email/password and Google / Gmail via `firebase_auth` + `google_sign_in`.
  Firebase console setup: [docs/google-sign-in.md](docs/google-sign-in.md).
- `go_router` restores on splash, sends signed-out users to `/login`, and signed-in users to `/wardrobes`.
- Dio attaches `Authorization: Bearer <idToken>` from
  `FirebaseAuth.currentUser.getIdToken()` on **each** request. Tokens are never
  persisted in app state.

## Wardrobes

Authenticated routes:

- `/profile` — account info, AI try-on, Rate the app, Contact us, Report a bug, Clear all, Delete account
- `/profile/ai-try-on` — PERSONAL AI profile + GENERIC_MODEL catalog
- `/profile/contact` — in-app form → `POST /support/contact`
- `/profile/report-bug` — in-app form → `POST /support/bug` (optional `replyTo` + `meta`)
- `/wardrobes` — list + empty state (account icon → `/profile`)
- `/wardrobes/create` — name form
- `/wardrobes/:wardrobeId` — detail, rename, delete, item list, outfits entry, suggestions entry

The Dio client matches the backend contract (`GET/POST /wardrobes`,
`GET/PATCH/DELETE /wardrobes/{wardrobeId}`). Response `wardrobeId` is mapped to
domain `id`. Shared API errors (`{ "code", "message" }` or
`{ "error": { "code", "message" } }`) become `ApiException`.

Backend wardrobe CRUD (WARDROBE-5) may not be live yet; the client is scaffolded
against that contract and covered with mocked unit tests.

## Items and uploads

Authenticated routes nested under a wardrobe:

- `/wardrobes/:wardrobeId/items/create` — camera/gallery + metadata
- `/wardrobes/:wardrobeId/items/:itemId` — item detail, delete
- `/wardrobes/:wardrobeId/items/:itemId/edit` — edit metadata (optional new photo)

Upload flow:

1. `POST /uploads` with `{ "contentType", "purpose": "WARDROBE_ITEM" }`
2. `PUT` file bytes to the returned `uploadUrl` with that content type (no Firebase Bearer header)
3. `POST /wardrobes/{wardrobeId}/items` with `{ "name", "category", "imageKey" }`

Response `itemId` maps to domain `id`. Image keys stay on the domain as
`originalImageKey` / `processedImageKey`. Wardrobe item browse is a
Tinder-style card stack (WARDROBE-41): swipe left / right / up (or Next item)
to advance; tap the card or View details to open the existing item screen.
Cards prefer the processed image when present, otherwise the original, and
still show `processingStatus` (`PENDING` / `PROCESSING` / `READY` / `FAILED`).
An empty wardrobe keeps the existing empty state. Category / colour /
subcategory chips still send WARDROBE-21 query params to
`GET /wardrobes/{wardrobeId}/items` and filter the card deck. The client
refetches on pull-to-refresh, app resume, and route re-entry (no websockets).
Camera/gallery is abstracted as `ItemImagePicker` so unit tests never need a
device. On Android, gallery uses the system Photo Picker (no
`READ_MEDIA_IMAGES`); camera still uses `CAMERA`. See
[docs/android-photo-picker.md](docs/android-photo-picker.md).

Backend item/upload APIs (WARDROBE-8 / WARDROBE-11) may not be live yet; the
client is scaffolded against the contract with mocked unit tests.

## Outfits

Authenticated routes nested under a wardrobe:

- `/wardrobes/:wardrobeId/outfits` — list + empty state
- `/wardrobes/:wardrobeId/outfits/create` — name + pick items into slots
- `/wardrobes/:wardrobeId/outfits/:outfitId` — detail, delete
- `/wardrobes/:wardrobeId/outfits/:outfitId/edit` — rename and change slots

Slots use the same categories as items (`TOP`, `BOTTOM`, `DRESS`, `OUTERWEAR`,
`SHOES`, `ACCESSORY`, `BAG`). The create/edit forms reuse the wardrobe items
list so only items from that wardrobe can be assigned. Response `outfitId`
maps to domain `id`.

Backend outfits API (WARDROBE-7) may not be live yet; the client is scaffolded
against the contract with mocked unit tests. No AI try-on.

## Recommendations

Authenticated routes nested under a wardrobe:

- `/wardrobes/:wardrobeId/recommendations` — suggested looks + empty/error
- `/wardrobes/:wardrobeId/recommendations/:index` — slot preview; Save creates
  an outfit via the existing `POST /wardrobes/{wardrobeId}/outfits` body
  (`name` + `items[{itemId,slot}]`)

Suggestions are never auto-saved. The feature is additive: if
`GET /wardrobes/{wardrobeId}/recommendations` fails, wardrobe/item/outfit
flows still work and the suggestions entry shows an unavailable state.

No Phase-3 virtual try-on inference (that is WARDROBE-51).

## AI profiles (WARDROBE-50)

Authenticated route from the profile menu:

- `/profile/ai-try-on` — create / manage a PERSONAL AI profile and browse seeded GENERIC_MODEL looks

Flutter talks to the WARDROBE-43/44/45 contract through the shared Dio client (Firebase ID token interceptor). **No try-on API** and **no Resend**.

```http
POST   /ai-profiles
GET    /ai-profiles
GET    /ai-profiles/models
GET    /ai-profiles/{aiProfileId}
DELETE /ai-profiles/{aiProfileId}
POST   /ai-profiles/{aiProfileId}/uploads
POST   /ai-profiles/{aiProfileId}/reference-images
```

PERSONAL create starts `READY` with empty `referenceImages`. Reference photos reuse the WARDROBE-40 Photo Picker (`ItemImagePicker`), then:

1. `POST /ai-profiles/{aiProfileId}/uploads` with `{ "contentType", "purpose": "AI_PROFILE_REFERENCE" }`
2. `PUT` bytes to `uploadUrl` (no Firebase Bearer header)
3. `POST /ai-profiles/{aiProfileId}/reference-images` with `{ "objectKey" }`

Status chips show `PENDING` / `PROCESSING` / `READY` / `FAILED`. Users can delete their own PERSONAL profiles only.

The catalog (`GET /ai-profiles/models`) is expected to include seeded models Alex, Jordan, Sam, and Riley (`profile_generic_01`–`04`). Tapping a model (or a personal profile) stores `selectedAiProfileId` for WARDROBE-51 try-on. This ticket does not call a render API.

## Profile and support

Authenticated routes:

- `/profile` — Firebase account card (email, display name, provider) plus menu items, including AI try-on
- `/profile/contact` → `POST /support/contact`
- `/profile/report-bug` → `POST /support/bug`

Request body (WARDROBE-38):

```json
{
  "subject": "Can't upload a photo",
  "body": "The camera sheet hangs after I pick a photo.",
  "replyTo": "user@example.com",
  "meta": {
    "appVersion": "1.0.0",
    "platform": "ios",
    "deviceModel": "iPhone 15",
    "osVersion": "18.1"
  }
}
```

`replyTo` is the signed-in Firebase email when present. `meta` is optional
device/app context. The form field is labeled Message; the wire field is `body`.

**Flutter never talks to Resend** and never opens mailto for these flows. Backend
[WARDROBE-38](https://tundetunde000.atlassian.net/browse/WARDROBE-38) owns
email delivery. The client posts through the shared Dio client (Firebase ID
token interceptor) against that contract. If the support API is not live yet,
the forms stay enabled and show a friendly error — they do not fall back to
mailto.

Rate the app uses `in_app_review` and falls back to the platform store listing
(`IOS_APP_STORE_ID` dart-define for iOS).

## Account (clear content / delete)

Clear all and Delete account live on `/profile` (WARDROBE-34 menu).

- **Clear all content** — type `CLEAR`, then `DELETE /me/content`. Session stays.
- **Delete account** — type `DELETE`, then `DELETE /me`, then Firebase
  `deleteUser` (Google disconnect when needed). Failures are shown; the app
  never pretends the account is gone.

Identity is the Firebase ID token only. An empty account still returns `200`.
Wardrobe and item deletes use the existing `DELETE` APIs behind a confirm
dialog. Dio is mocked in tests.

## Local Firebase / API config

Android `applicationId` / `namespace` and iOS `PRODUCT_BUNDLE_IDENTIFIER` are
`com.tundetunde.wardrobe`
([WARDROBE-39](https://tundetunde000.atlassian.net/browse/WARDROBE-39)).
Firebase, Play Console, and App Store Connect apps must use that exact id.
See [docs/google-sign-in.md](docs/google-sign-in.md) for console steps.

Do **not** commit secrets. `lib/firebase_options.dart`, `google-services.json`,
and `GoogleService-Info.plist` are gitignored.

See [docs/local-config.example.md](docs/local-config.example.md) for dart-define
placeholders. Without Firebase dart-defines the app still boots (login shows a
configuration error) so CI can analyze and test without credentials.

```bash
flutter run --dart-define-from-file=dart_defines.json
```

API base URL (placeholder default `https://api.example.com`):

```bash
flutter run --dart-define=API_BASE_URL=https://your-api.example.com
```

## Development

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze --fatal-infos
flutter test
```

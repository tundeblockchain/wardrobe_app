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
([WARDROBE-50](https://tundetunde000.atlassian.net/browse/WARDROBE-50)), and
virtual try-on / dressing room
([WARDROBE-51](https://tundetunde000.atlassian.net/browse/WARDROBE-51)), and
Sign in with Apple on iOS
([WARDROBE-52](https://tundetunde000.atlassian.net/browse/WARDROBE-52)).

## Architecture

Layers (dependencies point downward only):

1. **Presentation** — screens (`login`, `signup`, `forgot-password`, splash, wardrobes list / create / detail, add item / item detail / edit item, outfits list / create / detail / edit, dressing room / try-on, profile / contact us / report a bug / AI try-on)
2. **Controller / Provider** — Riverpod auth, wardrobe, item, outfit, try-on, recommendation, support / rate-app, account, and AI-profile controllers
3. **Repository** — `AuthRepository`, `WardrobeRepository`, `ItemRepository`, `UploadRepository`, `OutfitRepository`, `RecommendationRepository`, `SupportRepository`, `AccountRepository`, `AiProfileRepository`
4. **API client / Firebase** — `FirebaseAuthRepository` (email/password + Google + Apple on iOS), Dio + ID-token interceptor, wardrobe/item/upload/outfit/recommendation/support/account/AI-profile Dio repositories, `image_picker` behind `ItemImagePicker`, `in_app_review` behind `AppReviewer`

## Auth shell

- Email/password and Google / Gmail via `firebase_auth` + `google_sign_in`.
  Firebase console setup: [docs/google-sign-in.md](docs/google-sign-in.md).
- Sign in with Apple on **iOS only** (`sign_in_with_apple` +
  `OAuthProvider('apple.com')`). Hidden on Android. Console steps:
  [docs/apple-sign-in.md](docs/apple-sign-in.md)
  ([WARDROBE-52](https://tundetunde000.atlassian.net/browse/WARDROBE-52)).
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
Tinder-style card stack (WARDROBE-41 / [WARDROBE-76](https://tundetunde000.atlassian.net/browse/WARDROBE-76)):
swipe left or right (or Next item) to advance; vertical scroll does not
flip or advance the card.
Tap the card or View details to open the existing item screen.
Cards prefer a processed HTTP(S) photo when present, otherwise the original
upload (network URL or the just-uploaded local bytes). They still show
`processingStatus` (`PENDING` / `PROCESSING` / `READY` / `FAILED`) as a chip
and a thin progress bar — never a processing-only placeholder that hides the
photo. Backend WARDROBE-54 item JSON keeps `image.originalKey` /
`image.processedKey` and adds short-lived GET URLs: `originalImageUrl`
(while the original key exists) and `processedImageUrl` (when a processed
key exists). Flutter maps those two fields first; aliases such as
`rawImageUrl` / `imageUrl` remain as fallbacks.
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
- `/wardrobes/:wardrobeId/outfits/:outfitId` — detail, delete, Try on
- `/wardrobes/:wardrobeId/outfits/:outfitId/edit` — rename and change slots
- `/wardrobes/:wardrobeId/outfits/:outfitId/try-on` — virtual try-on
- `/wardrobes/:wardrobeId/try-on` — dressing room (pick an outfit)

Slots use the same categories as items (`TOP`, `BOTTOM`, `DRESS`, `OUTERWEAR`,
`SHOES`, `ACCESSORY`, `BAG`). The create/edit forms reuse the wardrobe items
list so only items from that wardrobe can be assigned. Response `outfitId`
maps to domain `id`.

Backend outfits API (WARDROBE-7) may not be live yet; the client is scaffolded
against the contract with mocked unit tests. Virtual try-on is WARDROBE-51.

## Recommendations

Authenticated routes nested under a wardrobe:

- `/wardrobes/:wardrobeId/recommendations` — suggested looks + empty/error
- `/wardrobes/:wardrobeId/recommendations/:index` — slot preview; Save creates
  an outfit via the existing `POST /wardrobes/{wardrobeId}/outfits` body
  (`name` + `items[{itemId,slot}]`)

Suggestions are never auto-saved. The feature is additive: if
`GET /wardrobes/{wardrobeId}/recommendations` fails, wardrobe/item/outfit
flows still work and the suggestions entry shows an unavailable state.

Virtual try-on inference is WARDROBE-51 (outfit render API).

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

The catalog (`GET /ai-profiles/models`) is expected to include seeded models Alex, Jordan, Sam, and Riley (`profile_generic_01`–`04`). Tapping a model (or a personal profile) stores `selectedAiProfileId` for the dressing room.

Picker tiles ([WARDROBE-71](https://tundetunde000.atlassian.net/browse/WARDROBE-71) / [WARDROBE-74](https://tundetunde000.atlassian.net/browse/WARDROBE-74)) show a large frontal photo when get/list returns an http(s) URL (`referenceImages` entry such as `front.png`, or aliases like `frontImageUrl` / `referenceImageUrls` / `imageUrl`). Current Backend get/list (WARDROBE-43/45) only returns S3 keys in `referenceImages` — no PERSONAL URL field — so those options use a burgundy/plum placeholder until WARDROBE-72 (or a follow-up) returns GET URLs. S3 keys are never turned into fabricated URLs. WARDROBE-74 card sizes stay; WARDROBE-76 cover-crops the photo.

Card photos (wardrobe, item, outfit, persona, try-on result) use `BoxFit.cover` so the picture fills the card ([WARDROBE-76](https://tundetunde000.atlassian.net/browse/WARDROBE-76)). Tap the item-detail photo or a generated try-on result for a full-image popup (`BoxFit.contain`). Outfit and suggestion detail show a horizontal slider of selected-item cards.

Outfit list cards and outfit detail use the **latest generated try-on** as the main/hero once a photo exists ([WARDROBE-84](https://tundetunde000.atlassian.net/browse/WARDROBE-84) / [WARDROBE-76](https://tundetunde000.atlassian.net/browse/WARDROBE-76)). Latest is `render.imageUrl` when READY, else `renderImageUrls[0]`. After a render finishes, GET outfit refreshes append-only history from Backend ([WARDROBE-85](https://tundetunde000.atlassian.net/browse/WARDROBE-85) / [wardrobe-backend#43](https://github.com/tundeblockchain/wardrobe-backend/pull/43) on `main` at `fbc9485`). If none exists, cards keep the item-photo / hanger fallback. Outfit detail swipes `renderImageUrls` (newest first). Picking another look as main is session-only. `imageKey` is never turned into a URL.

App bars use a solid burgundy (light) / plum-burgundy (dark) fill so the header is distinct from the page surface ([WARDROBE-84](https://tundetunde000.atlassian.net/browse/WARDROBE-84)). The rest of the burgundy/plum scheme is unchanged.

### Backend image fields inspected (WARDROBE-76)

No new Backend fields were added. Display uses only existing http(s) URLs:

| Surface | Fields inspected | Gap |
| --- | --- | --- |
| Item cards / item detail / item slider | `originalImageUrl`, `processedImageUrl` (WARDROBE-54); aliases `rawImageUrl` / `originalUrl` / `processedUrl` / `imageUrl` / `url`; nested `image` map. S3 `image.originalKey` / `image.processedKey` are not turned into URLs. | If get/list omit the GET URLs and only return keys, cards show the hanger/placeholder. |
| Outfit get/list hero and carousel | `render.imageUrl` when READY; else `renderImageUrls[0]`. `render.imageKey` is storage-only. | If both URL fields are omitted, cards fall back to an assigned item photo. |
| Outfit try-on gallery | WARDROBE-85 on outfit list/get (wardrobe-backend `main` `fbc9485` / #43): `renderImageUrls[]` newest-first presigned GETs; `renderHistory[]` with `imageKey`, `createdAt`, `aiProfileId`, optional `imageUrl`. A failed presign omits that URL only. | Missing `renderImageUrls` is an empty gallery (plus the current `render.imageUrl` if READY). No local-only history. |
| Recommendation get | `name` + `items[{itemId,slot}]` only. No `imageUrl` / `render`. | Suggestion covers use wardrobe item photos only. |
| Try-on GET `/render` | `imageUrl` when `status` is `READY`. | Same as WARDROBE-51: no URL is invented from `imageKey`. |
| AI profile get/list | `frontImageUrl` / `front.*` / `referenceImageUrls` / `imageUrl` (WARDROBE-71/73). | PERSONAL get/list still has no GET URL (WARDROBE-43/45); placeholder until WARDROBE-72. |

## Virtual try-on (WARDROBE-51)

Authenticated routes:

- `/wardrobes/:wardrobeId/try-on` — dressing room; pick a saved outfit
- `/wardrobes/:wardrobeId/outfits/:outfitId/try-on` — pick a READY PERSONAL or GENERIC_MODEL profile, request a render, poll until `READY` / `FAILED`

Entry points: outfit detail **Try on**, wardrobe **Virtual try-on**, outfits list dressing-room icon. The profile picker stays at `/profile/ai-try-on` and writes `selectedAiProfileIdProvider`.

```http
POST /wardrobes/{wardrobeId}/outfits/{outfitId}/render
GET  /wardrobes/{wardrobeId}/outfits/{outfitId}/render
```

POST body: `{ "aiProfileId": "profile_…" }` (optional `items` / `itemIds`). POST returns `202` with an `Outfit` whose `render.status` is `PENDING` and, when earlier try-ons exist, `renderHistory` / `renderImageUrls`. The client polls GET `/render` every 2s (90s timeout) and shows `imageUrl` when `READY`. GET `/render` is the current poll record only — history stays on outfit list/get ([WARDROBE-85](https://tundetunde000.atlassian.net/browse/WARDROBE-85)). **No Gemini keys in the app** — the backend worker owns inference.

GET `/render` before any POST is `404 RENDER_NOT_FOUND`. Profile must be READY PERSONAL (with a reference photo) or GENERIC_MODEL.

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
See [docs/google-sign-in.md](docs/google-sign-in.md) and
[docs/apple-sign-in.md](docs/apple-sign-in.md) for console steps.

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

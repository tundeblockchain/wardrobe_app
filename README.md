# wardrobe_app

Digital Wardrobe mobile client (Flutter). Phase 1 currently includes repo
bootstrap ([WARDROBE-10](https://tundetunde000.atlassian.net/browse/WARDROBE-10)),
the Firebase auth shell
([WARDROBE-9](https://tundetunde000.atlassian.net/browse/WARDROBE-9)),
wardrobe list / create / detail
([WARDROBE-12](https://tundetunde000.atlassian.net/browse/WARDROBE-12)), and
clothing items with camera/gallery upload
([WARDROBE-13](https://tundetunde000.atlassian.net/browse/WARDROBE-13)), and
outfit build / save
([WARDROBE-14](https://tundetunde000.atlassian.net/browse/WARDROBE-14)), and
AI outfit recommendations
([WARDROBE-24](https://tundetunde000.atlassian.net/browse/WARDROBE-24)).

## Architecture

Layers (dependencies point downward only):

1. **Presentation** — screens (`login`, `signup`, `forgot-password`, splash, wardrobes list / create / detail, add item / item detail / edit item, outfits list / create / detail / edit)
2. **Controller / Provider** — Riverpod auth, wardrobe, item, outfit, and recommendation controllers
3. **Repository** — `AuthRepository`, `WardrobeRepository`, `ItemRepository`, `UploadRepository`, `OutfitRepository`, `RecommendationRepository`
4. **API client / Firebase** — `FirebaseAuthRepository`, Dio + ID-token interceptor, wardrobe/item/upload/outfit/recommendation Dio repositories, `image_picker` behind `ItemImagePicker`

## Auth shell

- Email/password via `firebase_auth`. Google sign-in is deferred.
- `go_router` restores on splash, sends signed-out users to `/login`, and signed-in users to `/wardrobes`.
- Dio attaches `Authorization: Bearer <idToken>` from
  `FirebaseAuth.currentUser.getIdToken()` on **each** request. Tokens are never
  persisted in app state.

## Wardrobes

Authenticated routes:

- `/wardrobes` — list + empty state
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
`originalImageKey` / `processedImageKey`. `processingStatus` is shown on the
item grid and detail (`PENDING` / `PROCESSING` / `READY` / `FAILED`). The
client refetches on pull-to-refresh, app resume, and route re-entry (no
websockets). Category / colour / subcategory chips send WARDROBE-21 query
params to `GET /wardrobes/{wardrobeId}/items`. Camera/gallery is abstracted as
`ItemImagePicker` so unit tests never need a device.

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

No Phase-3 virtual try-on.

## Local Firebase / API config

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

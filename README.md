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

1. **Presentation** — screens (`login`, `signup`, `forgot-password`, splash, wardrobes list / create / detail, add item / item detail / edit item, outfits list / create / detail / edit, worn-on calendar, dressing room / try-on, profile / processing inbox / contact us / report a bug / AI try-on) plus header search, related shopping links, first-visit coach marks, and the Superwall / themed paywall sheet
2. **Controller / Provider** — Riverpod auth, wardrobe, item, outfit, worn-on, try-on, inbox, recommendation, support / rate-app, account, entitlements / paywall, AI-profile, header-search, shopping-links, and coach-mark controllers
3. **Repository** — `AuthRepository`, `WardrobeRepository`, `ItemRepository`, `UploadRepository`, `OutfitRepository`, `WornOnRepository`, `RecommendationRepository`, `SupportRepository`, `AccountRepository`, `AiProfileRepository`, `ShoppingLinksRepository`, `JobEventRepository`, `DeviceRepository`
4. **API client / Firebase** — `FirebaseAuthRepository` (email/password + Google + Apple on iOS), Dio + ID-token interceptor, wardrobe/item/upload/outfit/worn-on/recommendation/support/account/AI-profile/shopping-links/events/devices Dio repositories, `image_picker` behind `ItemImagePicker`, `in_app_review` behind `AppReviewer`, `url_launcher` behind `ShoppingLinkOpener`, optional Firebase Messaging behind `PushTokenSource`

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

- `/profile` — account info, plan / restore purchases, AI try-on, Processing inbox, Rate the app, Contact us, Report a bug, Clear all, Delete account
- `/profile/inbox` — AI job-done inbox ([WARDROBE-115](https://tundetunde000.atlassian.net/browse/WARDROBE-115))
- `/profile/ai-try-on` — PERSONAL AI profile + GENERIC_MODEL catalog
- `/profile/contact` — in-app form → `POST /support/contact`
- `/profile/report-bug` — in-app form → `POST /support/bug` (optional `replyTo` + `meta`)
- `/wardrobes` — home: clothing carousel from every wardrobe (continuous
  auto-scroll, pause on drag) plus wardrobe cards; clear **Wardrobes** title
  (account icon → `/profile`). Header search
  ([WARDROBE-89](https://tundetunde000.atlassian.net/browse/WARDROBE-89),
  thumbnails [WARDROBE-97](https://tundetunde000.atlassian.net/browse/WARDROBE-97))
  filters already-loaded items (name / category / subcategory), outfits
  (name), and wardrobes (name); empty query hides the results panel.
  Item hits prefer list/get `processedImageUrl`, else `originalImageUrl`
  (no Backend search API). Outfits show a cover already on the model.
  Missing or failed images fall back to a kind icon so the row stays tappable.
  First-visit coach marks ([WARDROBE-99](https://tundetunde000.atlassian.net/browse/WARDROBE-99))
  highlight key actions on Home, wardrobe detail, outfits, item detail,
  virtual try-on, and Account. Dismissed flags persist on-device
  (`SharedPreferences`) and do not repeat every open.

- `/wardrobes/create` — name form
- `/wardrobes/:wardrobeId` — detail, rename, delete, item list, outfits entry, worn-on calendar entry, suggestions entry
- `/wardrobes/:wardrobeId/worn-on` — month calendar / list of worn-on dates

The Dio client matches the backend contract (`GET/POST /wardrobes`,
`GET/PATCH/DELETE /wardrobes/{wardrobeId}`). Response `wardrobeId` is mapped to
domain `id`. Shared API errors (`{ "code", "message" }` or
`{ "error": { "code", "message" } }`) become `ApiException`.

Backend wardrobe CRUD (WARDROBE-5) may not be live yet; the client is scaffolded
against that contract and covered with mocked unit tests.

## Items and uploads

Authenticated routes nested under a wardrobe:

- `/wardrobes/:wardrobeId/items/create` — camera/gallery + metadata
- `/wardrobes/:wardrobeId/items/:itemId` — item detail, delete, move / copy
  to another owned wardrobe
  ([WARDROBE-119](https://tundetunde000.atlassian.net/browse/WARDROBE-119)).
  Overflow **Move** / **Copy** opens a destination picker (hides the current
  wardrobe), then confirm. Consumes Backend
  [WARDROBE-118](https://tundetunde000.atlassian.net/browse/WARDROBE-118)
  (`POST /wardrobes/{wardrobeId}/items/{itemId}/move|copy` with
  `{ "targetWardrobeId" }`, contract tip `8b6a092` / wardrobe-backend#51).
  Move returns the same `itemId` (`200`) and navigates to the target
  wardrobe. Copy returns a new `itemId` (`201`, shared S3 keys) and stays
  on the source item. `PENDING` / `PROCESSING` cannot transfer. Move is
  blocked while the item is on a source outfit (`400`, message may include
  `outfitId`). Copy on Free at the 5-item cap returns
  `403 ENTITLEMENT_ITEM_LIMIT` and queues the existing item-limit paywall
  (WARDROBE-117 may be parallel). Neither action enqueues
  `PROCESS_WARDROBE_ITEM`. Lists refresh after success.
- `/wardrobes/:wardrobeId/items/:itemId/edit` — edit metadata (optional new photo).
  Subcategory is optional. Empty / none is saveable. PATCH follows Backend
  [WARDROBE-87](https://tundetunde000.atlassian.net/browse/WARDROBE-87)
  (`2cb2285913aec9d66d6e34b447d289b5eb28b6f1`): omit the field when unchanged;
  send JSON `null` (not a dummy token) to clear; send a trimmed string to set.
  Create still soft-omits empty subcategory.
  Optional acquired / purchased date ([WARDROBE-93](https://tundetunde000.atlassian.net/browse/WARDROBE-93))
  maps to Backend `acquiredAt` ([WARDROBE-92](https://tundetunde000.atlassian.net/browse/WARDROBE-92),
  wardrobe-backend#45 merged main `f8f6ded`): ISO date `YYYY-MM-DD` on the
  wire. Writes never send a datetime. Reads still accept ISO datetime and
  keep the calendar date. Create soft-omits empty; PATCH omit / JSON `null`
  clear matches subcategory REMOVE. Wardrobe item lists filter the
  already-loaded deck on the client
  ([WARDROBE-116](https://tundetunde000.atlassian.net/browse/WARDROBE-116)):
  category, colour, subcategory/tag, and inclusive `acquiredAfter` /
  `acquiredBefore`. Items with no `acquiredAt` are excluded when either
  bound is set. Query-string GSI params stay on `ItemListFilters` as an
  extension point only — no dedicated search API.

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
tag chips and hide-older-than apply to the loaded card deck
([WARDROBE-116](https://tundetunde000.atlassian.net/browse/WARDROBE-116)).
Clear filters restores the full deck. Zero matches show a soft empty
message. Filter transitions respect reduce-motion. The client
refetches the unfiltered list on pull-to-refresh, app resume, and route
re-entry (no websockets).
Camera/gallery is abstracted as `ItemImagePicker` so unit tests never need a
device. On Android, gallery uses the system Photo Picker (no
`READ_MEDIA_IMAGES`); camera still uses `CAMERA`. See
[docs/android-photo-picker.md](docs/android-photo-picker.md).
Item detail also shows **Related shopping links** for that item
([WARDROBE-95](https://tundetunde000.atlassian.net/browse/WARDROBE-95),
Home strip removed in [WARDROBE-100](https://tundetunde000.atlassian.net/browse/WARDROBE-100)).

Backend item/upload APIs (WARDROBE-8 / WARDROBE-11) may not be live yet; the
client is scaffolded against the contract with mocked unit tests.

## Outfits

Authenticated routes nested under a wardrobe:

- `/wardrobes/:wardrobeId/outfits` — list + empty state
- `/wardrobes/:wardrobeId/outfits/create` — name + pick items into slots
- `/wardrobes/:wardrobeId/outfits/:outfitId` — detail, delete, Try on, worn-on log
- `/wardrobes/:wardrobeId/outfits/:outfitId/edit` — rename and change slots
- `/wardrobes/:wardrobeId/outfits/:outfitId/try-on` — virtual try-on
- `/wardrobes/:wardrobeId/try-on` — dressing room (pick an outfit)

Slots use the same categories as items (`TOP`, `BOTTOM`, `DRESS`, `OUTERWEAR`,
`SHOES`, `ACCESSORY`, `BAG`). The create/edit forms reuse the wardrobe items
list so only items from that wardrobe can be assigned. Response `outfitId`
maps to domain `id`.

Backend outfits API (WARDROBE-7) may not be live yet; the client is scaffolded
against the contract with mocked unit tests. Virtual try-on is WARDROBE-51.

### Outfit worn-on log (WARDROBE-121)

Mark an outfit as worn on a calendar date and browse a simple wardrobe
month list. Consumes Backend
[WARDROBE-120](https://tundetunde000.atlassian.net/browse/WARDROBE-120)
([wardrobe-backend#52](https://github.com/tundeblockchain/wardrobe-backend/pull/52)
SHA `7d24d0e`). Not entitlement-gated. Outfit GET / list stay unchanged
(no `wornOn` field on the outfit). Body / query / path `userId` is ignored.

```http
POST   /wardrobes/{wardrobeId}/outfits/{outfitId}/worn-on
GET    /wardrobes/{wardrobeId}/outfits/{outfitId}/worn-on
DELETE /wardrobes/{wardrobeId}/outfits/{outfitId}/worn-on/{date}
GET    /wardrobes/{wardrobeId}/worn-on?from=YYYY-MM-DD&to=YYYY-MM-DD
```

Set body: `{ "wornOn": "2026-09-18" }` — `YYYY-MM-DD` only. Entry DTO:
`{ outfitId, wardrobeId, wornOn, createdAt }` (`201` first log, `200` if
that date already exists). List is `{ "entries": [...] }` newest `wornOn`
first. Delete is `204` (missing dates too). Calendar `from` / `to` are
optional inclusive bounds; `from` after `to` is `400 VALIDATION_ERROR`.
Flutter joins `outfitId` to the cached outfit list for names.

Errors: `401 UNAUTHENTICATED`, `404 WARDROBE_NOT_FOUND` /
`OUTFIT_NOT_FOUND`, `400 VALIDATION_ERROR`. No `WORN_ON_NOT_FOUND`.
Unused optionals are soft-omitted (never JSON `null`). GET list/calendar
treats an undeployed route (`404` without those ownership codes) as an
empty log so outfit detail stays usable before Backend merge.

Outfit detail: **Mark worn today** / **Pick a date**, plus unmark on each
logged day. Wardrobe detail and the outfits header open the month
calendar (`AppMotion.reduce` skips grid motion).

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

## Related shopping links (WARDROBE-95)

Item detail shows a **Related shopping links** section. Home no longer
renders or fetches mixed shopping links
([WARDROBE-100](https://tundetunde000.atlassian.net/browse/WARDROBE-100)).
Available on **Free, Basic, and Premium** — not entitlement-gated. Flutter
never holds OpenAI or Bright Data keys; those stay on Backend
([WARDROBE-96](https://tundetunde000.atlassian.net/browse/WARDROBE-96)).

Locked contract (wardrobe-backend#47 squash SHA **`aaf46cd`** /
`aaf46cdef1f6f1da6e550c73ebee7c3f45729a96` on Backend **main**).
`ShoppingLinksContract.liveEnabled` is `true` — item detail calls
`GET /wardrobes/{wardrobeId}/items/{itemId}/shopping-links` through
`DioShoppingLinksRepository`. The mixed Home path
`GET /shopping-links?limit=5&linksPerItem=8` remains in the repository
contract but is unused by the Flutter UI.

```http
GET /wardrobes/{wardrobeId}/items/{itemId}/shopping-links
```

Home mixed query (unused by the client): `limit` default 5 max 10;
`linksPerItem` default 8 max 12. Invalid query is Backend
`400 VALIDATION_ERROR` — Flutter only sends the clamped defaults if that
path is called.

Link object (soft-omit unset; never JSON `null`):

| Field | Type | Notes |
| --- | --- | --- |
| `title` | string | Required |
| `url` | string | Required; http(s) only; opens externally |
| `merchant` | optional string | Soft-omit when unset |
| `price` | optional string | Soft-omit when unset |
| `currency` | optional string | Soft-omit when unset |
| `imageUrl` | optional string | http(s) thumbnail |

Item 200: `{ itemId, wardrobeId, keywords[], cached, links[], warning? }`.

Home 200: `{ items: [ { itemId, wardrobeId, keywords[], cached, links[], warning? } ] }`.

Soft-fail: upstream blips are **200** with empty `links` / empty `items`
and optional `warning.code=SHOPPING_UPSTREAM_UNAVAILABLE`. Missing item or
wardrobe is **404** (`ITEM_NOT_FOUND` / `WARDROBE_NOT_FOUND`) — the shopping
section treats that as empty and never blocks wardrobe UX.

`shoppingLinksRepositoryProvider` returns `DioShoppingLinksRepository`
(Firebase ID-token interceptor; no OpenAI or Bright Data keys in the app).
Widget tests override the provider with `FakeShoppingLinksRepository`.
Product taps use `url_launcher` via `ShoppingLinkOpener`.

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

## AI job inbox (WARDROBE-115)

Home and Account open `/profile/inbox`. The tray lists unread job-done
events from Backend
[WARDROBE-114](https://tundetunde000.atlassian.net/browse/WARDROBE-114)
(`wardrobe-backend#53` SHA `0d75d71`). Inbox works without FCM.

```http
GET    /me/events?unreadOnly=true&limit=20
POST   /me/events/{eventId}/ack
POST   /me/events/ack
PUT    /me/devices
DELETE /me/devices/{deviceId}
```

`EventsApi` / `DevicesApi` sit under `JobEventRepository` and
`DeviceRepository`. Optional fields are omitted, never `null`. READY
rows show success copy; FAILED rows show `error`. Tap deep-links item
jobs to item detail and try-on jobs to
`/wardrobes/{wardrobeId}/outfits/{outfitId}/try-on`. Open or dismiss
acks the row. After Premium item create or try-on POST, a local PENDING
row stays visible until a matching event arrives — Refresh clears the
empty state; there is no silent dead-end.

`GET /me/events` `404` (Backend not on the live API yet) is an empty
refreshable inbox. Firebase Messaging token registration is best-effort
and never blocks the tray. Item / render GET polling remains the
fallback on those screens.

See [docs/ai-job-inbox.md](docs/ai-job-inbox.md).

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

## Entitlements and paywalls (WARDROBE-90 / WARDROBE-117)

`GET /me` is the source of truth for `FREE` | `BASIC` | `PREMIUM`. Soft UI
gates present Superwall when configured; a burgundy/plum fallback sheet is
used in CI and when keys are unset. Backend still enforces limits.

403 `{ code, message }` values map in the client (no Backend contract
change):

| Code | Target | Primary CTA |
| --- | --- | --- |
| `ENTITLEMENT_WARDROBE_LIMIT` | Basic | Upgrade to Basic |
| `ENTITLEMENT_ITEM_LIMIT` | Basic | Upgrade to Basic |
| `ENTITLEMENT_OUTFIT_LIMIT` | Basic | Upgrade to Basic |
| `ENTITLEMENT_AI_REQUIRED` | Premium | Upgrade to Premium |
| Unknown `ENTITLEMENT_*` | Basic (or the caller fallback) | Upgrade / See plans |

Unknown entitlement codes soft-fail to a generic upgrade CTA instead of
showing raw Backend text. Form errors use the same paywall copy.

Presentation calls `EntitlementsController.presentPaywall` /
`restorePurchases`, which call the existing Superwall gateway. The
fallback sheet exposes **Upgrade**, **See plans** (Free / Basic / Premium),
and **Restore purchases**. Account has the same restore tile for
reinstall or a new sign-in after delete. Superwall (or the store hook)
owns the native restore; then the client re-reads `GET /me`.

Motion on the fallback sheet respects `AppMotion.reduce`. Public Superwall
keys stay in dart-defines — see
[docs/local-config.example.md](docs/local-config.example.md).

## Account (clear content / delete)

Clear all and Delete account live on `/profile` (WARDROBE-34 menu).

- **Clear all content** — type `CLEAR`, then `DELETE /me/content`. Session stays.
- **Delete account** — type `DELETE`, then client Superwall cancel (no-op when
  the SDK has no store-cancel API), then `DELETE /me`, then Firebase
  `deleteUser` (Google disconnect when needed). Failures are shown; the app
  never pretends the account is gone.
- **Subscription cancel (WARDROBE-102)** — Backend
  [WARDROBE-103](https://tundetunde000.atlassian.net/browse/WARDROBE-103)
  (`wardrobe-backend#49`, SHA `3f9b38a`) is the source of truth.
  `DELETE /me` has no body: try store cancel → revoke ENTITLEMENT → delete
  AWS data. `DELETE /me/content` is unchanged (no cancel). The 200 body is
  `{ deleted, keepAccount, entitlementRevoked, subscription }`.
  `subscription.status` is `NONE` | `CANCELED` | `CANCEL_AT_PERIOD_END` |
  `CANCEL_FAILED`. Unset optionals (`cancelMode`, `store`, `expiresAt`,
  `retryInStore`) are omitted. Production is locked to merge SHA `3f9b38a`
  (not the pre-merge `e312d55` tip): a `DELETE /me` body without that
  envelope is `INVALID_RESPONSE`. `CANCEL_FAILED` / `retryInStore: true`
  shows App Store or Play subscription-settings copy plus Retry/Continue —
  the account is already deleted and Premium revoked, but billing may still
  be active. `CANCEL_AT_PERIOD_END` shows period-end copy (Premium already
  revoked). Hard AWS wipe fail is `500 INTERNAL_ERROR` and retries
  `DELETE /me`. Then the client deletes Firebase Auth.

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

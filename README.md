# wardrobe_app

Digital Wardrobe mobile client (Flutter). Phase 1 currently includes repo
bootstrap ([WARDROBE-10](https://tundetunde000.atlassian.net/browse/WARDROBE-10)),
the Firebase auth shell
([WARDROBE-9](https://tundetunde000.atlassian.net/browse/WARDROBE-9)), and
wardrobe list / create / detail
([WARDROBE-12](https://tundetunde000.atlassian.net/browse/WARDROBE-12)).

Items, uploads, and outfits are **not** implemented yet.

## Architecture

Layers (dependencies point downward only):

1. **Presentation** — screens (`login`, `signup`, `forgot-password`, splash, wardrobes list / create / detail)
2. **Controller / Provider** — Riverpod `AuthController`, `WardrobesController`, `CreateWardrobeController`, `WardrobeDetailController`
3. **Repository** — `AuthRepository`, `WardrobeRepository`
4. **API client / Firebase** — `FirebaseAuthRepository`, Dio + ID-token interceptor, `DioWardrobeRepository`

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
- `/wardrobes/:wardrobeId` — detail, rename, delete

The Dio client matches the backend contract (`GET/POST /wardrobes`,
`GET/PATCH/DELETE /wardrobes/{wardrobeId}`). Response `wardrobeId` is mapped to
domain `id`. Shared API errors (`{ "code", "message" }` or
`{ "error": { "code", "message" } }`) become `ApiException`.

Backend wardrobe CRUD (WARDROBE-5) may not be live yet; the client is scaffolded
against that contract and covered with mocked unit tests.

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

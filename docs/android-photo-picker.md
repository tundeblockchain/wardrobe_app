# Android Photo Picker (WARDROBE-40)

Clothing photos on Android are chosen with the **system Photo Picker**, not a
broad gallery browse. That lets the app drop `READ_MEDIA_IMAGES` and the Play
Console "frequent photo/video access" declaration.

Jira: [WARDROBE-40](https://tundetunde000.atlassian.net/browse/WARDROBE-40)

## What the user sees

- **Gallery / add-item / replace photo** — Android Photo Picker (one image).
  On Android 16+ `image_picker` always uses Photo Picker. On 15 and below the
  client sets `ImagePickerAndroid.useAndroidPhotoPicker = true` before any
  pick.
- **Camera** — still the platform camera capture flow. `CAMERA` stays in the
  manifest (`android.hardware.camera` remains optional).
- **iOS** — unchanged (`NSCameraUsageDescription` /
  `NSPhotoLibraryUsageDescription`). No shared picker API change beyond the
  Android-only Photo Picker flag (a no-op on iOS).

Selected bytes still follow the existing upload path:
`POST /uploads` → `PUT` to `uploadUrl` → create/update item with `imageKey`.

## Play Console

Do **not** declare frequent photo/video access for `READ_MEDIA_IMAGES`. The
merged app must not request that permission. Photo Picker is a one-shot
system picker and does not need broad media access.

## Permissions

Declared / kept:

| Permission | Why |
| --- | --- |
| `INTERNET` | API + Flutter tooling |
| `CAMERA` | Capture a clothing photo |

Explicitly **removed** (and `tools:node="remove"` so a plugin merge cannot
re-add them):

- `READ_MEDIA_IMAGES`
- `READ_MEDIA_VIDEO`
- `READ_MEDIA_VISUAL_USER_SELECTED`
- `READ_EXTERNAL_STORAGE`
- `WRITE_EXTERNAL_STORAGE`

`image_picker_android` 0.8.13+ does not declare media/storage permissions.

### Leftover plugin permissions we do not strip

Checked against current plugin manifests (`image_picker_android` 0.8.13+22
declares **no** media/storage permissions):

- `INTERNET` — app + `google_sign_in_android` plugin manifest. Required.
- Firebase / Play services **AARs** (not Flutter XML) may still merge
  `ACCESS_NETWORK_STATE` or `WAKE_LOCK`. Those are not photo-library access
  and are left as-is. They cannot be stripped from this repo's Dart/XML
  without breaking Firebase.

If a future plugin re-introduces `READ_MEDIA_*` or `READ_EXTERNAL_STORAGE`
without a `tools:node="remove"` override, Play Console will again ask for a
photo/video policy declaration. Keep the merge removals in
`android/app/src/main/AndroidManifest.xml`.

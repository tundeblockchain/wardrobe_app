# AI job inbox (WARDROBE-115)

In-app processing tray for AI job-done events. Pair with Backend
[WARDROBE-114](https://tundetunde000.atlassian.net/browse/WARDROBE-114)
(`wardrobe-backend#53`, SHA `0d75d71`).

The inbox works **without** Firebase Cloud Messaging. Push is optional.

Do not commit Firebase service-account JSON, FCM server keys, or device
tokens.

## HTTP contract

Auth: existing Firebase ID token (`Authorization: Bearer …`). Identity
comes from the authorizer. Body/query `userId` is ignored. Not
entitlement-gated.

```http
GET    /me/events?unreadOnly=true&limit=20
POST   /me/events/{eventId}/ack
POST   /me/events/ack
PUT    /me/devices
DELETE /me/devices/{deviceId}
```

`GET /me/events` query: `unreadOnly` default `true` (`true`/`1` or
`false`/`0`); `limit` default `20`, max `50`. Newest first.

```json
{
  "events": [
    {
      "eventId": "evt_item_item_xyz123abcd_READY",
      "jobType": "PROCESS_WARDROBE_ITEM",
      "status": "READY",
      "wardrobeId": "wd_abc123xyz0",
      "itemId": "item_xyz123abcd",
      "createdAt": "2026-09-19T10:00:00.000Z"
    }
  ],
  "unreadCount": 1
}
```

Optional fields (`itemId`, `outfitId`, `renderId`, `aiProfileId`,
`error`, `acknowledgedAt`) are omitted when unused — never JSON `null`.

| Field | Notes |
| --- | --- |
| `jobType` | `PROCESS_WARDROBE_ITEM` or `RENDER_OUTFIT` |
| `status` | Terminal `READY` or `FAILED` only |
| `error` | `FAILED` only |

Ack:

- Single `POST /me/events/{eventId}/ack` → `200` job event (idempotent).
  Unknown / other-user → `404 EVENT_NOT_FOUND`.
- Batch `POST /me/events/ack` body `{ "eventIds": ["…"] }` → `200 { "events" }`.
  Unknown ids are skipped. Empty array → `400`. Max 50.

Devices (optional FCM):

```http
PUT /me/devices
{ "token": "<fcm-registration-token>", "platform": "IOS" | "ANDROID", "deviceId": "optional" }
```

`200 { "deviceId", "platform", "updatedAt" }` — token is write-only.
`DELETE /me/devices/{deviceId}` → `204`.

Push data values are all strings: `eventId`, `jobType`, `status`,
`wardrobeId`, plus `itemId` or `outfitId` / `renderId` / `aiProfileId`.

If `GET /me/events` is `404` (Backend not merged yet), the inbox shows
an empty refreshable state and does not block Home or Account.

## Client behavior

1. After Premium `POST` item or `POST .../render`, keep a local PENDING
   tray row when the create/render response is still in progress.
2. Poll `GET /me/events?unreadOnly=true` (and optional FCM data) instead
   of a tight loop on GET item / GET render. Item and render GET polling
   remain the fallback on those screens.
3. Deep-link item → `/wardrobes/{wardrobeId}/items/{itemId}`. Try-on →
   `/wardrobes/{wardrobeId}/outfits/{outfitId}/try-on`.
4. Ack on open or dismiss.
5. Empty state + Refresh — never a silent PENDING dead-end.

Firebase Messaging token registration is best-effort. Missing Firebase
config, denied notification permission, or a failed `PUT /me/devices`
never hides the inbox.

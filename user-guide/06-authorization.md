# Authorization

*The six auth types, the full OAuth 2.0 flow, and how auth is inherited from folders and collections.*

**In this chapter**
- [Choosing an auth type](#choosing-an-auth-type)
- [No Auth](#no-auth)
- [Bearer Token](#bearer-token)
- [Basic Auth](#basic-auth)
- [API Key](#api-key)
- [OAuth 2.0](#oauth-20)
- [Inherited auth](#inherited-auth)

## Choosing an auth type

The **Auth** tab offers six types, each a color-coded button: `Inherit`, `No Auth`, `Bearer Token`, `Basic Auth`, `API Key`, and `OAuth 2.0`. When auth is active, the **Auth** tab shows a green dot. The same editor is reused for collection-level and folder-level auth (see [Collections](11-collections.md)); the `Inherit` option appears for requests and folders but not for collections (a collection has no parent to inherit from).

## No Auth

No `Authorization` header is added. Use this to explicitly override an inherited auth.

## Bearer Token

A single **Token** field (supports `{{variables}}`). Sent as `Authorization: Bearer <token>`.

## Basic Auth

A **Username** field (supports `{{variables}}`) and a masked **Password** field. Sent as `Authorization: Basic <base64(user:pass)>`.

> **Note:** The password field is masked and, unlike other fields, does not highlight `{{variables}}` as pills — showing the highlight overlay would defeat the masking. Variables still resolve normally at send time.

## API Key

A **Key Name** and **Key Value** (both support `{{variables}}`), plus an **Add To** selector: send the key as a `Header` or as a `Query Parameter`.

## OAuth 2.0

The most involved type. Pick a **Grant Type**:

| Grant type | Notes |
|---|---|
| `Authorization Code` | Opens the provider's auth page in a browser window, then exchanges the code. |
| `Authorization Code (PKCE)` | Adds a **PKCE Challenge Method** selector (`SHA-256 (S256)` or `Plain`); Beacon generates the code verifier and challenge. |
| `Client Credentials` | Machine-to-machine; no browser step. |
| `Implicit` | Reads the token straight from the redirect fragment. |
| `Password Credentials` | Uses a username and password; no browser step. |

The fields shown depend on the grant — some combination of **Auth URL**, **Access Token URL**, **Client ID**, **Client Secret** (masked), **Redirect URI**, **Username** / **Password**, **Scope**, and **State**.

**Getting and using a token:**

- **Get New Access Token** runs the selected grant. The status line shows `Requesting…` then `Token received`; errors appear in red.
- When a token exists, a banner shows `Access token active` (or `Access token expired`), the first 12 characters of the token, the token type, and either `expires in Nm` or `no expiry reported`, plus `· refreshable` if a refresh token was issued.
- **Refresh** requests a new token using the refresh token (only enabled when one exists). If the response omits a new refresh token, the old one is kept.
- **Clear** discards the cached token.

At send time, the cached access token is injected as `Authorization: Bearer <accessToken>`.

> **Warning:** Beacon does **not** auto-refresh OAuth tokens. When a token expires, use **Refresh** (or **Get New Access Token**) yourself. This applies everywhere a token is sent — the request, the [Collection runner](12-collection-runner.md), [Flows](13-flows.md), and [Load testing](14-load-testing.md).

## Inherited auth

Set a request's (or folder's) auth to `Inherit` and Beacon walks up the tree — nearest folder, then parent folders, then the collection — and uses the first auth it finds. The `Inherit` panel shows a read-only summary of what it resolves to, for example `Inherits Bearer Token from folder "Auth".` or `No parent auth is set — resolves to No Auth.`

This lets you set an auth once on a collection or folder and have every request inside use it automatically. Set collection- and folder-level auth from the [collection settings tab and folder settings modal](11-collections.md).

---

**See also:** [Collections](11-collections.md) · [Variables and environments](07-variables-and-environments.md) · [Sending requests](03-sending-requests.md)

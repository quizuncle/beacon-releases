# Settings

*Every setting across the six tabs, plus the in-app updater.*

**In this chapter**
- [General](#general)
- [Network](#network)
- [Security](#security)
- [Sync](#sync)
- [Editor](#editor)
- [Appearance](#appearance)
- [The in-app updater](#the-in-app-updater)

Open **Settings** with `⌘6`, the gear at the bottom of the Activity Rail, or `Sync settings` in the account menu. The modal has a left tab bar and a **Cancel** / **Save** footer.

> **Note:** Settings apply only when you click **Save**.

## General

**Request**

| Setting | What it does | Default |
|---|---|---|
| **Request Timeout** | Seconds before a request is cancelled; `0` means no timeout. | `30` |
| **Max Redirects** | Maximum redirects to follow automatically. | `10` |
| **Follow Redirects** | Automatically follow `3xx` redirect responses. | On |
| **Send Cookies** | Include cookies from the [cookie jar](17-history-and-cookies.md) in requests. | On |

**Updates** — the in-app updater controls; see [below](#the-in-app-updater).

## Network

**Proxy**

| Setting | What it does | Default |
|---|---|---|
| **Enable Proxy** | Route requests through an HTTP proxy server. | Off |
| **Proxy Host** | The proxy hostname (e.g. `127.0.0.1`). Shown when the proxy is enabled. | — |
| **Port** | The proxy port. | `8080` |

> **Note:** Proxy settings are kept per-device and are never uploaded by [Cloud Sync](16-cloud-accounts.md).

## Security

**Certificates**

| Setting | What it does | Default |
|---|---|---|
| **SSL Certificate Verification** | Verify the server's SSL certificate. Disable only for self-signed certs in development. | On |

> **Warning:** When SSL verification is off, Beacon shows: *"SSL verification is disabled. Only use this for local development — never in production."*

## Sync

Shows the current sync status, then (when sync is enabled) controls to **Change Passphrase**, **Reset sync encryption** (under *Forgot Passphrase?*), and **Disable sync** (optionally deleting cloud data). The full story is in [Cloud accounts](16-cloud-accounts.md).

## Editor

| Setting | What it does | Default |
|---|---|---|
| **Font Size** | Font size for the JSON, script, and response-body editors (`10`–`24`). A live preview shows the chosen size. | `12` |

## Appearance

| Setting | What it does | Default |
|---|---|---|
| **Theme** | `Dark` or `Light`. (The Toolbar's theme button also offers a `system` option.) | `Dark` |
| **Accent Color** | Six presets — `Indigo` (default), `Violet`, `Teal`, `Rose`, `Amber`, `Slate` — plus a color picker and a `#RRGGBB` hex input, with `Reset to default`. | Indigo `#4361EE` |

Theme and accent changes apply instantly after saving, and re-theme the code editor and response viewer too.

## The in-app updater

Beacon checks the latest public release on GitHub and can update itself. The **Updates** row in the **General** tab reflects the current state — `Check for updates`, `Beacon <version> is available`, or `You're up to date`. When an update exists, the button walks through `Install <version>` → `Installing…` → `Restart to finish`. You can also update via Homebrew with `brew upgrade --cask beacon`.

Separately, when an update is found (at launch or on a manual check), an **update toast** appears in the bottom-right with a one-click **Download & Install**, and an accent dot appears on the Activity Rail's Settings gear.

---

**See also:** [Cloud accounts](16-cloud-accounts.md) · [History and cookies](17-history-and-cookies.md) · [Interface tour](02-interface-tour.md) · [Getting started](01-getting-started.md)

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
| **Enable Proxy** | Route requests through an HTTP proxy server. Turning it off keeps the host and port you configured, ready for the next time you turn it back on. | Off |
| **Proxy Host** | The proxy hostname (e.g. `127.0.0.1`). Shown when the proxy is enabled. | — |
| **Port** | The proxy port. Only a whole number from `1` to `65535` is saved — while you retype it the box can be empty, but a blank or out-of-range value is never committed, so the proxy can't end up enabled with a port it can't dial. | `8080` |

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
| **Theme** | **System**, which follows your OS appearance, or one of the named shades grouped as **Dark** (`Midnight`, `Slate`, `Carbon`), **Light** (`Paper`, `Snow`, `Sepia`), and **Bloom** (`Mulberry`, `Mauve`, `Quartz`, `Shell`). The one in use is marked `Active`. | `Midnight` |
| **Accent Color** | Six presets — `Indigo` (default), `Violet`, `Teal`, `Rose`, `Amber`, `Slate` — plus a color picker and a `#RRGGBB` hex input, with `Reset to default`. | Indigo `#4361EE` |
| **Default View** | Which view a JSON response opens in. Large responses always open in Pretty for performance. | Interactive |

Clicking a theme previews it immediately: the whole app repaints on the click, so you can judge a shade at full size instead of from a swatch. Nothing is committed until you press **Save** — **Cancel**, `Esc`, or closing Settings any other way puts your saved theme back. The code editors and the response viewer finish switching once you save, and **Accent Color** applies on save rather than on click.

> **Note:** The Toolbar's theme button is a quick three-way cycle — `System` → `Midnight` → `Paper`. The full set of shades lives here.

## The in-app updater

Beacon compares your version against the latest public release on GitHub and can update itself. It checks quietly a few seconds after launch, and then roughly once an hour for as long as Beacon stays open — so a window you left running for days still notices a new release. Quiet checks stay quiet: if one fails, you never hear about it.

The **Updates** row in the **General** tab reflects the current state — `Check for Updates` before anything has been checked, then `Checking for updates…`, `Beacon <version> is available`, `You're up to date (<your version>)`, or `Update check failed` with the reason underneath. Its **Check for Updates** button runs a check right now instead of waiting for the next hourly one, and — unlike the background check — it reports the outcome either way. When an update exists, the button walks through `Install <version>` → `Installing…` → `Restart to finish`. On macOS, **Check for Updates…** in the **Beacon** menu does the same thing and answers in a dialog. You can also update via Homebrew with `brew upgrade --cask beacon`.

Whenever a check finds a new version — at launch, on an hourly re-check, or from a check you asked for — an **update toast** appears in the bottom-right reading `Beacon <version> is available`, and an accent dot appears on the Activity Rail's Settings gear. If the release ships notes, a **What's new** row sits under the title; expand it to read what changed before you decide. **Download & Install** does the rest in one click — `Downloading… <n>%`, then `Installing…`, then **Restart to finish** — and the notes stay readable while it downloads. Dismiss the toast with its `×` to deal with it later.

From your next update onward, the first launch of the new version greets you with a one-time **What's new in <version>** popup carrying that release's notes; **Got it** or `Esc` closes it, and it doesn't come back.

> **Note:** v0.1.0 is the release that *adds* that popup, so upgrading **to** v0.1.0 won't show one — v0.1.0 is simply the first version that records which release you've already seen. The popup starts appearing with the release after this one. That record is kept per device, so each computer you run Beacon on gets the popup once per release.

---

**See also:** [Cloud accounts](16-cloud-accounts.md) · [History and cookies](17-history-and-cookies.md) · [Interface tour](02-interface-tour.md) · [Getting started](01-getting-started.md)

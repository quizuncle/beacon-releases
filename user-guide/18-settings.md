# Settings

*Every setting across the eight tabs, plus the in-app updater.*

**In this chapter**
- [General](#general)
- [Network](#network)
- [Security](#security)
- [Privacy](#privacy)
- [Sending feedback](#sending-feedback)
- [Sync](#sync)
- [Editor](#editor)
- [Appearance](#appearance)
- [MCP / AI access](#mcp--ai-access)
- [The in-app updater](#the-in-app-updater)

Open **Settings** with `⌘6`, the gear at the bottom of the Activity Rail, or `Sync settings` in the account menu. The modal has a left tab bar and a **Cancel** / **Save** footer.

> **Note:** Settings apply only when you click **Save** — with two deliberate exceptions, which apply immediately: [Privacy](#privacy)'s **Share anonymous usage data** switch, and the enable toggle on the **MCP / AI access** tab.

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

## Privacy

One switch, then the full disclosure of what Beacon reports about itself.

| Setting | What it does | Default |
|---|---|---|
| **Share anonymous usage data** | Sends the counts and error reports described below. Turning it off stops the *upload* — Beacon keeps recording them on this device, and feedback you deliberately send still goes out. | On |

It runs whether or not [Cloud Sync](16-cloud-accounts.md) is enabled, and the two are unrelated: Cloud Sync uploads *your work*, this uploads *counts about the app*, and turning either one off does nothing to the other.

**Turning it off** stops the upload, not the recording. Beacon carries on counting your usage and capturing errors on this device, exactly as described below — it just sends none of it: no usage totals, no record of this install and no error reports leave your machine while the switch is off, and it stops looking your country up as well. Nothing already sent is removed. Feedback you deliberately send is the exception and still goes out, because you asked for it. Turn it back on and Beacon uploads what it recorded meanwhile, as far back as the limits at the end of this section allow, picking up where it left off rather than starting over.

> **Note:** this is the one setting that does **not** wait for **Save** — it applies the moment you flip it, and **Cancel** or `Esc` will not put it back. Signing out never changes it either: an install that opted out stays opted out.

**Anonymous Usage Data.** Beacon reports anonymous usage data so the developers know which features matter and which ones are breaking. It is tied to a random ID generated for this install — not to your hardware, and not to your name unless you sign in (see below).

**What Beacon sends**

| | |
|---|---|
| **Usage** | Which features you use and how often, as daily totals — plus how many times you launched the app, roughly how long it stayed open, and which hours of the day you used it. Alongside the totals a few labels are counted for the day, from a fixed list Beacon ships: the HTTP method, whether a request succeeded or failed and the kind of failure, the body type, the authentication type, a size bucket, and where in the app you started from. Each is a count per day — never a value, and never attached to an individual request: Beacon can tell that 31 GET requests were sent today, not which ones or to where. |
| **This install** | App version, operating system, CPU architecture, language and time-zone offset, plus when this install was first and last seen and how many times it has launched. If Beacon ever has to replace this install's ID, it keeps the previous ones alongside the new one — that history is what links those IDs to each other. |
| **Roughly where** | Three things, and this is all of them: your **country** as a two-letter code; the **Cloudflare edge code** that answered the lookup — a three-letter code for the nearest data centre on your network path, *not* your city and *not* your address (whole regions share one edge, and on a VPN it is wherever your VPN comes out); and your device's **time-zone name**, such as `Asia/Kolkata`, which Beacon reads from your own system settings without asking anyone. The first two come from one lookup against cloudflare.com, falling back to api.country.is: those services see your IP address the way any site you connect to does, but Beacon reads only the country and edge codes out of the reply and never stores or sends the IP itself. |
| **Errors** | The error type, a one-line message, which part of Beacon it came from, how many times it happened that day, when it first and last happened, and a fingerprint that groups repeats together. The error type and its message are the only free-form text Beacon uploads on its own, so both are scrubbed on your machine before they are queued: URLs, email addresses, tokens, IP addresses, home folder paths, `{{variables}}`, long quoted strings and long runs of digits are all replaced, and a report that still looks like it holds a secret is thrown away rather than sent. Two kinds of failure are reported with no message at all — an error thrown by your own pre-request or test script, and a request that failed to send. |
| **If you sign in** | Your account email, account ID and sign-in provider, along with the other accounts that have signed in on this install, so a support request or a piece of feedback can be linked to it. Signing out stops the recording but doesn't erase what was already recorded. |

**What Beacon never sends.** Request URLs, headers, bodies or responses. Environment variables, globals, secrets, tokens, API keys or passwords. Collection, folder, request or workspace names. Your pre-request and test scripts. None of it is collected. The only fields Beacon fills in by itself that could physically hold any of it are the error type and error message above, which is why both are scrubbed and then thrown away outright if they still look like they hold a secret — though scrubbing isn't perfect: a short credential with no recognizable prefix can still read as ordinary text.

> **The one exception** is feedback you deliberately send — see below.

Usage data is written to Beacon's local database first and uploaded in the background, so a short spell offline costs nothing. A long one does lose data: only today plus the seven most recent days are kept on this device, the queue holds the 500 most recent error reports and feedback messages and drops the oldest beyond that, a queued error report is abandoned after 8 failed uploads, and queued feedback is abandoned if it can't be delivered within 7 days.

Those same limits bound how much comes back when you switch reporting on again after a long spell off — but note **which** of them applies. While the switch is off Beacon makes no upload attempts at all, so the 8-failed-uploads limit can never be reached and discards nothing; what governs is the seven-day window on daily totals and the 500-message cap on the queue.

## Sending feedback

**Send feedback** rates Beacon and tells the developers what's working or broken. You can open it from four places:

- the **Omnibox**: press `⌘K` for command mode — or type `>` into the Omnibox yourself — and pick `Send Feedback`;
- the **account menu** in the Toolbar (when you're signed in);
- the **message icon** in the Toolbar (when you're signed out — there is no account menu there, and feedback is not gated on having an account);
- **Settings → Privacy → Send feedback**.

The dialog asks three things:

| Field | Required | Notes |
|---|---|---|
| **Rating** | Yes | One to five stars, with a plain-language echo — `Not working for me`, `Needs work`, `It's fine`, `Good`, `Love it`. Until you pick one it reads `Pick a rating to continue` and **Send feedback** stays disabled. Arrow keys, `Home` and `End` work on the stars. |
| **Tell us more** | No | Free text, up to 2000 characters, with a live counter. |
| **Email** | No | Pre-filled if you're signed in; **Remove** clears it. *"Only so we can reply. Leave it out and your feedback stays anonymous."* |

Alongside what you type, a submission carries this install's ID, your account ID if you're signed in, the app version, the platform and the country code — a subset of the install facts described above. A feedback submission carries no edge code and no time-zone name.

**It works offline.** Pressing **Send feedback** saves the review to Beacon's local database and confirms straight away: *"Thanks — your feedback is on its way. We read every review. If you're offline, it sends itself the next time you're connected."* Nothing is lost if you close Beacon before it uploads. If saving genuinely fails, the dialog stays exactly as you left it with your text intact — it never clears the form on an error.

> **Note:** `Esc`, **Cancel**, and clicking outside the dialog all close it — and closing discards whatever you had typed. There is no draft.

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

## MCP / AI access

One toggle, a live status line, and a copy-paste config block for connecting a local AI assistant to Beacon — it can read your collections, environments, and history, and send requests or run collections and flows, through the same engine the app's own UI uses. Off by default, and — like the Privacy tab's usage-data switch — it applies the moment you flip it rather than waiting for **Save**. The full story, including exactly what an AI client can and can't do and what is and isn't redacted, is its own chapter: [MCP / AI access](21-mcp-ai-access.md).

## The in-app updater

Beacon compares your version against the latest public release on GitHub and can update itself. It checks quietly a few seconds after launch, and then roughly once an hour for as long as Beacon stays open — so a window you left running for days still notices a new release. Quiet checks stay quiet: if one fails, you never hear about it.

The **Updates** row in the **General** tab reflects the current state — `Check for Updates` before anything has been checked, then `Checking for updates…`, `Beacon <version> is available`, `You're up to date (<your version>)`, or `Update check failed` with the reason underneath. Its **Check for Updates** button runs a check right now instead of waiting for the next hourly one, and — unlike the background check — it reports the outcome either way. When an update exists, the button walks through `Install <version>` → `Installing…` → `Restart to finish`. On macOS, **Check for Updates…** in the **Beacon** menu does the same thing and answers in a dialog. You can also update via Homebrew with `brew upgrade --cask beacon`.

Whenever a check finds a new version — at launch, on an hourly re-check, or from a check you asked for — an **update toast** appears in the bottom-right reading `Beacon <version> is available`, and an accent dot appears on the Activity Rail's Settings gear. If the release ships notes, a **What's new** row sits under the title; expand it to read what changed before you decide. **Download & Install** does the rest in one click — `Downloading… <n>%`, then `Installing…`, then **Restart to finish** — and the notes stay readable while it downloads. Dismiss the toast with its `×` to deal with it later.

From your next update onward, the first launch of the new version greets you with a one-time **What's new in <version>** popup carrying that release's notes; **Got it** or `Esc` closes it, and it doesn't come back.

> **Note:** The popup only appears when Beacon has a record of the version you were running before. A **fresh install** never shows one — there is nothing to compare against — and neither did upgrading **to** v0.1.0, the first release that started keeping that record. Every upgrade from a v0.1.0-or-later install shows it. The record is kept per device, so each computer you run Beacon on gets the popup once per release.

---

**See also:** [MCP / AI access](21-mcp-ai-access.md) · [Cloud accounts](16-cloud-accounts.md) · [History and cookies](17-history-and-cookies.md) · [Interface tour](02-interface-tour.md) · [Getting started](01-getting-started.md)

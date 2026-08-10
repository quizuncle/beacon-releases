# Cloud accounts

*Signing in, end-to-end-encrypted Cloud Sync across devices, and public collection sharing.*

**In this chapter**
- [Signing in](#signing-in)
- [The account menu](#the-account-menu)
- [Cloud Sync](#cloud-sync)
- [What syncs and what doesn't](#what-syncs-and-what-doesnt)
- [The sync passphrase](#the-sync-passphrase)
- [Unlocking on another device](#unlocking-on-another-device)
- [The sync button](#the-sync-button)
- [Managing sync](#managing-sync)
- [Collection sharing](#collection-sharing)

An account is entirely optional — Beacon is fully usable signed out. Signing in unlocks Cloud Sync (your data across devices) and makes collection sharing convenient.

## Signing in

On first launch, an optional `Sign in to Beacon` prompt appears (`Optional — identity only, no sync or sharing yet.`). Dismiss it with **Skip for now**, or sign in later from the Toolbar's **Sign in** button. There are three methods:

- **GitHub** or **Google** — opens the provider's page in your **default browser** (reusing any existing login) and catches the redirect back to Beacon. On success the browser shows `✓ Signed in to Beacon. You can close this tab and return to the app.`
- **Email + password** — fill both fields and click **Sign in**, or switch to **Create account** to register. **Forgot password?** sends a reset email.

## The account menu

Signed in, the Toolbar shows your avatar and name with a small green/red dot for online/offline. Click it for the account menu: your email; a sync control (`Enable Sync`, `Unlock Sync`, or `Sync now (N/5 today)` depending on state); `Sync settings` (opens [Settings → Sync](18-settings.md)); and `Sign out`.

> **Note:** Signing out clears the session on this device and stops sync, but never deletes your local data.

## Cloud Sync

Cloud Sync keeps your collections, environments, and settings consistent across the machines you're signed in on. Enable it from the account menu (`Enable Sync`). It's off until you turn it on.

Once active, a background poll pushes local changes every few seconds, and a manual **Sync now** does a push-then-pull. Conflicts resolve **newest-writer-wins** per item (by last-modified time), with a pending un-pushed local edit always winning over an incoming cloud version.

> **Note:** Manual syncs are rate-limited to **5 per 24 hours**; the automatic background sync is not affected.

## What syncs and what doesn't

**Synced:** **collections** (and their folders, requests, scripts, auth, and variables), **environments**, **global variables**, **workspaces**, **mock routes**, **flows**, and **app settings**.

**Not synced:** request/response **history**; **load-test** configs, runs, and samples; and your **proxy** host/port and credentials (kept per-device). Secret variable values are **encrypted** before upload (see below).

> **Note:** A collection carries its **script trust** across sync, unlike an import. One you enabled scripts for on another device arrives ready to run them; one you never enabled — or one saved before the trust flag existed — arrives **untrusted** and has to be enabled here. The rule is that only an explicit yes travels, so trust is never invented on the way. See [Collections](11-collections.md#the-script-trust-gate).
>
> A **flow** is the same: its **Script** nodes and any script on an inline request run on arrival without a separate prompt, because a synced flow is your own code coming from your own device under your own passphrase. A flow that arrives in a **bundle** is treated as foreign and has its scripts stripped instead — see [Collections](11-collections.md#importing).

**How flows travel.** Everything about a flow uploads in the clear on the same terms a collection's contents do — the canvas layout and wiring, flow and node names, condition sources, extract rows, links to saved requests, request URLs and bodies, and **Script** node code. Two credential-bearing spots are **encrypted** first, under the same passphrase as your secret variables:

- An **Inline** Request node's credentials — its auth (bearer token, basic username and password, API-key value, OAuth2 client secret, password, and access/refresh tokens), any credential-bearing header such as `Authorization`, `Cookie`, or `X-Api-Key`, a custom-named header or query-param row carrying that request's API key, and a `user:pass@` or API key written into the URL itself. A **Linked** Request node has no credentials of its own — the saved request it points to is protected as part of its collection.
- An **Input** node field's **Default value**, when that field has **Secret (masked)** turned on.

Nothing else in a flow counts as a credential, so a token you hardcode into a URL path, a body, or a script uploads exactly as you typed it. See [Flows](13-flows.md).

> **Note:** Flows only began syncing in v0.1.0. If you built flows on an earlier version they stayed on this machine; they upload on your **first sync after upgrading** — the next **Sync now**, passphrase unlock, or launch with sync on. If you'd rather they didn't leave the machine, turn sync off or delete them before that first sync.

## The sync passphrase

Your secret variable values are protected by a **sync passphrase** that only you know — Beacon never sees it, and it can't be recovered if forgotten. It's separate from your account password.

When you enable sync, you set the passphrase (minimum 8 characters, entered twice). Beacon derives an encryption key from it and encrypts only your secret-flagged values before upload; everything else syncs in the clear. The passphrase is cached in your OS keychain when available, so you don't re-enter it each launch.

> **Warning:** If you forget the passphrase it cannot be recovered. Your only option is to reset sync encryption from [Settings → Sync](18-settings.md), which sets a new passphrase from the current device and requires every other device to unlock again.

## Unlocking on another device

Sign in on a second device and Beacon shows **Unlock Cloud Sync**, asking for the passphrase you set on the first device. Enter it and click **Unlock**. A wrong passphrase shows `Incorrect passphrase.`

## The sync button

The Toolbar's dedicated sync icon reflects state, in priority order:

| State | Icon / meaning |
|---|---|
| **Syncing** | spinner — a sync is in progress |
| **Locked** | yellow lock — click to unlock with your passphrase |
| **Error** | red alert — shows the error; click to retry |
| **Offline** | grey — changes will sync when you're back online |
| **Dirty** | yellow refresh with a count — local changes pending; click to sync |
| **In sync** | green check — up to date, with the last-synced time |

Signed out or with sync off, the icon is greyed and non-interactive.

## Managing sync

The [Settings → Sync](18-settings.md) tab holds the rest:

- **Change Passphrase** — re-encrypts all secrets under a new key; other devices then need the new passphrase.
- **Forgot Passphrase?** — resets encryption from this device (with a required acknowledgment that other devices must unlock again).
- **Disable sync** — turns sync off on this device; an optional checkbox also deletes your synced data from the cloud. Local data is always kept.

## Collection sharing

You can publish a collection as a public link that anyone can import — no account required to import.

**Publishing.** From a collection's `⋯` menu, **Share…** creates a link like `beacon://share/<code>`, shown with a **Copy** button. Before publishing, Beacon strips credentials: secret variable values, auth fields (bearer tokens, basic passwords, API-key values, OAuth secrets/tokens), and credential-bearing headers (`authorization`, `cookie`, `x-api-key`, and similar).

> **Warning:** Beacon can't detect tokens **hardcoded directly** into a URL, header value, or body. Review the collection for those before sharing — the share modal warns you of this.

**Importing a share.** The **Import from share** button (link icon) in the Collections header takes a share link or code and imports the collection as `<name> (shared)` into your active workspace. Its scripts arrive untrusted. Importing is an unauthenticated public read — you don't need to be signed in.

**Revoking.** The **Manage shares** button (users icon) lists collections you've shared; **Revoke** deletes the shared copy so no one can import it again.

---

**See also:** [Settings](18-settings.md) · [Collections](11-collections.md) · [Variables and environments](07-variables-and-environments.md) · [Getting started](01-getting-started.md)

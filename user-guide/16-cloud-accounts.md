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

**Synced:** collections (and their folders, requests, scripts, auth, and variables), environments, global variables, workspaces, mock routes, and app settings.

**Not synced:** request/response **history**; **load-test** configs, runs, and samples; and your **proxy** host/port and credentials (kept per-device). Secret variable values are **encrypted** before upload (see below).

> **Note:** Collections that arrive by sync land with scripts **untrusted**, exactly like an import — enable them per collection after review. See [Collections](11-collections.md#the-script-trust-gate).

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

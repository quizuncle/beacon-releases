# Getting started

*Install Beacon, get past the first launch, and send your first request.*

**In this chapter**
- [Installing Beacon](#installing-beacon)
- [First launch](#first-launch)
- [The local-first model](#the-local-first-model)
- [Your first request](#your-first-request)

Beacon is a desktop app for macOS and Windows. On Windows and Linux, use `Ctrl` wherever this guide shows `⌘`.

## Installing Beacon

### macOS — Homebrew (recommended)

Run these two commands in Terminal:

```bash
brew tap quizuncle/beacon
brew install --cask beacon
```

The Homebrew cask installs Beacon into your Applications folder and clears the macOS quarantine flag for you, so the app launches without a Gatekeeper prompt.

### macOS — DMG download

Alternatively, download the DMG from the Beacon releases page, open it, and drag **Beacon** into your **Applications** folder.

> **Note:** Beacon is not code-signed or notarized. When you launch a DMG-installed copy for the first time, macOS Gatekeeper may block it. To open it anyway, either right-click the app and choose **Open**, or clear the quarantine flag in Terminal:
>
> ```bash
> xattr -cr /Applications/Beacon.app
> ```
>
> The Homebrew cask clears this automatically, so this step is only needed for the DMG install.

### Updates

Once installed, Beacon keeps itself up to date from within the app. When a new version is available, an update toast appears in the bottom-right corner, and you can also check manually in `Settings` → `Updates`. See [Settings](18-settings.md) for the full updater flow.

## First launch

The first time you open Beacon, an optional `Sign in to Beacon` prompt appears. Signing in is only needed for Cloud Sync — identity is entirely optional. To start using Beacon right away, choose **Skip for now**. You can sign in later at any time. See [Cloud accounts](16-cloud-accounts.md) for what an account unlocks.

## The local-first model

Everything you do in Beacon — requests, collections, environments, history, cookies — is stored in a local SQLite database in your user data folder on your own machine. Nothing is uploaded anywhere by default. Your data leaves your computer only if you explicitly turn on Cloud Sync from a signed-in account. This means Beacon works fully offline, and your requests and secrets stay on your device unless you opt in. See [Cloud accounts](16-cloud-accounts.md).

## Your first request

To send your first request:

1. Type a URL into the bar at the top of the window (the Omnibox).
2. Pick an HTTP method from the method dropdown to the left of the URL — it defaults to `GET`.
3. Press `⌘↵`, or click the **Send** button.
4. Read the response in the pane below — status code, timing, and body.

That's the full loop. For more on composing requests, see [Sending requests](03-sending-requests.md); for reading what comes back, see [Responses](09-responses.md).

---

**See also:** [Interface tour](02-interface-tour.md) · [Sending requests](03-sending-requests.md) · [Cloud accounts](16-cloud-accounts.md) · [Settings](18-settings.md)

# Beacon

**Beacon** is a fast, keyboard-first desktop API client for macOS — a modern alternative
to Postman/Insomnia. Compose and send HTTP requests, manage collections and environments,
write pre/post-request test scripts, chain assertions with a no-code builder, mock APIs
locally, monitor endpoints on a schedule, and inspect responses with a JSONPath filter,
auto-table view, and a request timeline breaking each response into waiting (TTFB),
downloading and total — all stored locally on your machine, no account required.

This repository hosts **downloadable builds only**. It does not contain Beacon's source
code.

> 📖 **[Read the User Guide](user-guide/README.md)** — a complete, indexed walkthrough of
> every feature, from your first request to flows, load testing, and cloud sync.

## Install

### Option 1 — Homebrew (recommended)

```bash
brew tap quizuncle/beacon
brew install --cask beacon
```

This handles downloading the right build for your Mac (Apple Silicon or Intel) and clears
the macOS "unidentified developer" quarantine flag automatically, so Beacon opens
immediately.

### Option 2 — Download the DMG directly

1. Go to the [latest release](https://github.com/quizuncle/beacon-releases/releases/latest)
   and download:
   - **`Beacon-<version>-arm64.dmg`** — for Apple Silicon Macs (M1/M2/M3/M4).
   - **`Beacon-<version>.dmg`** — for Intel Macs.

   Not sure which chip you have? Apple menu (`` ⌘`` icon, top-left) → **About This Mac**.

2. Open the DMG and drag **Beacon** into **Applications**.
3. **First launch only:** because Beacon isn't notarized by Apple (an indie project, no
   $99/yr Apple Developer subscription), macOS will refuse to open it with *"Beacon.app
   is damaged and can't be opened"* or *"cannot be opened because the developer cannot be
   verified."* This is expected — the app is not damaged. Run this once in Terminal:

   ```bash
   xattr -cr /Applications/Beacon.app
   ```

   Then open Beacon normally (double-click, or Spotlight). You will not need to do this
   again for future launches of this version.

   Alternatively: right-click **Beacon.app** → **Open** → **Open** in the dialog that
   appears — this bypasses Gatekeeper for that one launch without Terminal.

### Option 3 — One-line installer script

Downloads the correct build for your Mac, installs it to `/Applications`, and clears the
quarantine flag automatically:

```bash
curl -fsSL https://raw.githubusercontent.com/quizuncle/beacon-releases/HEAD/install.sh | bash
```

Review [`install.sh`](install.sh) before piping it to `bash` if you'd like to see exactly
what it does first — it only downloads the DMG from this repo's own GitHub Releases,
mounts it, copies the app, and runs `xattr -cr`.

## Requirements

- macOS 12 (Monterey) or later.
- Apple Silicon or Intel — both are published with every release.

## Why the Gatekeeper warning?

Apple requires a **paid Developer ID** ($99/year) to notarize apps distributed outside the
Mac App Store. Beacon is a free, independent project without that subscription, so macOS
shows its standard warning for any unsigned app from the internet. The `xattr -cr` command
above (also run automatically by Homebrew and `install.sh`) removes the quarantine
attribute macOS attaches to downloaded files — it doesn't disable any actual security
check, it just tells macOS "I've reviewed this and trust it," which is exactly what the
right-click-Open flow does through the UI.

## Updating

New versions are published as new [GitHub Releases](https://github.com/quizuncle/beacon-releases/releases).
If you installed via Homebrew: `brew upgrade --cask beacon`. Otherwise, download the new
DMG and repeat the install steps above (it replaces the existing `/Applications/Beacon.app`).

## Uninstall

```bash
# Homebrew installs
brew uninstall --cask beacon

# Manual installs
rm -rf /Applications/Beacon.app
rm -rf ~/Library/Application\ Support/Beacon   # local collections/history/settings (SQLite)
```

## Data & privacy

Beacon stores everything — collections, environments, history, settings — locally in a
SQLite database under `~/Library/Application Support/Beacon`. Nothing is sent to any
server operated by the developer; requests you send go directly from your machine to
whatever API you point Beacon at, same as any HTTP client.

## Support / feedback

This is a personal project shared as-is. Open an issue on this repository for install
problems with a specific release.

## Made by

Beacon is built by [Quizuncle](https://quizuncle.com/), a small independent software
studio. See [everything we make](https://quizuncle.com/products/) — a Q&A and discussion
platform, and free browser-based tools for developers.

## License

Beacon is distributed under the [MIT License](LICENSE).

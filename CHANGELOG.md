# Changelog

## v0.2.0 — 2026-08-11

An editor that finally works offline, a way to tell us what you think, and a
long list of accessibility and security repairs. Beacon also starts reporting
anonymous usage data — see the last section, and `Settings → Privacy`.

**The editor no longer needs the internet**

- **Beacon used to download about five megabytes of the Monaco editor from a
  public CDN** the first time you opened any editor. Without a network — on a
  plane, or behind a proxy that blocked it — there was no editor at all, in an
  app that's meant to be local-first. The editor now ships inside Beacon.
- The updater now validates what it downloads before offering it to you.

**Feedback**

- **You can now send feedback from inside Beacon** — a rating, a note, and
  optionally an email if you want a reply. Find it in the command palette
  (`>` then "Send Feedback"), the account menu, or `Settings → Privacy`.
- **It works offline.** Feedback is queued on your machine and sent when you're
  next connected, so writing it on a plane doesn't lose it.

**Accessibility**

- **Every control has a usable name**, and the sidebar works without a mouse.
- **Closing and pinning a tab now work from the keyboard.** Both were plain
  text with no role and no focus, so neither was reachable at all.
- Screen readers can now see the tab controls, which were nested inside another
  button and hidden as a result.

**Security**

- **A response body can no longer navigate a subframe anywhere it likes.**
  Frame navigation is now checked against an allowlist, and redirects are
  checked on the main window too, not just direct navigations.
- Cookie clearing for a host and for its parent domain are now separate
  actions, so clearing one no longer quietly signs you out of the others.

**Fixes**

- **One malformed row in a bundle no longer discards the whole import.**
- **A flow editor left open in the background can no longer overwrite someone
  else's newer version of that flow.**
- Tooltips no longer rename controls that already have their own visible text.
- Nested lists render at any depth in Markdown, and a blank line no longer
  splits one list into two.

**Usage data**

- Beacon now reports anonymous usage — which features get used, app version,
  platform, rough location, and scrubbed error reports — tied to a random ID
  generated for this install, never to your name unless you sign in.
- It never includes your requests, responses, secrets, scripts, or the names of
  anything you've created.
- It's on by default; one switch in `Settings → Privacy` turns it off, and that
  page has the full detail.

## v0.1.0 — 2026-08-10

Bundle exports, hourly update checks, and live theme previews.
Two behavior changes are worth reading before you upgrade — they're below.

**Export and import**

- **Export the whole workspace in one click.** The new Export dialog has a
  Workspace preset that puts every collection, environment, global variable,
  mock route, and flow into a single file.
- **Or pick exactly what you want.** Select any number of collections and tick
  the extras you want alongside them — environments, globals, mock routes,
  flows.
- **Secrets stay out unless you say otherwise.** Secret environment values,
  auth credentials, API keys in URLs, and credential headers on mock routes
  are blanked by default; including them takes a deliberate confirmation.
- **Importing asks where things should go** and reports what landed. Flows
  keep their links to the requests they call, remapped to the imported copies.
- Single-collection and Postman imports work exactly as before — a bundle is
  recognized when you open it, so there's one Import button for both.

**Updates**

- **Beacon now checks for updates every hour while it's running**, not only at
  launch. An update released while you're working shows up the same hour.
- **The update notice carries the release notes.** Expand "What's new" in the
  notification to read what changed before you decide to install.
- **After an update installs, Beacon shows a one-time "What's new" popup** on
  the next launch, so a release installed in the background doesn't go unread.
  This release is the one that puts the mechanism in place; the popup itself
  starts appearing from the next release onward.

**Appearance**

- **Clicking a theme in Settings previews it immediately** across the whole
  app. Cancel and it reverts to what you had; save and it sticks.

**Please read before upgrading**

- **Clearing cookies for a host now also clears that host's parent-domain
  cookies.** This matches how Beacon already decides which cookies to *send*:
  a cookie set on `.example.com` was sent with requests to `api.example.com`
  but survived clearing them, so "clear" didn't. Clearing cookies for one
  subdomain can now sign you out of its siblings. The confirmation dialog
  names what will be removed before anything happens.
- **Flows now sync to the cloud** alongside collections, environments, and
  globals. If you use Cloud Sync, your flows upload on the first sync after
  upgrading. Credentials stored inside a flow are encrypted before upload, the
  same as everywhere else in sync.

**Security**

- A response body, a collection's notes, or an OAuth page can no longer open
  arbitrary windows or navigate the app away from itself. External links open
  in your browser, and only `http`/`https` ones do.
- OAuth authorization URLs are validated before the sign-in window opens.
- A link written as `//somewhere-else.com` in notes is no longer rendered as a
  live off-site link.
- Exporting or sharing a flow no longer carries credentials left behind on a
  node whose auth mode was switched.

**Fixes**

- Turning the proxy off and back on no longer discards the saved proxy
  username and password.
- A blank proxy port no longer saves as an unusable value.
- Cookies whose domain contains uppercase letters are now sent with matching
  requests.
- Clearing cookies with an empty host no longer wipes the entire cookie jar.
- Lists in request and collection notes render correctly when a bullet wraps
  across lines or mixes numbered and unnumbered nesting.
- Icon-only buttons throughout the app, and every input in Settings, now carry
  accessible names for screen readers.

## v0.0.6 — 2026-08-07

Beacon gets a third theme line: **Bloom** — four pink-toned shades alongside
the existing Dark and Light groups in Settings → Appearance.

- **Four new themes:** Mulberry (deep plum-wine) and Mauve (dusty rose-grey)
  for dark mode; Quartz (soft blush) and Shell (warm peach-cream) for light.
- **Each Bloom shade carries its own accent color** — buttons, focus rings,
  and selection match the shade instead of staying blue. Your custom accent
  color, if set, still wins everywhere.
- **Softer corners under Bloom.** Bloom shades round the UI's corners a
  touch more; the existing six themes render exactly as before.
- **Every Bloom palette is contrast-checked** against the same legibility
  bars the shipped themes meet, enforced by tests so future tuning can't
  quietly regress readability.
- Fixed: the Appearance grid now marks the active theme correctly for
  settings saved before named themes existed (the old "dark"/"light"
  values showed no selection).

Switching themes, custom accents, and all existing settings carry over
unchanged.

## v0.0.5 — 2026-08-07

Beacon's cloud backend has moved to a new home. Nothing changes in the app
itself, but anything stored in the cloud starts fresh.

**Please export anything you care about before upgrading.**

- **Your cloud account does not carry over.** Signing in after upgrading
  creates a new, empty account — even with the same Google or GitHub login.
- **Synced collections, environments, and globals do not carry over.** If
  Cloud Sync held your only copy of something, export it first: right-click
  the collection or environment in the sidebar and choose "Export as JSON".
- **When exporting an environment, choose "Include secrets".** Beacon leaves
  secret values out of exports by default, so a backup taken with the default
  option restores with those values blank.
- **Collection share links created before v0.0.5 will stop working.** If
  you've shared a collection, ask recipients to import it before they
  upgrade, or re-publish it afterwards to get a fresh link.
- **Don't use sign-out to "start over" until you've exported.** Signing out
  clears local collections and history by design.

Upgrading by itself leaves local data alone — your collections, environments,
history, and settings stay exactly where they are. Only cloud-stored data and
previously published share links are affected.

This release also hardens how API keys in URLs are handled:

- Sharing a collection now blanks an API key kept directly in a request URL's
  query string (`?apiKey=...`), the same way it already blanked the matching
  params row and the auth field. Previously that URL copy survived into the
  public share document.
- Cloud Sync now encrypts the same URL copy before upload, alongside the
  credentials it already encrypted. Existing synced URLs are unaffected and
  round-trip unchanged.

## v0.0.4 — 2026-08-06

Query params now sync both ways between the URL bar and the Params panel, plus
autosave for saved requests and a handful of fixes.

- Query params typed directly into the URL bar (e.g. `?page=2`) now sync into
  the Params panel automatically, and params added in the Params panel now
  show up in the URL bar's preview.
- New "Autosave Requests" setting (Settings → General, off by default):
  automatically saves changes to an already-saved request a couple of
  seconds after you stop editing it.
- Opening a saved request — from History, search, or an existing tab — now
  reveals its folder in the Collections sidebar.
- "Sync settings" in the profile menu now opens directly to the Sync tab
  instead of General.
- Fixed: long values in the Interactive response view could wrap onto a
  second line and overlap the row below.

## v0.0.3 — 2026-08-04

A redesigned navigation and interaction layer, plus a round of bug fixes.

- The sidebar is now grouped into Data, Test, and System sections with visible
  labels, and can be collapsed to icons-only from a new toggle at the bottom.
- Empty states (Collections, Environments, Load Tests) now show a clear
  heading, description, and one-click action instead of plain text.
- Every destructive confirmation (deleting a workspace, collection, request,
  or signing out) now uses one consistent in-app dialog instead of the
  browser's native popup.
- Environments are now workspace-specific — switching workspaces switches
  your environment list too, instead of showing every environment from every
  workspace.
- Keyboard navigation and screen-reader support improved throughout: tabs,
  dialogs, and form controls now expose their state properly.
- Fixed: creating a collection from a non-default workspace silently did
  nothing. Sending a request whose URL started with a `{{variable}}` could
  clear the URL bar and open a stray tab instead of sending. Saving changes
  to an already-saved request could incorrectly re-open the "save to
  collection" dialog. The Collection Runner's summary could show a run's
  duration twice, or fail to reflect an in-progress run in the status bar.
  Load test charts could clip a value's label against the chart title above
  it.

## v0.0.2 — 2026-07-29

Two small fixes in the Environments panel.

- Fixed the cursor jumping to the end of the field while typing in an
  environment or global variable's name or value — you can now edit in the
  middle of existing text normally.
- Environment and Globals row names now match the rest of the sidebar's text
  size, instead of rendering slightly larger.

## v0.0.1 — 2026-07-29

Initial public release.

Beacon is a keyboard-first desktop API client — compose and send HTTP requests, organize
them into collections, write pre-request and test scripts, manage environments and global
variables, and test WebSocket connections, all stored locally. This release also adds
public sharing: publish a collection or environment as a link anyone can import, with
secret-flagged values stripped before anything goes out.

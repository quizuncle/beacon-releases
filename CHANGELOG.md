# Changelog

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

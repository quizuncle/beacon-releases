# Changelog

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

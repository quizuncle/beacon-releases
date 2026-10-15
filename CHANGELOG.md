# Changelog

## v0.4.0 — 2026-10-15

Turn an OpenAPI spec into a working collection, and keep it in step as the spec changes.
Run one request across every row of a CSV or JSON file.
And an AI assistant can now find, call and bulk-run your API's operations — with production kept read-only by default.

**OpenAPI import**

- **Import a spec from a URL or a file.** OpenAPI 3.x and Swagger 2.0, JSON or
  YAML. You get one collection per spec, a folder per tag, a `{{baseUrl}}`
  variable from the spec's servers, and one request per operation with an
  example body built from its schema (server-set `readOnly` fields left out).
- **Re-sync without losing your edits.** Right-click the collection and choose
  **Re-sync from spec**: new operations are added, untouched requests are
  updated, and a request you have edited is left exactly as it is and marked
  **spec changed**. Operations dropped from the spec are kept and marked
  **removed from spec**; nothing you deleted comes back.
- **The full story is a new user-guide chapter:** [Importing OpenAPI
  specs](https://beacon.quizuncle.com/guide/openapi-import/).

**Run with data**

- **Send one request once per row of a CSV or JSON file.** Open it from the
  **Run with data** button next to Send, the command palette, or a saved
  request's right-click menu. Write `{{column}}` anywhere you would use a
  variable; scripts get the row as `pm.iterationData`.
- **A column check before you run** flags columns nothing uses and variables
  no column fills.
- **Up to 10 rows in parallel**, with a delay, stop-on-first-failure, and a
  choice of failing on status or on tests. The run keeps going when you switch
  tabs.
- **Re-run only the failed rows**, then **export a results CSV** — your input
  columns plus status, timing and any response fields you pick, with cells
  guarded so Excel never runs them as formulas.
- **New chapter:** [Run with
  data](https://beacon.quizuncle.com/guide/run-with-data/).

**MCP / AI access**

- **Five new tools — sixteen in all.** `beacon_search` finds an operation or
  request by what it does, `beacon_describe_request` shows its parameters and
  schema, `beacon_call` calls it by exact id, `beacon_list_specs` lists your
  imported specs, and `beacon_import_openapi` imports or re-syncs one.
- **`beacon_call` returns just what the AI asked for.** Pick response fields,
  cap the body size, and attach checks (`status`, `">0"`, `"!=null"`, `"~text"`)
  that come back as pass or fail. `beacon_send_request` takes the same options.
- **Bulk runs from an AI.** Give `beacon_call` a data file or a list of rows
  and it runs up to 1,000 of them in one call, returning a summary, the failed
  rows and an optional results CSV. The status bar shows the run with a
  **Stop** button, and each row lands in History marked as AI.
- **AI read-only environments, on by default for anything named `prod`.** An
  AI client may only send `GET`, `HEAD` and `OPTIONS` on such an environment —
  in calls, sends, and collection and flow runs. Switch it per environment
  with the **AI read-only** checkbox in the environment editor.
- **Credential headers stay yours.** `beacon_call` refuses to override
  `Authorization` and similar headers; keep tokens in an environment secret.
- The bundled MCP adapter is now `@quizuncle/beacon-mcp` 0.3.0. See [MCP / AI
  access](https://beacon.quizuncle.com/guide/mcp-ai-access/) for every tool and
  its limits.

## v0.3.2 — 2026-08-30

An AI assistant can now work inside Beacon — read your collections, send
requests with your saved auth, and run collections and flows — without ever
being able to read a credential.

**MCP / AI access**

- **A new Settings tab, off by default.** Flip **Allow AI clients to control
  Beacon** and a local socket opens for MCP-capable assistants (Claude,
  Cursor, and others); flip it off and the socket is gone. The tab shows a
  live status line and a copy-paste client config built from your machine's
  real paths.
- **The AI can use your credentials and can never learn them.** Auth and
  `{{secret}}` variables resolve inside Beacon; everything an AI reads back —
  request definitions, environments, history, run reports, even error
  messages — passes the same redaction Beacon's own report exports use.
  Reading and running only: no AI-driven create, edit or delete exists at
  any layer.
- **Ten tools**, from `beacon_list_collections` to `beacon_run_flow` — an
  AI-driven send lands in your History like any other request.
- **Works headless too.** Point the bundled adapter at an exported bundle
  (`BEACON_BUNDLE`) and it drives the `beacon` CLI instead of the app —
  reads and runs in CI, with the same redaction, no Beacon window needed.
- **The full story is a new user-guide chapter**, including exactly what is
  and isn't redacted and every headless limit: [MCP / AI
  access](https://beacon.quizuncle.com/guide/mcp-ai-access/).

**Watch it happen**

- **AI-driven flow runs show up live on the canvas.** With a flow's tab open,
  its nodes light up as an AI client's run walks them — including a node that
  fails and is routed around, which turns red even when the run completes.
  A run-log line records the AI run. Nothing ever opens a tab or steals
  focus.
- **You can always tell when an AI client acted.** A small dot appears on
  the History rail icon when AI-sent requests land while you're elsewhere,
  every AI-sent history row carries an **AI** chip, and the status strip
  shows a quiet "AI connected" while an assistant holds an authenticated
  connection.
- **Flows are first-class for AI clients:** a new `beacon_list_flows` tool,
  and `beacon_run_flow` accepts the flow's name as well as its id.
- **Run reports made by an AI client now say so** — attributed to
  `beacon-control` at the app's real version, instead of claiming
  `beacon-cli` at version `dev`.

**The `beacon` command line**

- **`beacon validate --json`** prints a machine-readable, redacted inventory
  of a bundle — collections, folders, requests, environments and flows — for
  scripts and for the MCP adapter's headless mode.

**Fixes**

- **A secret variable's *initial* value is now masked everywhere its current
  value already was.** It previously survived in plain text in what an AI
  client could read back and in the new `validate --json` inventory.
- Report redaction now also scrubs oauth2 credentials (client secret,
  password, access and refresh tokens) and server-issued `Set-Cookie` values
  out of history read-backs.

## v0.3.0 — 2026-08-26

Every run can now leave a report behind — and Beacon has a command line.

**Run reports**

- **A finished Collection Runner run exports a report** in three formats. JSON
  for machines, **JUnit XML** so Jenkins, GitLab or GitHub Actions show your
  `pm.test()` assertions as test results, and a self-contained **HTML page**
  you can open in a browser or attach to a ticket — no scripts, no external
  requests.
- **Finished flow runs export the same three formats**, one entry per request
  node.
- **Monitors export their health history** as JSON — the schedule, the
  thresholds, the uptime percentage and every run still kept.
- **Reports are redacted before they are written, always.** Credential headers
  lose their values, your API key is blanked wherever it is carried — including
  under a header or query-parameter name you invented — a `user:password@` in a
  URL is stripped, and every value you marked **secret** is replaced with
  `••••••` in URLs, console output, assertion messages and bodies. There is no
  switch to turn this off. Request and response bodies are left out entirely
  unless you tick **Include bodies**, which applies to the JSON report only.
- **The old Export Results button is gone.** It wrote the raw result array,
  resolved `Authorization` headers and all, straight to a file.

**The `beacon` command line**

- **A new headless runner ships with this release**, as its own download
  (`beacon-cli-0.3.0.js`). It runs an exported bundle's **collections and
  flows** from a terminal or a CI job — scripts, cookies, dynamic variables and
  chained requests included, using the same execution code as the app rather
  than a re-implementation.
- **Exit codes are the CI contract:** `0` everything passed, `1` the run
  finished with failures, `2` the command or the bundle was wrong.
- `--report json,junit,html` writes the same reports the app exports,
  `--env-var NAME=value` injects a credential without committing it, and
  `--no-scripts` runs a bundle without executing any of its code.
- **It warns when a bundle carries a secret** you exported with it, naming the
  key and never the value.

**Fixes**

- **Run Again after a collection run did nothing.** The button threw and left
  the runner where it was.
- **A flow report could publish an API key** sent under a header or query-name
  you chose yourself. Flow runs now resolve each step's own auth, the way a
  collection run always did.
- **A credential typed straight into the Auth panel** — rather than stored in a
  variable — is now masked in reports too.
- **Monitor health exports scrub secrets** out of error messages, which can
  quote a value a request was carrying.

## v0.2.2 — 2026-08-13

Every Copy button works again.

**Fixes**

- **Copying to the clipboard silently did nothing.** A share link, a response
  body, a value or a path from the JSON tree, a code snippet, a cURL command,
  the diagnostics in the About window — every one of them failed without
  saying so, and the icon just never changed to a tick. Beacon was refusing
  itself permission to write to the clipboard. This has been broken since
  v0.2.0; if you tried to copy something and nothing arrived, that was this.
- **Beacon still cannot read your clipboard.** Only writing was restored, so
  nothing shown in the app can see what you last copied elsewhere.

## v0.2.1 — 2026-08-13

A proper About window, and a one-click way to copy any request as a cURL
command.

**About Beacon**

- **Beacon now has a real About window**, with the version, links to the site,
  the changelog and the terms, and the support address. Open it from the Beacon
  menu.
- **It shows what a good bug report needs** — the Electron, Chromium and Node
  versions Beacon is running on, and your platform — with a button that copies
  all of it at once.
- **You can check for updates from it**, and the result appears in the window
  rather than in a separate dialog.

**Copy as cURL**

- **A new button in the request bar copies the current request as a cURL
  command in one click.** Previously this meant opening the code-snippet
  window, choosing cURL, copying, and closing it again.
- **It produces exactly what the code-snippet window produces** — the same
  resolved variables, the same inherited collection and folder headers and
  auth, and query parameters folded into the URL.

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

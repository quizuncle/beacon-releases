# Collections

*Organizing saved requests into collections and folders — with inherited auth, headers, and variables, import/export, sharing, and bulk find-and-replace.*

**In this chapter**
- [The Collections panel](#the-collections-panel)
- [Creating and organizing](#creating-and-organizing)
- [Favorites and search](#favorites-and-search)
- [Collection settings](#collection-settings)
- [Folder settings](#folder-settings)
- [Inheritance](#inheritance)
- [Request row actions](#request-row-actions)
- [Examples](#examples)
- [Importing](#importing)
- [Exporting](#exporting)
- [Sharing](#sharing)
- [Find and replace](#find-and-replace)
- [The script trust gate](#the-script-trust-gate)

## The Collections panel

Open the **Collections** panel from the Activity Rail (`⌘1`). Its header has icon buttons for **Find & Replace**, **Import**, **Import from share**, **Manage shares**, and **New collection**, plus the panel's pin button.

## Creating and organizing

- **New collection** — the **+** button (`Create a new empty collection.`).
- **Add a folder** — from a collection's `⋯` menu (`Add folder`); folders can nest with `Add sub-folder`.
- **Color** — `Set color…` opens a swatch grid (with a hex input and `Remove color`). Collections group by color in the tree, and a colored collection shows an accent left border.
- **Reorder** — drag requests within or between folders (dropping onto a folder auto-expands it), and drag collections to reorder them. Dragging a collection into a different color group adopts that group's color.

Clicking a collection's **chevron** expands it; clicking its **name** opens its settings tab.

## Favorites and search

Star any request (its `★` on hover) to pin it under a **★ Favorites** section at the top of the panel. The **Search requests…** box live-filters by name, URL, and method, grouping results by collection and bold-highlighting the match; clicking a result opens it and reveals its folder ancestors.

## Collection settings

Clicking a collection name opens its settings tab, with five tabs:

- **Variables** — collection-scoped variables (with per-row **Secret** toggles). These sit between environment and global in the [resolution order](07-variables-and-environments.md#resolution-order).
- **Headers** — headers applied to every request in the collection; a request's own header of the same name overrides them.
- **Auth** — auth applied to every request unless a folder or request sets its own. See [Authorization](06-authorization.md).
- **Docs** — a Markdown editor with an Edit/Preview toggle.
- **Scripts** — collection-level `Pre-request Script` and `Tests` that run around every request's own scripts. See [Scripts and tests](08-scripts-and-tests.md).

Each tab has a **Save** button that flashes `✓ Saved`.

## Folder settings

A folder's `Folder settings…` modal has **Auth**, **Headers**, and **Docs** tabs. The Auth tab can inherit from parent folders and the collection, showing a summary like `Inherits Bearer Token from folder "X".` Folder headers apply to every request inside the folder and its sub-folders.

## Inheritance

Auth, headers, and variables cascade down the tree. When a request resolves its effective auth or headers, Beacon walks **request → nearest folder → parent folders → collection**, with the nearest setting winning. A request whose auth is `Inherit` (or unset) uses the first auth found walking up. This lets you configure a token or a base header once and have every request inside pick it up. The same resolution is used by [code snippets](03-sending-requests.md), the [runner](12-collection-runner.md), [flows](13-flows.md), and [load tests](14-load-testing.md).

## Request row actions

Hover a request for its `★` star and `⋯` menu; double-click to rename inline. The `⋯` / right-click menu offers `Open`, `Rename`, `Duplicate` (creates `<name> Copy`), `Monitor this request` (see [Monitors](15-mock-websocket-monitors.md#monitors)), `Examples` / `Hide examples`, and `Delete`.

## Examples

A saved request can hold named response **examples** (saved from the response viewer — see [Responses](09-responses.md#saving-an-example)). The `Examples` submenu lists them; each example can be **previewed**, turned into a mock route with **Generate mock** (see [Mock, WebSocket, and monitors](15-mock-websocket-monitors.md#generating-a-route-from-an-example)), or deleted.

## Importing

**Import** (bulk) opens the **Import Collections** modal with three sources: **Select Folder** (all `.json` files in a folder), **Select Files** (one or more `.json` files), and **Beacon Folder** (a git-friendly Beacon collection folder). Beacon auto-detects each file's format:

- **Postman collections**
- **Postman environment / globals exports**
- **OpenAPI 3 / Swagger 2 specs** — grouped into folders by tag, with examples pulled into request bodies
- **HAR files** — each entry becomes a request

A progress bar shows `Importing <n> of <total>…`. Results list what imported and what failed, with a collapsible `⚠ Imported with <n> warning(s)` section noting anything adjusted (unsupported auth set to none, file fields without a source path dropped, unrecognized items skipped).

> **Note:** Imported collections arrive with scripts **untrusted** — see [the trust gate](#the-script-trust-gate).

## Exporting

From a collection's `⋯` menu: **Export as JSON** saves a `<name>.postman_collection.json` file, and **Export as folder** writes a git-friendly Beacon collection folder to a directory you pick.

## Sharing

Beacon can publish a collection as a public share link that anyone can import without an account. `Share…` (in the `⋯` menu) creates the link; the header's **Import from share** and **Manage shares** buttons import and revoke shares. The full sharing flow — including what is stripped before publishing — is in [Cloud accounts](16-cloud-accounts.md#collection-sharing).

## Find and replace

**Find & Replace** (the header button) searches and rewrites across every collection at once. Enter a **Find** and **Replace with** term, toggle case-sensitivity (`Aa`), whole-word (`W`), or regex (`.*`), and choose which fields to search: `URL`, `Header key`, `Header value`, `Param key`, `Param value`, `Body JSON`, `Body raw`, and `Include collection variables`. Matches are listed grouped by collection with per-match checkboxes. It's two-phase: **Preview replacement** shows exactly what will change, then **Apply replacement** writes it.

> **Warning:** Find & Replace writes directly to your saved requests and collection variables, and cannot be undone automatically. Review the preview before applying.

## The script trust gate

Because scripts can read your secrets, collections you didn't create start **untrusted** — their pre-request and test scripts do not run. Imported and shared collections both land this way. The `⋯` menu shows `Enable scripts…`, which confirms: *"Only enable for collections you trust — pre-request and test scripts run inside Beacon and can read your secrets."* Once trusted, the menu shows `Disable scripts` to revoke it. See [Scripts and tests](08-scripts-and-tests.md#the-script-trust-gate).

---

**See also:** [Authorization](06-authorization.md) · [Variables and environments](07-variables-and-environments.md) · [Scripts and tests](08-scripts-and-tests.md) · [Collection runner](12-collection-runner.md) · [Cloud accounts](16-cloud-accounts.md)

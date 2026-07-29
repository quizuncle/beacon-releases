# Interface tour

*A map of the Beacon window — every panel, rail, and bar, and what each one does.*

**In this chapter**
- [Window layout](#window-layout)
- [The Toolbar](#the-toolbar)
- [The Activity Rail](#the-activity-rail)
- [The Peek panel](#the-peek-panel)
- [The Omnibox](#the-omnibox)
- [Tabs and the Workbench](#tabs-and-the-workbench)
- [Workspaces](#workspaces)
- [The Status strip](#the-status-strip)

On Windows and Linux, use `Ctrl` wherever this guide shows `⌘`.

## Window layout

Beacon stacks its interface top to bottom:

1. **Toolbar** — the title bar, always visible. Logo, layout/theme toggles, workspace and environment selectors, sync, and account.
2. **Omnibox** — the URL and command bar. It appears only when the active tab is a request; entity tabs (an environment, a collection, a flow, and so on) hide it.
3. **Main row** — three columns: the **Activity Rail** (far left, 44px), the **Peek panel** (a slide-out sidebar), and the **Workbench** (the tab strip plus the request and response panes).
4. **Status strip** — a thin 22px bar along the bottom showing request status and a row of shortcut hints.

An update toast may float in the bottom-right corner when a new version is ready, and the keyboard-shortcuts overlay appears on top of everything when you press `⌘/`.

## The Toolbar

From left to right, past the Beacon wordmark (tooltip `Beacon — your requests and collections, all local-first.`):

| Control | What it does |
|---|---|
| **Layout toggle** | Switches the request/response split between side-by-side and stacked. The button reads `Split` (side-by-side) or `Stack` (stacked). |
| **Theme cycle** | Cycles the theme `light → dark → system`. The icon shows a sun, moon, or monitor. |
| **Workspace switcher** | Shows the active workspace name; the dropdown lets you switch, rename, delete, or add workspaces. |
| **Environment selector** | Shows a green dot and the active environment name, or `No Environment`. The dropdown picks the active environment for `{{variable}}` resolution (`⌘E`). |
| **Sync button** | A single icon reflecting cloud-sync state (syncing, dirty, in sync, offline, locked, error, or off). See [Cloud accounts](16-cloud-accounts.md). |
| **Account control** | Your avatar and name, or a `Sign in` button when signed out. See [Cloud accounts](16-cloud-accounts.md). |

## The Activity Rail

The narrow icon bar on the far left toggles the Peek panel between views. The active item shows an accent bar on its left edge.

| Icon | Opens | Shortcut |
|---|---|---|
| Folder | **Collections** — saved requests grouped into collections and folders | `⌘1` |
| Clock | **History** — every request you have sent, newest first | `⌘2` |
| Globe | **Environments** — named sets of `{{variables}}` you switch between | `⌘3` |
| Workflow | **Flows** — chain requests visually on a canvas | `⌘4` |
| Plug | **Connections** — the mock server and WebSocket tools | `⌘5` |
| Gauge | **Monitors** — run a request on a schedule and track its health | — |
| Zap | **Load Tests** — fire a request many times concurrently | — |
| Cookie | **Cookies** — the per-domain cookie jar | — |
| Gear (bottom) | **Settings** — SSL, timeouts, proxy, theme, and preferences | `⌘6` |

> **Note:** When an update is available, an accent dot appears on the **Settings** gear and its tooltip changes to `Settings — Beacon <version> available`.

The **Connections** view (`⌘5`) is a small launcher with two rows — `Mock Server` and `WebSocket` — each of which opens its tool in the Workbench. See [Mock, WebSocket, and monitors](15-mock-websocket-monitors.md).

## The Peek panel

The Peek panel is the slide-out sidebar the Activity Rail controls. It can be **pinned (docked)** or **unpinned (floating)**:

- **Pinned** — docked inline; it pushes the Workbench to the right, stays open, and is not dismissed by clicking away or pressing `Esc`.
- **Unpinned** — floats as an overlay over the Workbench; clicking outside it or pressing `Esc` closes it.

Toggle the mode with the **Pin** button in each panel's header (tooltip `Pin panel open` / `Unpin panel`). Drag the panel's right edge to resize it (220–560px). There is no dedicated close button — toggle a panel with its rail icon, `Esc`, or by clicking away when floating.

> **Note:** The **Settings** and **Cookies** views open as full-screen modals rather than as Peek panels.

## The Omnibox

The single bar above the request panes is the URL input, method selector, and command palette all in one. It changes behavior based on what you type — a URL, a `>` command, a `{{` variable, a pasted `curl` command, or a search. Full details are in [Sending requests](03-sending-requests.md).

## Tabs and the Workbench

The Workbench holds your open tabs and the request/response panes.

**Tab kinds.** A request tab shows the first three letters of its method (`GET`, `POS`, `DEL`), colored by method. Other tab kinds — environment, collection, flow, monitor, load test, mock, WebSocket — show an icon instead.

**Opening tabs.** Click the **+** at the end of the strip (or press `⌘T`) for a new empty request. Click a saved request, environment, or flow to open it. Entity tabs reuse an existing tab if the same entity is already open.

**Managing tabs:**

- **Close** — hover and click the **×**, middle-click the tab, or press `⌘W` for the active one.
- **Reorder** — drag a tab along the strip.
- **Rename** — double-click a tab's title, type, and press Enter.
- **Pin** — pinned tabs show a pin icon and persist across sessions; clicking **×** on a pinned tab unpins it rather than closing it.
- **Context menu** — right-click a tab for `Close Tab`, `Close Tabs to the Right`, `Close Tabs to the Left`, `Close All Other Tabs`, and `Close All Tabs`.

> **Note:** A tab with unsaved changes shows a small pulsing accent dot in place of its close button. See [Sending requests](03-sending-requests.md#sending-cancelling-saving) for saving.

**Focus and split.** Press `⌘\` to cycle Workbench focus: both panes → response only → request only → both. Drag the divider between the request and response panes to resize the split (20–80%). The Toolbar's layout toggle switches between side-by-side and stacked arrangements. With no tab open, the Workbench shows `No tab open — Press ⌘T for a new request, or open one from the sidebar.`

## Workspaces

A workspace is a named container that scopes its own collections. Switch, create, rename, and delete workspaces from the Toolbar's workspace switcher. Deleting a workspace prompts you to either move its collections to another workspace or delete them; you cannot delete the last remaining workspace.

## The Status strip

The bottom bar shows a status dot on the left — `Sending…` (yellow) while a request is in flight, `Ready` (green) otherwise, and the status code plus duration after a response returns. The right side shows a compact hint row: `⌘↵ Send`, `⌘K Commands`, `⌘P Open`, `⌘\ Focus`, `⌘E Env`, `⌘? Keys`.

---

**See also:** [Getting started](01-getting-started.md) · [Sending requests](03-sending-requests.md) · [Settings](18-settings.md) · [Keyboard shortcuts](19-keyboard-shortcuts.md)

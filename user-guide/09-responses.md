# Responses

*Reading what comes back — status, body views, the response tabs, diffing, saving examples, and watching.*

**In this chapter**
- [Response states](#response-states)
- [The status bar](#the-status-bar)
- [Automatic banners](#automatic-banners)
- [The Body tab](#the-body-tab)
- [Other response tabs](#other-response-tabs)
- [Diffing responses](#diffing-responses)
- [Saving an example](#saving-an-example)
- [Watch: re-send on an interval](#watch-re-send-on-an-interval)

## Response states

Before and during a request, the response pane shows a state instead of a body:

- **Waiting** — before the first send: `Waiting for a response`, with a reminder that `⌘↵` sends from anywhere.
- **Loading** — an animated skeleton while the request is in flight.
- **Could not send** — when the request never reached a server: an explanation plus the raw error. Check that the URL is reachable and the server is running.

## The status bar

Once a response returns, a bar across the top shows:

- **Status pill** — a colored dot and `200 OK`. Non-2xx responses add a colored top border to the pane.
- **Time** — the response time, colored by speed. If there was a previous response, a delta chip shows whether this one was faster or slower.
- **Size** — the formatted body size.
- **Tests** — a `passed / total` summary when tests ran.

On the right are action buttons: **Diff** (compare responses), **Pin baseline** (pin this response as the baseline future responses diff against), **Save example**, **Copy** (copies the body), and the **Watch** control.

## Automatic banners

Two banners appear on their own when relevant:

- **Rate limit** — when the response carries rate-limit headers (`x-ratelimit-remaining`, `retry-after`, and similar), a banner shows how many calls remain and when the limit resets. It turns red as you approach the limit.
- **Token detected** — when a JSON response has a top-level token field (`access_token`, `token`, `jwt`, `refresh_token`, and similar) and an environment is active, a blue banner offers to save it: `🔑 <key> detected — Save to environment as {{key}}`. Click **Save** to write it straight into the active environment.

## The Body tab

The body has four view modes in a segmented control:

| Mode | What it shows |
|---|---|
| `Interactive` | An explorable JSON tree — see [Living Response](10-living-response.md). Available for JSON that isn't too large. |
| `Pretty` | Formatted JSON, XML, or HTML. |
| `Raw` | The exact bytes as received. |
| `Preview` | A rendered view — HTML in a sandboxed frame, images, or PDFs. |

Beacon auto-selects a mode per response: `Preview` for images and PDFs, `Interactive` for JSON under the size limit, otherwise `Pretty`.

**Body tools** (in the Body header, for JSON in Pretty mode unless noted):

- **Filter** — a JSONPath input (for example `$.data[*].id`) that live-filters the body; a bad expression shows `invalid`.
- **Fields** — opens the **Choose Fields** picker, a tri-state checkbox tree for showing only selected JSON paths.
- **Find** — focuses the editor's find (also `⌘F`).
- **Extract** — opens **Extract Values to Environment** (JSON with an active environment), flattening the body into rows you can save as variables.

Other body cases: a **binary** response shows a card with a **Save File** button that downloads it with an inferred extension; an **empty** body shows `No content`; a body over 5 MB shows a `Large body — formatting skipped` pill.

## Other response tabs

- **Headers** — every response header, with a per-row **Copy value** on hover.
- **Cookies** — cookies parsed from `Set-Cookie`, with their attributes.
- **Tests** — the results of your [test scripts](08-scripts-and-tests.md): each assertion pass/fail, plus any variables extracted by the **Vars** rules.
- **Schema** — the result of validating against an [attached JSON Schema](08-scripts-and-tests.md#schema-validation).
- **Redirects** — one card per redirect hop (only when redirects occurred).
- **Timeline** — a breakdown of `Waiting (TTFB)`, `Downloading`, and `Total` (only when timing data exists).

## Diffing responses

Click **Diff** to compare the current response against another. A segmented control picks what to compare against:

- `previous` — the response before this one.
- `baseline` — a response you pinned with **Pin baseline**.
- `environment` — pick another environment from the dropdown; Beacon silently re-sends the request against it and diffs the two.

The diff shows either a **structural JSON diff** (rows labeled `added`, `removed`, `changed` with the path and before → after values) or a **line-based text diff**.

## Saving an example

Click **Save example** (the bookmark) to store the full response as a named example on the saved request. Examples can later be previewed from the request's row in the tree, or turned into a mock route. See [Collections](11-collections.md#examples) and [Mock, WebSocket, and monitors](15-mock-websocket-monitors.md).

> **Note:** **Save example** is disabled until the request itself is saved to a collection.

## Watch: re-send on an interval

The **Watch** control re-sends the current request on a timer and highlights what changed between sends. Click **Watch** to start with the default interval, or open its options (the chevron) to set `Re-send every N s` and choose when to stop automatically — `the response changes` or `a test passes`.

Watch uses live request state on every tick, so refreshed tokens and updated variables are picked up each time. The Interactive tree stays mounted across polls, so your search, expanded rows, and table state survive each re-send. This pairs naturally with the [Pinboard](10-living-response.md#the-pinboard) to chart a value as it changes.

---

**See also:** [Living Response](10-living-response.md) · [Scripts and tests](08-scripts-and-tests.md) · [Variables and environments](07-variables-and-environments.md)

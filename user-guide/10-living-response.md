# Living Response

*The interactive JSON tree and the Pinboard — exploring a response and watching values change across sends.*

**In this chapter**
- [The interactive tree](#the-interactive-tree)
- [Searching the tree](#searching-the-tree)
- [Smart value rendering](#smart-value-rendering)
- [Changes between sends](#changes-between-sends)
- [Chase-reference chips](#chase-reference-chips)
- [Table-scan mode for arrays](#table-scan-mode-for-arrays)
- [Row actions](#row-actions)
- [The Pinboard](#the-pinboard)

The **Interactive** body view (see [Responses](09-responses.md#the-body-tab)) is more than a formatter — it's a live, explorable view of a JSON response that Beacon calls the *Living Response*.

## The interactive tree

The response renders as an indented tree of collapsible rows. Objects show their child count as `{n}`, arrays as `[n]`. Containers deeper than two levels start collapsed so the top of the structure stays readable. Press `Enter` or `Space` on a container row to toggle it.

## Searching the tree

A search box at the top of the tree filters by key **or** value. Press `⌘F` anywhere in the tree to jump to it (this intercepts the editor's own find). Matching containers force-expand so deep matches stay visible. A counter shows `<current>/<total> matches`; the `↑` and `↓` arrow keys step through matches, wrapping around, and scroll the current one into view.

## Smart value rendering

Beacon recognizes common value shapes and annotates them inline:

| Value | Rendered as |
|---|---|
| Epoch or ISO timestamps | the raw value plus `≈` a human-relative time |
| Hex colors | the raw value plus a color swatch chip |
| URLs and image URLs | an underlined blue link |
| Byte sizes | the raw value plus a human-readable size |
| JWTs | the raw value plus a `JWT · decode` button that expands the decoded payload |
| `null` / booleans | dimmed / purple |

## Changes between sends

When you re-send a request, the tree marks what changed from the previous response: a numeric change shows a green or red delta chip (`▲`/`▼`) with the signed difference; a non-numeric change shows a small yellow dot. This makes it easy to see exactly what moved between two sends — especially under [Watch](09-responses.md#watch-re-send-on-an-interval).

## Chase-reference chips

When a value looks like it references another saved request or a URL, an `↗` chip appears next to it. Clicking a request chip opens that saved request in a tab; clicking a URL chip opens a new `GET` tab for that URL. This lets you "chase" IDs and links through your API without copy-pasting.

## Table-scan mode for arrays

Expand an array of objects and a **table** toggle appears. Turn it on to render the array as a scrollable table with a sticky header and one column per object key — far easier to scan than nested rows. A muted summary sits next to the array count, for example `object · amount: 100–9000 · avg 4550`. Table mode is suppressed while a search term is active so matches stay reachable.

## Row actions

Hover a row to reveal its action rail on the right:

- **Copy value** — copies a leaf value to the clipboard.
- **Extract to variable** — opens the Extract modal seeded at that path.
- **Filter to this path** — sets the Pretty-mode JSONPath filter to that path.
- **Pin** — pins the field to the Pinboard and charts how it changes across sends.

## The Pinboard

The Pinboard sits above the response tabs. It always shows two automatic cards — **latency** (`⏱ <n>ms`) and **status** — each with a delta chip versus the previous send.

Pin any field (from a row's **Pin** action) and it gets its own card showing the current value and a delta chip versus the previous body. Once a pinned field has two or more numeric samples in a session, its card draws a sparkline charting the value over time. A **Re-send** button in the footer re-fires the request and updates every card at once.

Pins are saved with the request (`<n> pinned · saved with this request`), so they persist. Combined with [Watch](09-responses.md#watch-re-send-on-an-interval), the Pinboard turns a single endpoint into a small live dashboard.

---

**See also:** [Responses](09-responses.md) · [Variables and environments](07-variables-and-environments.md) · [Scripts and tests](08-scripts-and-tests.md)

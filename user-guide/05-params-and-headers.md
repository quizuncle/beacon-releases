# Params and headers

*Query parameters, path variables, and request headers — and how the key-value editor works.*

**In this chapter**
- [Query params](#query-params)
- [Path variables](#path-variables)
- [Headers](#headers)
- [The key-value editor](#the-key-value-editor)

## Query params

The **Params** tab holds the request's query string. Its rows stay in sync with the `?key=value` pairs in the URL — edit either and the other updates. Each row has an enable checkbox, a **Parameter** (key) field, a **Value** field, a **Description** field (unique to params), and a delete button. Keys and values support `{{variables}}`, shown as accent pills.

## Path variables

When your URL contains a `:name` segment — for example `https://api.example.com/users/:id` — a **Path Variables** section appears in the **Params** tab. Beacon detects each `:name` token (only after a `/`, so schemes and `host:port` are never mistaken for path variables) and lists it with an editable value field. These rows are derived from the URL, so they have no enable checkbox and no delete button.

At send time, each `:name` is replaced with its URL-encoded value. Values themselves are interpolated, so `{{variables}}` work here too.

> **Note:** If you leave a path variable's value empty, Beacon sends the literal `:name` in the URL rather than guessing. This is a deliberate loud failure — a broken-looking URL tells you at a glance that a value is missing.

## Headers

The **Headers** tab is a key-value editor with an enable checkbox, a **Header** (key) field, a **Value** field, and a delete button. Keys and values support `{{variables}}`.

Clearing a row's checkbox **keeps the header in the list but omits it from the request** — the row dims to show it won't be sent. This lets you toggle a header off without losing it.

> **Note:** Beacon adds some headers automatically at send time and does not show them in this list: `Content-Type` (derived from the body type) and `Authorization` (derived from the [Authorization](06-authorization.md) tab). Setting your own header of the same name overrides the automatic one.

## The key-value editor

The Params, Headers, form-data, and urlencoded panels all use the same key-value editor:

- A header row of column labels appears once at least one row exists.
- Each row highlights on hover; disabled rows are dimmed.
- The **+ Add** button at the bottom adds a blank row.
- The delete (trash) button removes a row and turns red on hover.

> **Note:** These panels edit one row at a time. There is no bulk / raw-text edit mode in the request panels — that lives only in the collection-wide [Find & Replace](11-collections.md#find-and-replace) tool.

---

**See also:** [Request body](04-request-body.md) · [Authorization](06-authorization.md) · [Variables and environments](07-variables-and-environments.md)

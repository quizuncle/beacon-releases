# History and cookies

*Every request you've sent, and the cookie jar that captures and replays cookies automatically.*

**In this chapter**
- [History](#history)
- [The cookie jar](#the-cookie-jar)

## History

Open the **History** panel from the Activity Rail (`⌘2`). It lists every request you've sent, newest first, grouped by day under sticky date headers. Each entry shows the method, the URL, and the response status.

- **Restore** — click an entry to reopen that request in a tab, ready to send again.
- **Search** — the `Search history…` box filters by method and URL.
- **Clear** — the trash button clears all history (with a confirmation).

> **Note:** History is stored locally and is **not** part of [Cloud Sync](16-cloud-accounts.md) — it stays on the device where the requests were sent.

## The cookie jar

Beacon keeps a per-domain cookie jar and uses it automatically:

- **Auto-capture** — every `Set-Cookie` header in a response (from a normal send or the [runner](12-collection-runner.md)) is parsed and stored under its domain.
- **Auto-attach** — stored cookies for a request's domain are sent as a `Cookie` header automatically.

Both behaviors are gated by the **Send Cookies** setting (see [Settings](18-settings.md)); turning it off stops capture and attachment.

> **Note:** [Load test](14-load-testing.md) responses deliberately do **not** persist cookies, to keep high-volume runs from flooding the jar.

**Managing cookies.** Open the **Cookies** view (the cookie icon on the Activity Rail) for the Cookie Jar. Cookies are grouped by domain, each group showing a count and a clear button. Columns show **Domain**, **Name**, **Value**, **Path**, and **Expires / Flags** (`HTTP` for httpOnly, `Sec` for secure, plus the expiry date; a red `Expired` when past).

- **Filter** — the `Filter by domain…` box narrows the list.
- **Add** — **Add Cookie** creates a cookie manually.
- **Edit** — double-click any row to edit it inline (domain, name, value, path, expiry, and the HTTP/Sec checkboxes).
- **Clear** — a per-domain trash button, or **Clear All** for everything.

---

**See also:** [Settings](18-settings.md) · [Cloud accounts](16-cloud-accounts.md) · [Sending requests](03-sending-requests.md)

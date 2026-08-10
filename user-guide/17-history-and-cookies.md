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

A group heading is the domain with its leading dot removed and lowercased, so a cookie stored on `.example.com` and one stored on `example.com` share a single `example.com` heading. The **Domain** column still shows each cookie's own stored domain. Domains are matched case-insensitively throughout, so a cookie whose domain was typed or pasted as `.Example.COM` is sent with requests to `example.com` and its subdomains just like the lowercase spelling.

- **Filter** — the `Filter by domain…` box narrows the list.
- **Add** — **Add Cookie** creates a cookie manually. A domain that is nothing but dots is rejected.
- **Edit** — double-click any row to edit it inline (domain, name, value, path, expiry, and the HTTP/Sec checkboxes).
- **Clear** — a per-domain trash button, or **Clear All** for everything. Both ask you to confirm.

**What a per-domain clear removes.** The trash button on a group heading removes **every cookie a request to that host would send** — which is not always the same as the rows filed under the heading you clicked. A cookie stored with a leading dot (`.example.com`) covers that domain *and* every subdomain of it, so it is sent to `api.example.com` — and clearing `api.example.com` therefore takes it too. Clearing means clearing: nothing that would still be sent to the host is left behind.

Say the jar holds cookies on `.example.com`, `api.example.com`, `www.example.com`, `example.com`, and `notexample.com`. Clearing `api.example.com`:

- **removes** `api.example.com`'s own cookies, plus the shared `.example.com` cookies
- **keeps** `www.example.com`'s own cookies, `example.com`'s own cookies (those without a leading dot), and `notexample.com` — label boundaries are respected, so `notexample.com` is never treated as part of `example.com`

Clearing never widens *downward*. Clearing `example.com` leaves `api.example.com`'s own cookies untouched, because a request to `example.com` never receives them.

> **Warning:** Because dotted parent-domain cookies are shared, clearing one subdomain can sign you out of its siblings. In the example above, `www.example.com` loses the shared `.example.com` session cookie even though you cleared `api.example.com`. Cookies never leave your machine — they are excluded from [Cloud Sync](16-cloud-accounts.md) — and the jar has no undo, so a clear is final. Read the confirmation before confirming.

**The confirmation.** The dialog names what is about to go before anything happens. Its title is **Clear cookies for `api.example.com`?** and its body lists the affected cookies grouped by heading, with the group you clicked first — for the example above: *"Removes 2 cookies that a request to api.example.com would send — api.example.com: apitok; example.com: sso. example.com is a shared parent-domain group — sibling subdomains using those cookies will be signed out too. This can't be undone."* Any group named after the first one is a group you are about to affect indirectly. Beyond a dozen cookies the body switches to per-group counts instead of names. Choose **Clear cookies** to go ahead or **Cancel** to back out. If nothing matches the host, no dialog appears and the list simply refreshes.

**Clear All** confirms separately, with **Clear all cookies?** and *"Every stored cookie will be removed. This can't be undone."* Emptying the whole jar is only ever what **Clear All** does — a per-domain clear can no longer wipe everything, even for an unnamed group.

---

**See also:** [Settings](18-settings.md) · [Cloud accounts](16-cloud-accounts.md) · [Sending requests](03-sending-requests.md)

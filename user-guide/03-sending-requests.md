# Sending Requests

*Compose and fire an HTTP request from the Omnibox — the single URL bar that also imports curl, runs commands, and searches your work.*

**In this chapter**

- [The method selector](#the-method-selector)
- [The URL input](#the-url-input)
- [Omnibox modes](#omnibox-modes)
- [Importing a curl command](#importing-a-curl-command)
- [Sending, cancelling, saving](#sending-cancelling-saving)
- [The request panel tab strip](#the-request-panel-tab-strip)
- [Generating code snippets](#generating-code-snippets)

> On Windows and Linux, `⌘` means `Ctrl` throughout this chapter.

## The method selector

At the left of the request bar sits the method selector — a text button showing the current HTTP method (color-coded) and a chevron. Click it to pick a different method. Its tooltip reads `HTTP method for this request — changes how the body and cache behave.`

| Method | Color |
|---|---|
| `GET` | green |
| `POST` | amber |
| `PUT` | blue |
| `PATCH` | purple |
| `DELETE` | red |
| `HEAD` | teal |
| `OPTIONS` | grey |

## The URL input

The URL field is variable-aware. Its placeholder reads `Enter URL, type > for commands, or search…`.

- Any `{{variable}}` you type renders as a colored accent pill inline.
- When the request's interpolated and path-substituted URL differs from what you typed, a second line prefixed with `↳` appears below the field, showing the exact final URL that will be sent. Use it to confirm your variables and path parameters resolved the way you expected.

See [Variables & Environments](07-variables-and-environments.md) for how `{{...}}` tokens are resolved, and [Params & Headers](05-params-and-headers.md) for `:name` path variables.

## Omnibox modes

The URL field classifies what you type and behaves accordingly. You never switch modes manually — Beacon detects them:

| Mode | Triggered by | What it does |
|---|---|---|
| URL | `scheme://`, `localhost[:port]`, `domain.tld[:port]`, `host:port`, or a leading `/` | Treats the text as the request URL |
| Method-prefix | typing e.g. `post foo.com` | Sets the method to `POST` and strips the prefix when you send |
| curl | text starting with `curl ` | Imports the command as a request (see below) |
| Command | a leading `>` | Opens the command palette |
| Variable | an open `{{` under the caret | Suggests matching variables |
| Search | free, non-URL text | Searches your saved requests and history |

### The dropdown

Command, search, and variable modes open a dropdown below the field. Navigate it with the arrow keys, run the highlighted row with `Tab` or `Enter`, and dismiss with `Esc`.

- **Command palette rows:** `New Tab (⌘T)`, `Switch to Light/Dark Theme`, `Toggle Layout (Side-by-side / Stacked)`, `Open Collections`, `Open History`, `Open Environments`.
- **Search rows:** matching saved requests (name + collection + method badge) plus your last 30 history entries (URL + method), up to 8 rows.
- **Variable rows:** matching enabled variables from the environment, collection, or globals — each row shows `{{key}}` and a `source · value` line, up to 8 rows.

## Importing a curl command

Paste anything beginning with `curl ` into the URL field and Beacon imports it immediately as a request. (The paste is read from the clipboard event, so embedded newlines survive.) While in curl mode the Send button relabels to `Import`, with the tooltip `Import this curl command as a request.`

The parser handles:

- `-X` / `--request` — the method
- `-H` / `--header` — headers
- `-d` / `--data` / `--data-raw` / `--data-binary` — the body
- `-F` / `--form` — multipart form fields (forces `POST`)
- `-u` / `--user` — becomes an `Authorization: Basic` header (base64-encoded)

It respects single, double, and ANSI-C `$'...'` quoting, and skips value-consuming flags it doesn't use (`--connect-timeout`, `-A`, `-b`, `-x`). Query params in the URL are split out into the Params list, the body type is auto-detected from the `Content-Type` or by attempting `JSON.parse` (falling back to raw), and path parameters are synced.

## Sending, cancelling, saving

Two icon buttons sit between the URL field and the Send button:

- **Save** (disk icon) — `Save this request into a collection. ⌘S.` See [Collections](11-collections.md).
- **Code** (`<>` icon) — `Generate code for this request in another language/tool.` Opens the Code Snippet modal (below).

The **Send** button shows a paper-plane icon and the label `Send`, tooltip `Send this request. ⌘↵.` Pressing `Enter` in the URL field also sends.

- **While a request is in flight,** the button becomes a red `Cancel` button with an animated beam. Click it to abort the request.
- **In curl mode,** the button reads `Import` instead of `Send`.

> **Note:** There is no send-and-watch or polling control in this bar. Repeated/watched sends live on the response side (see [Living Response](10-living-response.md)).

## The request panel tab strip

Below the URL bar, the request is edited across six panels:

| Panel | Badge |
|---|---|
| `Params` | numeric badge counting enabled rows with a non-empty key |
| `Headers` | numeric badge counting enabled rows with a non-empty key |
| `Auth` | green dot when auth is active (not `No Auth`/`Inherit`-to-none) |
| `Body` | green dot when a body is set, plus a formatted byte-size pill |
| `Scripts` | — |
| `Docs` | blue dot when a description exists |

Each panel is covered in its own chapter: [Params & Headers](05-params-and-headers.md), [Authorization](06-authorization.md), [Request Body](04-request-body.md), and [Scripts & Tests](08-scripts-and-tests.md).

## Generating code snippets

Click the **Code** button to open the `Code Snippet` modal. Pick a target language along the top and copy the result with the Copy button (which briefly shows `Copied!` for 2 seconds).

Ten targets are available:

| | | |
|---|---|---|
| `cURL` | `HTTPie` | `JS (fetch)` |
| `Node (axios)` | `Python` | `Go` |
| `Ruby` | `PHP` | `C#` |
| `Java` | | |

> **Note:** Snippets are generated from the **fully-resolved** request, so the code matches a real send. `{{variables}}` are interpolated (environment > collection > global), `:pathParams` are substituted, and the effective auth and headers are resolved through the folder → collection inheritance chain. The output never leaks `{{tokens}}` and never drops an inherited or OAuth `Authorization` header. GraphQL bodies are emitted as `{query, variables}` JSON with the right `Content-Type`.

---

**See also:** [Request Body](04-request-body.md) · [Params & Headers](05-params-and-headers.md) · [Authorization](06-authorization.md) · [Collections](11-collections.md)

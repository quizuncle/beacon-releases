# Request body

*The seven body types, the JSON editor's conveniences, and the GraphQL schema explorer.*

**In this chapter**
- [Choosing a body type](#choosing-a-body-type)
- [JSON](#json)
- [GraphQL](#graphql)
- [form-data](#form-data)
- [urlencoded](#urlencoded)
- [raw](#raw)
- [binary](#binary)
- [Automatic body-type detection](#automatic-body-type-detection)

Open the **Body** tab in the request panel. A segmented selector picks the body format: `none`, `JSON`, `GraphQL`, `form-data`, `urlencoded`, `raw`, or `binary`. The selector's help tip notes that the choice *switches the editor and the `Content-Type` header sent*. When a body is present, the **Body** tab shows a green dot and a small byte-size pill.

## JSON

A Monaco code editor with JSON syntax. Beacon's JSON editor is deliberately lenient:

- **Comments are allowed.** You can write `//` line comments and `/* */` block comments to annotate or temporarily disable fields.
- **Trailing commas are tolerated** — they won't flag as errors.

> **Note:** Comments are stripped before the request is sent, so the server receives clean JSON. Beacon also adds `Content-Type: application/json` automatically if you haven't set one.

Click **Format** (the wand icon, top-right) to pretty-print the body. If the JSON is invalid, the button shakes and briefly shows `Invalid JSON` in red.

## GraphQL

The GraphQL body is a split view: a **Query** editor on the left, a **Variables (JSON)** editor below it, and a **Schema** explorer on the right.

To explore a schema, click **Fetch schema**. Beacon runs a standard introspection query against the request's URL and lists the schema's types. Expand a type to see its fields; click a field name to insert it at the cursor in the query editor.

GraphQL requests are sent as a single JSON `POST` with a `{query, variables}` body and `Content-Type: application/json`. If the variables editor contains invalid JSON, the send is blocked with an error.

## form-data

A key-value editor that builds a `multipart/form-data` body. Each row has a **Type** toggle:

- **Text** (the `T` icon) — a plain text field. Key and value support `{{variables}}`.
- **File** (the document icon) — a **Choose File** button opens a native file picker; the chosen filename is shown (or `No file chosen`).

Files are attached as real multipart parts when the request is sent.

## urlencoded

A key-value editor that builds an `application/x-www-form-urlencoded` body. Beacon adds that `Content-Type` if you haven't set one. Keys and values support `{{variables}}`.

## raw

A plain-text Monaco editor. The contents are sent exactly as typed, with whatever `Content-Type` you set yourself in the [Headers](05-params-and-headers.md) tab. Use this for XML, plain text, or any format Beacon doesn't have a dedicated editor for.

## binary

Attaches a single file as the raw request body. Click **Choose File** (or **Change File**) to pick a file; a card shows its name and `Ready to send`, with an **×** to clear it.

## Automatic body-type detection

The first time you open a tab whose body type is `none` or `raw` but already has content, Beacon tries to detect the format: it strips comments and attempts to parse the content as JSON. If that succeeds, the type switches to `JSON`. This runs at most once per tab and never overrides a type you chose yourself.

---

**See also:** [Sending requests](03-sending-requests.md) · [Params and headers](05-params-and-headers.md) · [Variables and environments](07-variables-and-environments.md)

# Importing OpenAPI specs

*Turn an OpenAPI or Swagger spec into a collection, keep it up to date as the spec changes, and let an AI assistant find and call its operations.*

**In this chapter**
- [Importing a spec](#importing-a-spec)
- [What gets created](#what-gets-created)
- [Re-syncing](#re-syncing)
- [Badges](#badges)
- [Limits](#limits)

## Importing a spec

1. In the Collections panel, choose **Import** and pick **OpenAPI Spec** (`Import from a URL or an OpenAPI/Swagger file`).
2. In the **Import OpenAPI** dialog, pick **URL** and enter the spec address (for example `https://api.example.com/v3/api-docs`), or pick **File** and choose a JSON or YAML file.
3. Choose **Collection auth**:

| Choice | Effect |
|---|---|
| **From the spec** | Detected from the spec's security schemes. |
| **None** | No auth on the collection. |
| **Bearer** | `Authorization: Bearer {{token}}`. |
| **API key header** | The header name you give, set to `{{apiKey}}`. |

Both OpenAPI 3.x and Swagger 2.0 work. URLs must be `https://`; plain `http://` is accepted only for `localhost`, `127.0.0.1` and `[::1]`. Redirects are followed up to five times, each one checked again, and a spec larger than 20 MB is refused. The URL is fetched **without credentials** — to import a spec that sits behind authentication, download it and import the file.

## What gets created

- **One collection per spec**, named after the spec's title.
- **A folder per first tag** on each operation.
- A **`baseUrl` collection variable** taken from the spec's servers; every request URL starts with `{{baseUrl}}`.
- **One request per operation**, named after its summary (or its operation id when there is no summary). Path parameters become `:name` segments, and a JSON example body is built from the request schema. Fields the spec marks `readOnly` (values the server sets, like ids or timestamps) are left out of the example. If a server-set field still shows up, the spec doesn't mark it — in Spring Boot that's `@Schema(accessMode = Schema.AccessMode.READ_ONLY)` or `@JsonProperty(access = JsonProperty.Access.READ_ONLY)` on the field.
- The operation's **response schema** is stored in the request's `Schema` field when that field is empty, so the AI can see what comes back.

Very deep or circular `$ref` schemas are cut off rather than expanded forever.

## Re-syncing

Right-click an imported collection and choose **Re-sync from spec**. Beacon re-reads the same URL (or asks you for the file again) and compares each operation by its operation id. A file must have the same title as the original.

| What happened to the operation | What Beacon does |
|---|---|
| The spec is byte-for-byte unchanged | Nothing, except that a **spec changed** badge clears on any request you have since brought in line (see [Badges](#badges)); reports `Spec unchanged`. |
| New in the spec | A new request is created, in the folder of an existing request with the same tag, else in a folder named after the tag. |
| Changed, and you haven't edited the request | Method, URL, params, path params, headers, body and description are updated. Your name, auth, scripts, assertions, post-response steps, star, folder and sort order are kept; the schema is filled in only if empty. |
| Changed, and you have edited the request | Left exactly as it is and marked **spec changed**. |
| Only the summary, tag, description or response schema changed | The request's search text and spec details are refreshed; its schema is filled in only if empty and you haven't edited the request. Nothing else changes, and an existing badge stays. |
| Removed from the spec | Kept, and marked **removed from spec**. |
| You deleted the request earlier | Never brought back. |
| You added the request by hand | Never touched. |

A failed re-sync (unreachable URL, unreadable file, wrong title) leaves everything as it was and records the error against the spec. This includes a re-sync an AI assistant starts with `beacon_import_openapi`.

An AI assistant importing with `beacon_import_openapi` puts the collection in the workspace you have open unless it names another one. Its `beacon_get_history` filters look at only the newest 200 history entries.

## Badges

In the sidebar, a request shows a small **spec changed** or **removed from spec** badge until you deal with it; hover it for an explanation. Review the request, copy over what you want, then edit or delete it as usual.

A **spec changed** badge clears at the next re-sync (whether or not the spec has changed again) once the request's method, URL, params, path params, headers, JSON body and description match exactly what the current spec would generate. Blank rows, surrounding spaces and JSON formatting are ignored in that comparison; your name, auth, scripts, assertions and other fields are not part of it. From then on, the request is treated as unedited and updates with the spec again. A **removed from spec** badge clears if the operation comes back to the spec.

## Limits

- Specs are fetched without authentication.

## AI read-only environments

An environment can be marked **AI read-only** (checkbox in the environment editor). While it is on, an AI assistant using that environment may only send `GET`, `HEAD` and `OPTIONS`; any other method is refused before it is sent, including inside AI-started collection and flow runs. It is **on by default for environments whose name contains `prod`** (any case), and you can switch it off or turn it on for any other environment.

What it doesn't cover: requests made by scripts running inside a request, an AI client pointing a non-read-only environment's variables at another host, and anything you send yourself in the app.

---

**See also:** [MCP / AI access](21-mcp-ai-access.md) · [Collections](11-collections.md) · [Variables and environments](07-variables-and-environments.md)

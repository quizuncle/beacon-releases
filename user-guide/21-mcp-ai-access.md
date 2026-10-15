# MCP / AI access

*Letting a local AI assistant read your collections and send requests through Beacon's own engine — what it can do, what's redacted, and running headless.*

**In this chapter**
- [What it is](#what-it-is)
- [Turning it on](#turning-it-on)
- [Connecting an AI client](#connecting-an-ai-client)
- [What an AI client can and cannot do](#what-an-ai-client-can-and-cannot-do)
- [Finding and calling operations](#finding-and-calling-operations)
- [beacon_call with data](#beacon_call-with-data)
- [Read-only environments](#read-only-environments)
- [The redaction promise](#the-redaction-promise)
- [Headless and CI use](#headless-and-ci-use)
- [Troubleshooting](#troubleshooting)

## What it is

**MCP / AI access** opens a local connection that lets an [MCP](https://modelcontextprotocol.io)-capable AI assistant — Claude Desktop, or anything else that speaks the Model Context Protocol — read your Beacon collections, environments, and history, and send requests or run collections and flows on your behalf, using the exact same execution engine the app's own UI does.

It only ever works against data already on this device — the same collections, environments, and history this copy of Beacon already has. Nothing is fetched from anywhere else because you turned this on, and nothing about your requests, responses, or credentials leaves your machine through it. It is **off by default**.

## Turning it on

1. Open **Settings** (`⌘6`) and select the **MCP / AI access** tab.
2. Flip **Allow AI clients to control Beacon** on.

Like the Privacy tab's usage-data switch, this one applies the moment you flip it — there's no need to click **Save**.

**Status** underneath reads `Running` with the socket it's listening on, or `Off` / `Not running.` while access is disabled. If turning it on fails — for example, another running copy of Beacon already owns the connection — the error appears right there under the toggle instead of failing silently.

## Connecting an AI client

On a packaged build, a **MCP client config** block appears here with a **Copy** button whether or not the toggle above is on — so you can get your AI client's config file set up before you ever flip access on. It's built from this exact install — the real path to the Beacon binary on this machine, not a placeholder — so it's meant to be copied straight into your AI client's configuration rather than edited by hand. It looks like this (with this machine's own paths filled in):

```json
{
  "mcpServers": {
    "beacon": {
      "command": "/Applications/Beacon.app/Contents/MacOS/Beacon",
      "args": ["/Applications/Beacon.app/Contents/Resources/beacon-mcp.js"],
      "env": {
        "ELECTRON_RUN_AS_NODE": "1",
        "BEACON_CONTROL_DIR": "/Users/you/Library/Application Support/Beacon/control"
      }
    }
  }
}
```

Paste it into your MCP client's own config — for example Claude Desktop's `claude_desktop_config.json`. `command` and `args` launch this same Beacon install as a plain Node process running the small adapter bundled inside the app (`ELECTRON_RUN_AS_NODE`), rather than opening a second window; `BEACON_CONTROL_DIR` points it at this install's own connection so a pasted config keeps working even for a portable install or a non-default profile.

Pasting the config is not the same as turning access on: the block renders as soon as Beacon can resolve its own install paths, regardless of the toggle in [Turning it on](#turning-it-on). An AI client can only actually connect once that toggle is flipped on — until then it gets the same unreachable result as if Beacon weren't running at all (see [Troubleshooting](#troubleshooting)).

> **Note:** In a development build (running from a source checkout rather than an installed app), there is no bundled adapter to point at. The tab shows a hint to run one from a `beacon-mcp` checkout with Node instead of a config block.

## What an AI client can and cannot do

Sixteen tools, all prefixed `beacon_`. Eleven only read; four send, call or run something; one imports a spec.

| Tool | What it does |
|---|---|
| `beacon_status` | Reports whether Beacon is reachable, its version, and whether a run is already in progress. |
| `beacon_list_collections` | Lists your collections, folders, and requests — names, methods, and URL templates. |
| `beacon_get_request` | Reads one saved request's full definition: params, headers, body, scripts, and its auth type. |
| `beacon_list_environments` | Lists your environments and global variables. Secret-flagged values are masked, but marked so the model knows the variable exists and can still be used. |
| `beacon_get_history` | Reads recent history entries, redacted, most recent first. |
| `beacon_list_monitors` | Lists your configured monitors. |
| `beacon_get_monitor_runs` | Reads a monitor's stored run results. |
| `beacon_list_flows` | Lists your [flows](13-flows.md) — name and a node count, never the definition itself. |
| `beacon_search` | Searches your collections, folders, requests, flows and environment names for an operation or request. |
| `beacon_describe_request` | Shows one request or operation in detail — parameters, body, schema — with secrets masked. |
| `beacon_list_specs` | Lists the OpenAPI specs you've imported. |
| `beacon_call` | Calls one saved request or imported operation by exact id, with optional overrides. |
| `beacon_import_openapi` | Imports a spec from a URL, or re-syncs an imported one by its spec id. |
| `beacon_send_request` | Sends a saved or ad-hoc request and returns the redacted response. |
| `beacon_run_collection` | Runs a collection — the same engine the [Collection runner](12-collection-runner.md) uses — and returns a redacted run report. |
| `beacon_run_flow` | Runs a [flow](13-flows.md), by id or by name, and returns a redacted flow report. |

**There is nothing else.** The only thing a tool creates is what `beacon_import_openapi` imports. No tool edits, renames, or deletes a request, collection, environment, or anything else — and a re-sync never overwrites a request you have edited (see [Importing OpenAPI specs](22-openapi-import.md#re-syncing)).

Sends can run concurrently, but collection and flow runs share a single slot: starting a second one while one is already in flight gets a `busy` result naming the run that's already going, rather than queueing it silently.

**You can see it happening.** An AI-driven send lands in [History](17-history-and-cookies.md) like any request of your own, marked with a small **AI** chip; if the History panel isn't open when one arrives, a dot appears on its Activity Rail icon and stays until you open the panel. And while an AI client is connected at all, the status bar at the bottom of the window shows **AI connected**. All three are passive markers — Beacon never switches panels or steals focus because an AI did something.

A flow run is visible too, but only if you already have that flow's own tab open: nodes light up as they execute — including a failure — the same way they would for a run you started yourself, plus a "Run by AI client" line in the run log. Like the markers above, this never opens the tab or switches you to it; it only renders while you're already looking at that flow.

## Finding and calling operations

The intended flow is **search, describe, call**.

1. `beacon_search` with `query: "vaccination records"` returns ranked matches. Names are split into words (`getVaccinationRecords`, `/pets/{petId}`), so a request with no summary is still found. An empty query lists your collections. Environment *names* and variable *keys* are searchable; values never are.
2. `beacon_describe_request` with `operationId: "getPet"` returns the parameters, example body and response schema. Output is secret-scrubbed and kept small.
3. `beacon_call` sends it:

```json
{
  "operationId": "getPet",
  "environment": "staging",
  "pathParams": { "petId": "42" },
  "fields": ["name", "owner.id"],
  "expect": { "status": 200, "body.name": "!=null" }
}
```

`beacon_call` takes an exact `requestId` or an `operationId` (add `specId` if the same operation id exists in two specs). It can override `pathParams`, `query`, `headers` and `body`; credential headers such as `Authorization` are refused — keep tokens in an environment secret variable. `fields` returns only the listed body paths (`["items[].id"]` style), and `maxBytes` (256 to 262,144, default 16,384) caps the body. `expect` is a list of up to 50 checks on `status` and body paths: exact values, `">0"`, `">=2"`, `"!=null"`, and `"~text"` for *contains*. The result carries the pass or fail of each check. `beacon_send_request` accepts `fields`, `maxBytes` and `expect` as well.

`beacon_import_openapi` with `{ "url": "https://api.example.com/v3/api-docs", "auth": "auto" }` imports a spec into the workspace Beacon currently has open (pass `workspaceId` to choose another; an unknown one is refused); `{ "specId": "..." }` re-syncs one, and a failed re-sync is recorded against the spec. A spec imported from a file must be re-synced from the app. `beacon_call` only sends requests in the open workspace; for one found in another workspace it tells you to switch Beacon to that workspace first. `beacon_get_history` returns compact entries and can filter by `origin`, `minStatus`, `urlContains` and `since`; the filters scan only the newest 200 stored history entries.

## beacon_call with data

Add `data` to `beacon_call` to send one saved request once per row of a file or list, in one call. It is the AI version of [Run with data](23-run-with-data.md), with the same `{{column}}` substitution and `pm.iterationData`.

| Input | Meaning |
|---|---|
| `data` | Exactly one of `{ "path": "/abs/rows.csv" }` or `{ "rows": [ {...} ] }`. A path is absolute, a regular file (not a symlink), up to 5 MB, ending `.csv` or `.json`. `rows` is a non-empty array of flat objects. |
| `concurrency` | Rows in flight at once, 1 to 10. Default 1. |
| `delayMs` | Pause before each worker's next row, 0 to 60,000. Default 0. |
| `stopOnFailure` | Send no new rows after a failure. Default false. |
| `failOn` | `"status"` (default) or `"tests"`. |
| `startRow` | First row to run, 1-based. Earlier rows are skipped; row numbers stay the original ones. |
| `resultsPath` | Optional absolute path ending `.csv`, in a folder that exists. The file is created, never overwritten; one that already exists is refused. It lists every row of the file; rows before `startRow` and rows that did not run say `not run`. |
| `maxMs` | Time limit for the whole run. Default 600,000, maximum 1,800,000 (a single call without `data`: default 300,000, maximum 600,000). It must be larger than `timeoutMs`: no new row starts within `timeoutMs` of the limit, so a row in flight can finish in time. |

`pathParams`, `query`, `headers`, `body`, `fields` and `expect` still apply to every row, and `{{column}}` is substituted in them too, except in header names: a header name with `{{` is refused (`header names may not contain {{variables}}`), in single calls too. `expect` is checked against the full response body.

A call runs at most 1,000 rows (counted after `startRow`); more is refused before anything is sent. Everything is checked before the first row goes out: the arguments, then the read-only rule, then whether another run is in flight (`busy`). A refusal sends nothing.

The result is a summary, not every row:

```json
{
  "summary": { "total": 300, "run": 300, "passed": 293, "failed": 7, "notRun": 0,
               "statusCounts": { "200": 293, "409": 6, "500": 1 }, "durationMs": 24810,
               "stopped": null, "nextRow": null },
  "failed": [ { "row": 3, "values": { "erpOrderId": "ERP-104250" }, "status": 409,
                "error": null, "fields": { "message": "Order already shipped" }, "expect": null } ],
  "failedOmitted": 0,
  "passedRows": "1-2,4-300",
  "resultsPath": "/abs/path.results.csv"
}
```

`stopped` is `null`, `"user"`, `"failure"`, `"time_limit"` or `"disconnected"`. When it is set, `nextRow` is the first row that did not run: call again with `startRow` set to it to resume. The `failed` list is cut at 64 KB; the rows left out are counted in `failedOmitted`. If the results file cannot be written, the run is kept and the result has `resultsPath: null` and a `resultsError`.

**Read-only.** The [read-only rule](#read-only-environments) is checked once, before the first row. A `POST` on an AI read-only environment, such as `prod`, is refused with `read_only_env` and nothing is sent. To let an AI client run bulk `POST` requests, turn off **AI read-only** for that environment in the environment editor; the same call then goes through.

**History and the status bar.** Each row that got a response adds one History entry marked as AI, written as the row finishes. A row that failed before a response (an `error` with no status) adds none. While the run goes, the status bar shows `AI run · done/total` with a `Stop` button; Stop ends the run as `user` and in-flight rows finish.

## Read-only environments

An environment marked **AI read-only** only allows `GET`, `HEAD` and `OPTIONS` from an AI client — in `beacon_call`, `beacon_send_request`, and collection and flow runs. A blocked call fails with a message starting `read_only_env:` and nothing is sent. Environments whose name contains `prod` are read-only by default; change it with the **AI read-only** checkbox in the environment editor. Method-override headers (`X-HTTP-Method-Override` and similar) are refused too. It does not inspect requests made by scripts, and it doesn't stop an AI client from pointing a non-read-only environment at another host through variable overrides. See [Importing OpenAPI specs](22-openapi-import.md#ai-read-only-environments).

## The redaction promise

Everything an AI client reads back over this connection is redacted first, the same masking Beacon's own [run reports](12-collection-runner.md#what-is-masked) apply:

- **Credential headers** — `Authorization`, `Cookie`, `X-Api-Key`, and the rest of the known set — lose their value.
- **Your API key's own header or query parameter** is blanked too, even under a name you invented, and a `user:password@` in a URL is stripped.
- **Every value you marked secret** — in an environment, your globals, or a collection — comes back masked wherever it turns up: in a definition, in history, or in a run report.
- Reading a request or environment definition shows its **shape** without the secret: which header carries a token, that `{{TOKEN}}` is unresolved and usable — never the value it stands for.

**Known limits, stated rather than left silent:**

- A secret shorter than four characters isn't scrubbed — masking every stray short string would hide nothing real while making history unreadable.
- A Basic auth username is never masked, the same as everywhere else in Beacon.
- A value the AI supplies itself in an ad-hoc request — typed straight into a header, body, or param rather than resolved from a variable — comes back unmasked. It's already known to whoever sent it, so redacting it would be theater; it only gets scrubbed if it happens to collide with a value you've separately marked secret.
- A history entry's query-parameter (**Params**) rows, and a saved request's script text, aren't scanned for a credential typed directly into them instead of through a variable — only headers, URLs, and response bodies get that treatment.
- A send or run made by an AI client doesn't inherit this machine's proxy configuration or an "SSL verification off" toggle — it behaves like a fresh `beacon run` of an exported bundle, not like whatever [Settings](18-settings.md) happens to hold. A request that only works from the app's own UI against a self-signed certificate or a proxy-only endpoint can still fail, safely, over this connection.

## Headless and CI use

Beacon doesn't have to be open for some of these tools to work. If the AI client's environment sets `BEACON_BUNDLE` to a bundle file exported from Beacon (see [Command line and CI → Exporting a bundle to run](20-cli.md#exporting-a-bundle-to-run)), and can reach the `beacon` command — on its `PATH`, or via `BEACON_CLI` — the connection falls back to reading and running that file with the CLI instead of reporting Beacon unreachable. **The running app always wins when it's there**: every call tries the live connection first, and every result says which one answered.

| Works without the app running | Needs the app running |
|---|---|
| `beacon_status` | `beacon_send_request` |
| `beacon_list_collections` | `beacon_get_history` |
| `beacon_get_request` | `beacon_list_monitors` |
| `beacon_list_environments` | `beacon_get_monitor_runs` |
| `beacon_list_flows` | |
| `beacon_run_collection` | |
| `beacon_run_flow` | `beacon_search`, `beacon_describe_request`, `beacon_list_specs` |
| | `beacon_call`, `beacon_import_openapi` |

A few differences worth knowing about while running this way:

- `beacon_get_request` returns only the id, name, folder, method, and URL headless — no headers, body, scripts, or auth type — because that's all the exported bundle's own inventory carries.
- `beacon_list_flows` returns only a flow's name and node count headless — no id, and no last-updated time — because that's all an exported bundle's own inventory carries for a flow.
- `beacon_run_flow`'s `flowId` argument works differently in each mode. Live mode matches it against a flow's id first, then — as a fallback — against a flow's **name**, as long as that name is unique; a name shared by more than one flow is rejected rather than guessed at. Headless mode has no id to fall back from at all: bundle files carry no flow ids, so there `flowId` IS the flow's name, always — pass a live flow's id while running headless and it comes back `not_found`.
- `bodyCapBytes` and `maxMs` on `beacon_run_collection`/`beacon_run_flow` both work headless too, even though the `beacon` CLI's `run` command has no flag for either one: `maxMs` (default 300000) is enforced by the adapter itself, which kills the CLI process if it's still running once the budget elapses and reports a structured timeout naming it; `bodyCapBytes` (default 65536 bytes) is applied by the adapter after the fact, to the report the CLI hands back, the same way a live run's cap is applied.
- Headless runs have no single-run-slot guard: two overlapping `beacon_run_collection`/`beacon_run_flow` calls each shell out to their own run independently, rather than the second one being turned away with `busy`.

## Troubleshooting

**Nothing happens, or the AI client reports Beacon unreachable.** Beacon not running and access turned off look identical from the AI client's side — both mean there's no connection to answer. Open **Settings → MCP / AI access** and check that the toggle is on and **Status** reads `Running`.

**A connection that worked yesterday fails right after restarting Beacon.** Beacon writes a fresh access token every time it starts. The bundled adapter notices and retries once automatically, so a normal restart should be invisible; if a call still fails immediately after one, try it again — it typically succeeds once Beacon has finished starting up.

**Two copies of Beacon are running.** Only one running instance can hold the connection at a time. Quit the extra copy, then turn the toggle off and back on in the one you want serving requests.

---

**See also:** [Run with data](23-run-with-data.md) · [Importing OpenAPI specs](22-openapi-import.md) · [Settings](18-settings.md) · [Command line and CI](20-cli.md) · [Collection runner](12-collection-runner.md) · [Flows](13-flows.md)

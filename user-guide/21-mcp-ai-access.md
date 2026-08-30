# MCP / AI access

*Letting a local AI assistant read your collections and send requests through Beacon's own engine — what it can do, what's redacted, and running headless.*

**In this chapter**
- [What it is](#what-it-is)
- [Turning it on](#turning-it-on)
- [Connecting an AI client](#connecting-an-ai-client)
- [What an AI client can and cannot do](#what-an-ai-client-can-and-cannot-do)
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

Eleven tools, all prefixed `beacon_`. Seven only read; three send or run something; one reports status.

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
| `beacon_send_request` | Sends a saved or ad-hoc request and returns the redacted response. |
| `beacon_run_collection` | Runs a collection — the same engine the [Collection runner](12-collection-runner.md) uses — and returns a redacted run report. |
| `beacon_run_flow` | Runs a [flow](13-flows.md), by id or by name, and returns a redacted flow report. |

**There is nothing else.** No tool creates, edits, renames, or deletes a request, collection, environment, or anything else — the connection itself carries no such verb, so even a confused or misbehaving AI client has nothing beyond this table to reach for.

Sends can run concurrently, but collection and flow runs share a single slot: starting a second one while one is already in flight gets a `busy` result naming the run that's already going, rather than queueing it silently.

**You can see it happening.** An AI-driven send lands in [History](17-history-and-cookies.md) like any request of your own, marked with a small **AI** chip; if the History panel isn't open when one arrives, a dot appears on its Activity Rail icon and stays until you open the panel. And while an AI client is connected at all, the status bar at the bottom of the window shows **AI connected**. All three are passive markers — Beacon never switches panels or steals focus because an AI did something.

A flow run is visible too, but only if you already have that flow's own tab open: nodes light up as they execute — including a failure — the same way they would for a run you started yourself, plus a "Run by AI client" line in the run log. Like the markers above, this never opens the tab or switches you to it; it only renders while you're already looking at that flow.

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
| `beacon_run_flow` | |

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

**See also:** [Settings](18-settings.md) · [Command line and CI](20-cli.md) · [Collection runner](12-collection-runner.md) · [Flows](13-flows.md)

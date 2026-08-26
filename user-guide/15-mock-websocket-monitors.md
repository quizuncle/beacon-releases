# Mock, WebSocket, and monitors

*Three connection tools — a local mock server, a WebSocket client, and scheduled health monitors.*

**In this chapter**
- [Mock server](#mock-server)
- [WebSocket client](#websocket-client)
- [Monitors](#monitors)

The mock server and WebSocket client live under **Connections** on the Activity Rail (`⌘5`); **Monitors** has its own rail entry.

## Mock server

The mock server serves canned responses from routes you define, so you can develop against endpoints that don't exist yet or exercise error states.

**Starting it.** Set a **Port** (default `3001`) and click **▶ Start**. The header then shows `Running on http://localhost:<port>`; click **■ Stop** to stop it. The server binds to `127.0.0.1` only. If the port is taken, you'll see `Port <port> is already in use`.

**Routes.** Click **Add Route** to add one. Each route row shows an enable checkbox, the method badge, the path, the status code (color-coded), and a delay if set. Hover for **Edit** and **Delete**. Edit a route in the **Edit Mock Route** modal:

| Field | Notes |
|---|---|
| **Method** | `GET`, `POST`, `PUT`, `PATCH`, or `DELETE`. |
| **Path** | The path to match, e.g. `/users/:id`. |
| **Status Code** | The response status (defaults to `200`). |
| **Delay (ms)** | Artificial latency before responding — useful for testing loading states. |
| **Response Body** | The body to return. |

**How matching works.** The first enabled route whose method and path match wins. A path segment starting with `:` (like `/users/:id`) matches any single segment, but the number of segments must be equal — there's no wildcard, prefix, or query-string matching. A request that matches nothing gets a `404` with `{"error":"No matching mock route found"}`. Every mock response includes an `X-Mock-Server: postman-desktop` header.

> **Note:** Response headers aren't editable in the route modal. To give a route custom headers, generate it from a saved example (below), which copies the example's headers.

### Generating a route from an example

From a saved request's **Examples** submenu (see [Collections](11-collections.md#examples)), **Generate mock** creates a route that returns that example — deriving the path from the request URL and copying the example's status, body, and headers. Because the running server reads routes live, a generated route is served immediately.

## WebSocket client

A simple client for connecting to a WebSocket server and exchanging messages.

**Connecting.** Type a URL (default `ws://`, e.g. `ws://localhost:8080/ws`) and click **Connect**; a status dot shows connected (green), connecting (yellow), error (red), or disconnected (gray). Click **Disconnect** to close.

**Messages.** The log shows each message as a directional bubble — `↑ Sent` (blue, right) or `↓ Received` (gray, left) — with a timestamp. Type into the box at the bottom and press **Enter** to send (`Shift+Enter` inserts a newline); messages are sent as raw text, so you type JSON yourself. **Clear** empties the log without disconnecting.

> **Note:** The WebSocket client takes only a URL — there's no UI for custom headers, subprotocols, or auth, and connections aren't saved. Switching away from the WebSocket tab closes the connection.

## Monitors

A monitor runs a **saved request** on a fixed interval and tracks its health and latency over time. Open **Monitors** from the Activity Rail.

> **Note:** Monitors run only while Beacon is open — there is no cloud or background execution.

**Creating a monitor.** Click **New** for the **New Monitor** modal:

| Field | Notes |
|---|---|
| **Request** | Any saved request (`<collection> / <request>`). |
| **Name** | Defaults to the request's name. |
| **Interval (seconds)** | How often to run (minimum 1, default 60). |
| **Slow threshold (ms)** | Optional; above this latency the run is `degraded`. |
| **Environment** | `None` or any environment (defaults to the active one). |
| **Up only if all tests pass** | When on, a failing test assertion marks the run `down`. |
| **Desktop notification on state change** | On by default. |

**The monitor list** shows each monitor's status dot (up / degraded / down / paused), name, interval, uptime, and last status. Hover to **Pause/Resume** or **Delete**. Click a monitor to open its detail tab.

**Monitor detail** shows the uptime percentage and run count, a **latency sparkline** of recent runs (colored by state), and a **run history** list (newest first) with each run's time, status, and latency or error.

**Exporting the history.** The download button in the detail header saves the run history as JSON — the monitor's schedule and thresholds, the uptime percentage, and every run Beacon still keeps (the last 100). It is health data only: a monitor run records the verdict, status, latency and any error message, never the request or response itself. The button is disabled until the monitor has run at least once.

This is a **health export**, not the run report the [Collection runner](12-collection-runner.md#exporting-a-run-report) and [flows](13-flows.md#exporting-a-run-report) produce. There are no per-request results here to turn into a JUnit `<testcase>` or an HTML page, so JSON is the only format and there is nothing to include bodies from.

> **Before you attach it to a ticket:** an error message can quote something the request was carrying — a script error, or a GraphQL variables error that echoes the JSON after your `{{variables}}` were filled in. On export, Beacon blanks any value currently marked **secret** — in any environment in this workspace, in your globals, or in the collection the monitored request lives in — wherever it appears in those messages. Two things it cannot blank: a secret you have since rotated or unflagged, and — because monitors are not tied to a workspace while environments are — the secrets of an environment belonging to a *different* workspace than the one you are in. Give the file a glance if the monitor has been recording errors.
>
> On screen, the run history shows each error exactly as it was recorded — nothing is blanked there, deliberately, because that text is what makes a failure diagnosable and the value in it has already gone to the host being monitored. It stays in Beacon's local database on this machine: a monitor's run history is not part of cloud sync, and it is not included when you export or share a collection. The download button above is the only thing that copies it out, and that is the path that blanks it.

**How health is judged.** A run is **down** on a network error, a non-2xx status, or (with the tests option on) a failed test; **degraded** when 2xx but slower than the threshold; **up** otherwise. Uptime is the share of runs that were up or degraded.

**Notifications.** When enabled, a native `Beacon monitor` notification fires only on a **state change** — `<name> is down`, `<name> recovered`, or `<name> is degraded (slow)` — never on every run.

> **Tip:** A monitor tracks health over time. To simply re-run the request in front of you and see what changed, use [Watch](09-responses.md#watch-re-send-on-an-interval) in the response viewer instead.

---

**See also:** [Collections](11-collections.md) · [Responses](09-responses.md) · [Load testing](14-load-testing.md)

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

**How health is judged.** A run is **down** on a network error, a non-2xx status, or (with the tests option on) a failed test; **degraded** when 2xx but slower than the threshold; **up** otherwise. Uptime is the share of runs that were up or degraded.

**Notifications.** When enabled, a native `Beacon monitor` notification fires only on a **state change** — `<name> is down`, `<name> recovered`, or `<name> is degraded (slow)` — never on every run.

> **Tip:** A monitor tracks health over time. To simply re-run the request in front of you and see what changed, use [Watch](09-responses.md#watch-re-send-on-an-interval) in the response viewer instead.

---

**See also:** [Collections](11-collections.md) · [Responses](09-responses.md) · [Load testing](14-load-testing.md)

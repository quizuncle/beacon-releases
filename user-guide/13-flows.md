# Flows

*Chaining requests visually on a canvas — one response feeds the next, with conditions, extraction, and scripts.*

**In this chapter**
- [What a flow is](#what-a-flow-is)
- [Creating and editing flows](#creating-and-editing-flows)
- [The canvas](#the-canvas)
- [Node types](#node-types)
- [Running a flow](#running-a-flow)
- [Flow variables](#flow-variables)
- [Loops and safety](#loops-and-safety)

## What a flow is

A flow is a visual pipeline of nodes on a canvas, where one node's output can feed the next. Use flows to model multi-step sequences — authenticate, then create a resource, then verify it — without writing a runner script. Open the **Flows** panel from the Activity Rail (`⌘4`).

## Creating and editing flows

Click the **+** in the Flows panel (`Create a new empty flow`) to make a `New Flow`, which opens as a tab already seeded with a **Start** node. Both the flow's name and its canvas autosave as you edit (no Save button). Hover a flow in the list for a trash button to delete it.

## The canvas

The flow opens on a dotted-grid canvas. Add nodes with the **Add node** button (top-left) or by right-clicking the canvas — both list the six addable node types. You can also **drag a saved request from the Collections tree straight onto the canvas** to create a linked Request node.

**Wiring.** Drag from a node's output port to another node's input handle to connect them. The wiring order sets the execution order: when a node fans out to several targets, the first-wired edge's whole downstream chain runs before the next (depth-first).

**Editing.** Selecting a node opens its config panel on the right. `Delete` / `Backspace` removes the selected node or edge — except the Start node, which can't be deleted. Pan and zoom the canvas freely.

## Node types

| Node | What it does | Ports |
|---|---|---|
| **Start** | The single entry point; no config. Exactly one is required. | one output |
| **Request** | Sends an HTTP request — either **Linked** (a saved request) or **Inline** (method, URL, headers, body, auth defined on the node). A `Treat HTTP 4xx/5xx as failure` checkbox controls which port fires. | Success, Failure |
| **Condition** | Branches on a value. Configure a **Source** (`$.json.path`, `status`, `responseTime`, `header:Name`, or `{{var}}`), an **Operator** (`equals`, `notEquals`, `gt`, `lt`, `contains`, `exists`, `regex`), and a **Value**. | True, False |
| **Extract** | Pulls values from the previous response into flow variables. Each row maps a source (`$.token`, `status`, `header:Name`) to a variable name. | one output |
| **Delay** | Pauses for a number of milliseconds (interpolatable, e.g. `{{retryDelay}}`). | one output |
| **Script** | Runs JavaScript between steps, with `pm.flow.get/set`, `pm.flow.lastResponse`, `pm.flow.stop(reason)`, plus `pm.environment` / `pm.globals`. | Success, Error |
| **Input** | Pauses the run and shows a form; the submitted values become flow variables. | one output |

### The Input node

An **Input** node pauses the run and prompts you with a small modal form — useful for a value you can't know until run time (an order ID, an OTP, a one-off token), or a value that depends on an earlier response.

Configure it in the node's **Input** panel: give the form a **Form title**, then add fields with **+ Add field**. Each field has a **Label** (shown in the form), a **Variable** (the flow variable its value is written to), an optional **Default value** (pre-fills the field, and is interpolated so it can reference existing variables), and a **Secret (masked)** toggle that renders the field as a password input.

When the run reaches the node, it pauses and shows the form (`The run is paused until you continue.`). Fill it in and click **Continue** to resume — each value is written to its flow variable and is available downstream as `{{variable}}`. **Cancel** (or `Esc`, or clicking the backdrop) aborts the run as `cancelled`. Press `Enter` to submit.

> **Note:** The values are written only as flow variables for the current run — an Input node never changes your saved environments or globals. Fields left with a blank **Variable** are skipped.

## Running a flow

When the flow has a Start node, a **Run** button appears in its header (`Run the flow from its start node, following the wired path.`). While it runs, a **Stop** button lets you abort; switching away from the tab also aborts.

The run visualizes live: each node's border reflects its phase (running, success, failed, cancelled), traversed edges animate, and a re-visited node shows a `×N` visit counter. Selecting a node that produced a response shows its body and headers in a pane below. A collapsible **Run log** at the bottom lists timestamped, color-coded (info / warn / error) lines and the final `Run <status>`.

## Flow variables

**Extract** nodes, **Input** nodes, and `pm.flow.set` write **flow variables**, referenced downstream as `{{variable}}`. In interpolation, flow variables take the highest precedence, then environment → collection → global. The run works on deep copies of your environment and global variables, so it has no side effects **unless** a Script node explicitly calls `pm.environment.set` or `pm.globals.set` — only the keys it changes are merged back and persisted.

> **Note:** Flow Request nodes send the request's URL, headers, body, and auth, but do not run a saved request's own pre-request or test scripts — the flow engine drives execution itself. Use a **Script** node for logic between steps.

## Loops and safety

Cyclic wiring is allowed and safe: a node can be visited up to a maximum (100 by default). Exceeding it fails the run with `Loop cap exceeded on "<node>" (N visits)`, so a runaway loop stops on its own. A Script node can end a run cleanly at any point with `pm.flow.stop("reason")`.

---

**See also:** [Collection runner](12-collection-runner.md) · [Scripts and tests](08-scripts-and-tests.md) · [Variables and environments](07-variables-and-environments.md)

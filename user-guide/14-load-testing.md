# Load testing

*Firing a request many times concurrently to measure latency and throughput, with live charts and run comparison.*

**In this chapter**
- [What load testing does](#what-load-testing-does)
- [Creating a load test](#creating-a-load-test)
- [Running and live charts](#running-and-live-charts)
- [Run history and comparison](#run-history-and-comparison)
- [Captured samples](#captured-samples)

## What load testing does

A load test fires one request repeatedly across many parallel virtual users and measures how the target responds under load. Open the **Load Tests** panel from the Activity Rail.

> **Note:** Load tests send only the request's URL, headers, and body. Pre-request and test scripts do **not** run, and OAuth tokens are **not** refreshed. If the body is binary or has a file field, the body is not sent.

## Creating a load test

Click the **+** in the Load Tests panel to open **New Load Test**:

| Setting | What it does |
|---|---|
| **Request** | The current tab, or any saved request. |
| **Name** | Optional; defaults to the request name. |
| **Environment** | The active environment or a specific one. |
| **Concurrency (VUs)** | Virtual users firing in parallel (`1`–`500`). |
| **Mode** | `Duration` (run for N seconds) or `Request count` (stop after N requests). |
| **Duration (seconds)** / **Total requests** | The stop condition for the chosen mode. |
| **Ramp-up (seconds)** | Stagger the virtual users' starts over this many seconds instead of all at once. |
| **Capture request/response** | `All requests`, `Errors only`, or `Off` — how many samples to store (locally, never synced). |
| **Max captured** | Cap on stored samples per run (`0` = unlimited); errors are kept preferentially, and each body is capped at 64 KB. |

Click **Create load test**. Each config row in the list shows a summary (`<target> · <N> VUs · <duration or count>`) with **Play** and **Delete** on hover.

## Running and live charts

Open a config and press **Start** (or **Cancel** to stop mid-run). Only one run can be live at a time. While it runs, the header shows `Running… N active VUs · Xs elapsed`.

**Stat tiles** show `Total`, `RPS`, `Error %`, `Avg`, `p50`, `p95`, `p99`, `Min`, and `Max` (Min/Max fill in when the run finishes). A **status codes** bar breaks down responses by code. Live line charts track **latency over time** (avg/p50/p95/p99), **throughput (RPS)**, **concurrency (active VUs)**, and **errors over time**; a finished run also shows a **latency distribution** histogram.

## Run history and comparison

Past runs are listed on the left, each showing its start time, a colored state (`completed`, `error`, `cancelled`, `running`), and an `rps · p95 · err` summary. Only completed runs open. A global **Run history** entry (the clock icon in the list panel) shows a table of every run across all configs.

Turn on **Compare** (the shuffle icon) and pick exactly two completed runs to see delta tiles — **RPS**, **p95**, **Avg**, and **Error rate**, each flagged improved or regressed — plus an overlaid A-vs-B latency chart. Use it to confirm a change actually made the endpoint faster.

## Captured samples

If capture was on, a **Charts | Requests** toggle appears. The **Requests** tab lists individual captured requests with `#`, status, method, URL, latency, size, and error, filterable to `All` or `Errors only` and paginated with **Load more**. Click a row for full request and response detail (bodies over 64 KB show a `truncated` badge).

Capture semantics: `Off` stores nothing; `Errors only` keeps just failures up to the cap; `All` keeps every request in completion order up to the cap, then stops. On a long run, use `Errors only` to be sure failures are captured.

> **Note:** Everything about load tests — configs, runs, and captured samples — is stored locally on this device and is never synced.

---

**See also:** [Collection runner](12-collection-runner.md) · [Flows](13-flows.md) · [Sending requests](03-sending-requests.md)

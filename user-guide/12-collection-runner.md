# Collection runner

*Running a whole collection or folder in sequence — with iterations, data files, and per-request results.*

**In this chapter**
- [Opening the runner](#opening-the-runner)
- [Choosing requests](#choosing-requests)
- [Run configuration](#run-configuration)
- [Data-driven runs](#data-driven-runs)
- [Reading results](#reading-results)
- [Request chaining](#request-chaining)

## Opening the runner

Run a whole collection from its `⋯` menu (`Run collection`), or a single folder from its menu (`Run folder`). Either opens the **Collection Runner** as a full-screen modal.

## Choosing requests

The left pane lists the collection's folders and requests, each with a checkbox. Use **All** / **None** or the **Search requests…** filter to narrow the set. A folder run pre-selects only that folder's subtree, but you can still select anything in the collection. The header shows `Requests (<selected>/<total>)`.

## Run configuration

| Setting | What it does |
|---|---|
| **Iterations** | How many times to run the selected set (`1`–`999`). Driven by the data file when one is loaded. |
| **Delay (ms)** | A pause between requests (`0`–`30000`). |
| **Stop on failure** | `Stop run on first failure` — skip all remaining requests as soon as one errors or a test fails. |
| **Environment** | Which environment to run against (`No Environment` or any). |
| **Data File** | An optional CSV or JSON file for data-driven runs. |

A **run summary preview** shows the selected-request count, iterations, total runs (`selected × iterations`), the minimum time (from delays), and the data columns. The **Run** button reads `Run <N> Request(s)` and is disabled until at least one request is selected.

## Data-driven runs

Attach a **CSV or JSON** data file and each row becomes one iteration — the row count drives the iteration count. In your scripts and requests, read a row's values with `pm.iterationData.get("key")` (or use the column names as `{{variables}}`, which the data row overrides). Click the **eye** to preview the file as a paginated table (50 rows per page).

## Reading results

As the run proceeds, each request produces a result row, color-coded by outcome (skipped, error, failed tests, or pass). A row shows the method, name, iteration number, HTTP status, timing, size, test pass/fail pills, and any extracted-variable chips. Rows auto-expand on failure. Expand a row for sub-tabs: **Response**, **Headers**, **Request**, **Tests**, and **Console** (captured `console.log` output).

While a request runs, its row shows a **Cancel** button to skip it and move on. When multiple iterations run, each gets a summary line (`Iteration #n · … · <passed>✓ <failed>✗`). When the run finishes, a summary row shows totals (`✓ passed`, `✗ failed`, `◎ errors`, total time), and **Export Results** downloads a `<collection>-run-results.json` with the config, summary, and every result.

## Request chaining

Scripts can steer the run. Call `pm.setNextRequest("<name>")` to jump to another request instead of continuing in order, or `pm.setNextRequest(null)` to end the iteration early. With **Stop on failure** on, the first error or failed test halts the run and marks the rest as skipped. See [Scripts and tests](08-scripts-and-tests.md#the-pm-api).

---

**See also:** [Collections](11-collections.md) · [Scripts and tests](08-scripts-and-tests.md) · [Flows](13-flows.md) · [Load testing](14-load-testing.md)

# Collection runner

*Running a whole collection or folder in sequence — with iterations, data files, and per-request results.*

**In this chapter**
- [Opening the runner](#opening-the-runner)
- [Choosing requests](#choosing-requests)
- [Run configuration](#run-configuration)
- [Data-driven runs](#data-driven-runs)
- [Reading results](#reading-results)
- [Exporting a run report](#exporting-a-run-report)
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

While a request runs, its row shows a **Cancel** button to skip it and move on. When multiple iterations run, each gets a summary line (`Iteration #n · … · <passed>✓ <failed>✗`). When the run finishes, a summary row shows totals (`✓ passed`, `✗ failed`, `◎ errors`, total time), and the runner's header grows a **run report** export — see below.

## Exporting a run report

A finished run can be saved as a **run report**. Pick a format in the runner's header, optionally tick **Include bodies (JSON only)**, then hit **Export Report**; Beacon offers to save it as `<collection>-run.<ext>`.

| Format | File | What it's for |
|---|---|---|
| **JSON report** | `.json` | The machine-readable form — run metadata, summary totals, and one entry per request. The only format that can carry bodies. |
| **JUnit XML** | `.xml` | CI. Each `pm.test()` assertion becomes a `<testcase>`, so Jenkins, GitLab, or GitHub Actions show your assertions as test results. A request with no assertions still appears as one case, so a run never reads as "nothing ran". |
| **HTML report** | `.html` | A single self-contained page to open in a browser or attach to a ticket — no scripts, no external requests, nothing to load. |

Every report carries the same run: the collection name, the environment it ran against, start and finish times, the Beacon version that produced it, the summary totals, and one entry per request per iteration — name and folder path, method, final URL, status, timing, the headers that were sent, console output, and every assertion with its failure message. Skipped requests are in there too, marked as skipped.

**Include bodies (JSON only)** adds each entry's request and response body. The tick box is disabled for the other two formats because neither embeds bodies — offering it there would promise something the file cannot deliver.

### What is masked

Reports are redacted before they are written, always — there is no switch to turn it off. Three things happen on the way out:

- **Credential headers** — `Authorization`, `Cookie`, `X-Api-Key` and the rest of the known set — lose their whole value.
- **Your API key's own header or query parameter** is blanked too, even when you send it under a name you invented (`X-Company-Token`), and a `user:password@` in a URL is stripped.
- **Every value you marked secret** — in an environment, in your globals, or in a collection the run used — is replaced with `••••••` wherever it turns up: in URLs, in console output, in assertion messages, and in bodies when you included them. If a script rotated a secret part-way through the run, both the old and the new value are masked.

Response headers are never written into a report at all.

> **What redaction cannot know.** It recognises credential-shaped headers and the values you flagged **secret**. A token that is neither — pasted into a header row of your own naming like `X-Acme-Session`, or handed back by a response into a variable you never marked secret — is not recognised, and a secret shorter than four characters is deliberately left alone (scrubbing every stray `1` would turn a report into confetti without hiding anything). Give a report a glance before you attach it somewhere public.

## Request chaining

Scripts can steer the run. Call `pm.setNextRequest("<name>")` to jump to another request instead of continuing in order, or `pm.setNextRequest(null)` to end the iteration early. With **Stop on failure** on, the first error or failed test halts the run and marks the rest as skipped. See [Scripts and tests](08-scripts-and-tests.md#the-pm-api).

---

**See also:** [Collections](11-collections.md) · [Scripts and tests](08-scripts-and-tests.md) · [Flows](13-flows.md) · [Load testing](14-load-testing.md)

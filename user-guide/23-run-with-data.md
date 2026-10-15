# Run with data

*Send one request once for every row of a CSV or JSON file, watch the results, re-run only the rows that failed, and export a results file.*

**In this chapter**
- [Opening the drawer](#opening-the-drawer)
- [Data files](#data-files)
- [The column check](#the-column-check)
- [Settings](#settings)
- [Running and results](#running-and-results)
- [Re-running failed rows](#re-running-failed-rows)
- [Exporting results](#exporting-results)
- [Good to know](#good-to-know)

Use this for bulk work on real data, such as re-syncing 300 ERP orders or retrying a list of failed invoices. It runs the request in the current tab, as it is now (saved or not), against the active environment. To run many different requests, use the [Collection runner](12-collection-runner.md).

## Opening the drawer

Open it any of three ways:

- The `Run with data` button next to Send in the Omnibox.
- The `Run with data` command in the command palette.
- `Run with data` in the right-click menu of a saved request in the sidebar. The request opens in a tab first.

The drawer belongs to one tab. It is hidden while you look at another tab and is back when you return.

## Data files

Drop a file on the drawer or pick one. It must be `.csv` or `.json`.

- **CSV:** the first row is the header. Each later row is one run. A UTF-8 BOM, CRLF line endings and a blank last line are fine.
- **JSON:** an array of flat objects, such as `[{"erpOrderId": "E-1"}, {"erpOrderId": "E-2"}]`. Values are used as text. Nested objects or arrays are refused.
- **Size:** up to 10,000 rows.

A file with no data rows, an empty or repeated column name, or a JSON root that is not an array is refused with a one-line reason. After loading you see the file name, the row and column counts, and a preview of the first 5 rows.

Write `{{columnName}}` in the URL, params, headers, body or auth, exactly as you would for a variable. Scripts can read the row with `pm.iterationData`, the same as in the Collection runner.

## The column check

Under the preview, Beacon compares your columns with the variables the request uses:

- A column that fills a `{{variable}}` shows where it is used.
- A column nothing uses is flagged, because it is probably a typo.
- A `{{variable}}` no column fills is flagged as `from environment` if the active environment has it, otherwise as unresolved. An unresolved variable is sent as written, as a normal Send does.

## Settings

| Setting | Meaning |
|---|---|
| `Parallel requests` | How many rows are in flight at once, 1 to 10. Default 1. |
| `Delay (ms)` | A pause before each worker starts its next row, 0 to 60,000. Default 0. |
| `Counts as failed` | `status`: a network error or a non-2xx status. `tests`: a network error, or a failed or erroring test. Default `status`. |
| `Stop on first failure` | Send no new rows after a row fails. |
| `Extra columns` | Response fields to add to the export, such as `data.id, message`. Uses the same paths as `fields` in [MCP / AI access](21-mcp-ai-access.md). |

`Extra columns` is read when the run starts, and the export uses those fields. Changing it afterwards does not change a run that has finished. The settings and the file are locked while a run is going.

## Running and results

Press `Run`. You see done and total, with passed and failed counts. `Stop` sends no new rows; rows already in flight finish and are kept.

The results table lists rows in file order: the row number, its values, the status, the time, and whether it passed. It shows up to 1,000 lines; export the CSV to get all of them. Click a line to see that row's response (status, headers and body). Full responses are kept for the 50 most recent rows. Older rows keep their status, time, error, test counts and extra fields.

Only one data run can go at a time. The run keeps going when you switch to another tab. If you open `Run with data` on a different tab meanwhile, the status bar says `A data run is in progress in another tab`. While a run is going, the drawer's close button is disabled (its tooltip says `Stop the run first`) and closing the tab is refused with `Stop the data run before closing this tab`. Press `Stop` first; once the run has ended you can close both.

## Re-running failed rows

When a run ends with failures, `Re-run N failed` starts a new run of only those rows, using the drawer's current settings (change them first if you want a slower or stricter re-run). Row numbers stay the original ones, so the results and export still line up with your file.

## Exporting results

`Export results CSV` opens a save dialog. The columns are `row`, then your input columns, then `status`, `durationMs`, `ok` and `error`, then your `Extra columns`. Rows that were not run say `not run`.

A cell that starts with `=`, `+`, `-`, `@`, a tab or a carriage return gets a `'` in front, so an order id such as `-104250` or a message such as `=SUM(...)` does not run as a formula when you open the file in Excel. The value stays readable.

## Good to know

- App data runs are not written to [History](17-history-and-cookies.md). The results table and the export are the record. (Runs made by an AI client do write History rows.)
- With `Parallel requests` above 1, variable writes from scripts (`pm.environment.set` and the like) are ignored, and the drawer says so. With exactly 1 they are kept, as in the Collection runner.
- An AI client can run the same kind of job with `beacon_call`; see [MCP / AI access](21-mcp-ai-access.md#beacon_call-with-data). Its `resultsPath` CSV lists every row of the file; rows before `startRow` say `not run`.

---

**See also:** [Collection runner](12-collection-runner.md) · [Variables and environments](07-variables-and-environments.md) · [MCP / AI access](21-mcp-ai-access.md)

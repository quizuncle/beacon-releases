# Command line and CI

*Running a collection or a flow from a terminal — or from a build — with the `beacon` command.*

**In this chapter**
- [What the CLI is](#what-the-cli-is)
- [Installing](#installing)
- [Exporting a bundle to run](#exporting-a-bundle-to-run)
- [Your first run](#your-first-run)
- [Every option](#every-option)
- [Exit codes](#exit-codes)
- [Reports](#reports)
- [Variables and secrets](#variables-and-secrets)
- [Scripts and trust](#scripts-and-trust)
- [Running a flow](#running-a-flow)
- [Checking a bundle without running it](#checking-a-bundle-without-running-it)
- [In a CI pipeline](#in-a-ci-pipeline)

## What the CLI is

`beacon` is a separate, headless command that runs the same collections and flows the desktop app runs — the [Collection runner](12-collection-runner.md) and [Flows](13-flows.md) without a window. It sends the requests, runs the scripts, checks the assertions, prints a per-request line, and ends with an exit code your build system can act on. It can write the same [run reports](12-collection-runner.md#exporting-a-run-report) the app exports.

Two things it deliberately is not:

- **It is not the app.** It has no database, no workspaces, no history, no cookie storage between runs, and it never writes to your Beacon profile. It reads one exported file and executes it.
- **It is not a way to open your saved work from disk.** The only input it accepts is a **bundle** — see below.

## Installing

**Homebrew** (macOS):

```bash
brew tap quizuncle/beacon
brew install beacon-cli
```

That installs the command `beacon`. The formula depends on `node`, so Homebrew installs Node too if you don't have it.

> **Note:** `beacon-cli` is the **formula** (the command line runner); `--cask beacon` is the desktop app. They are separate installs from the same tap, released together under one version number.

**Or download the file.** Every Beacon release attaches `beacon-cli-<version>.js` — one self-contained JavaScript file with no dependencies to install. Grab it from the release page and run it with Node 20 or newer:

```bash
node beacon-cli-0.3.0.js run api.beacon.json
```

Either way, check what you have with:

```bash
beacon --version      # prints the version, e.g. 0.3.0
beacon --help         # prints the full usage, including the exit codes
```

`beacon` with no arguments prints the same usage.

## Exporting a bundle to run

The CLI's input is a **Beacon bundle** — the single `.json` file the app's **Export** dialog writes (see [Collections → Exporting](11-collections.md#exporting)). One file carries the collections, environments, global variables and flows a run needs.

1. In the Collections header, click **Export**.
2. Tick the collections you want to run.
3. Tick **Environments** (otherwise `--environment` has nothing to choose from), **Global variables**, and **Flows** if you plan to use `--flow`.
4. Leave **Include secret values** off — see [Variables and secrets](#variables-and-secrets).
5. Save the file into your repository, for example as `api.beacon.json`, and commit it.

Re-export and re-commit the file whenever the requests change: the bundle is a snapshot, not a live link to your app.

> **Note:** Mock routes travel in a bundle too, but the CLI has no use for them — it never starts a mock server. They are simply ignored.

## Your first run

```bash
beacon run api.beacon.json
```

If the bundle holds exactly one collection, that is the one that runs. If it holds several, name the one you mean — `beacon run api.beacon.json --collection "Checkout API"` — because picking one for you would mean the build's behaviour depends on export order.

Output looks like this:

```
  ✓ POST Log in · 200 · 41ms
  ✓ GET Get user · 200 · 34ms
  ✗ GET Get orders · 500 · 12ms
      ✗ status is 200 — expected 500 to equal 200

  collection Checkout API · environment staging
  requests    3
  assertions  2 passed, 1 failed
  errors      0
  duration    1.4s

  FAILED
```

One line per request — the mark (`✓` ran clean, `✗` failed, `-` never ran), method, name, status, time — then failed assertions underneath it, then the summary block. `--verbose` adds the final URL, passing assertions and script console output; `--quiet` prints the summary block and nothing else.

Colour is used when the output is a terminal and dropped when it is piped or redirected, so a captured build log has no escape codes in it. Setting `NO_COLOR` turns colour off in a terminal too.

Press `Control-C` to stop a run: the first press stops it after the request already in flight, then reports what finished. The **run** still fails — exit `1` even if everything that ran passed, because an interrupted run is never green — though the summary block and the report describe only the part that completed, and will read as passing if it did. A second press kills the process.

## Every option

`beacon run <bundle.json>` takes the following. Nothing here is required except the file itself.

**Selecting what to run**

| Option | What it does |
|---|---|
| `--collection <name>` | The collection to run. Optional when the bundle contains only one. |
| `--folder <name>` | Run only the requests in this folder and everything nested under it. Matches the folder's name, or its full path (`Orders/Checkout`) when two folders share a name. |
| `--flow <name>` | Run a flow instead of a collection — see [Running a flow](#running-a-flow). |

**Variables**

| Option | What it does |
|---|---|
| `--environment <name>` | Activate an environment defined in the bundle. |
| `--env-var KEY=VALUE` | Define or override one variable. Repeatable. Highest precedence — this is how secrets stay out of the committed file. |

**Run behaviour** (collection runs)

| Option | Default | What it does |
|---|---|---|
| `--iterations <n>` | `1` | Repeat the whole collection *n* times. A whole number, 1 or more. |
| `--delay <ms>` | `0` | Pause between requests. A whole number of milliseconds, 0 or more. |
| `--timeout <ms>` | `30000` | Per-request timeout. A whole number of milliseconds, 1 or more. |
| `--bail` | off | Stop at the first failed assertion or request error; everything after it is reported as skipped. |
| `--insecure` | off | Don't verify TLS certificates. |
| `--no-scripts` | off | Don't run pre-request or test scripts — see [Scripts and trust](#scripts-and-trust). |

**Reports**

| Option | Default | What it does |
|---|---|---|
| `--report <formats>` | none | Comma-separated, repeatable: `json`, `junit`, `html`. |
| `--report-dir <dir>` | `.` | Where the report files are written. Created if it doesn't exist. |
| `--include-bodies` | off | Include request and response bodies in the reports (JSON reports only). |

**Output**

| Option | What it does |
|---|---|
| `--quiet` | Print only the final summary. |
| `--verbose` | Print request and response detail as the run proceeds. |

A command line that cannot do what it says is refused rather than quietly half-obeyed — each of these exits `2` with a message naming the flag:

- `--report-dir` without `--report` (it would write nothing).
- `--quiet` together with `--verbose`.
- `--flow` together with `--collection`, `--folder`, `--iterations`, `--delay` or `--bail`.
- Any run option passed to `beacon validate`, which only parses the file.
- A `--collection`, `--folder` or `--flow` name that matches **nothing** — the message lists the names that would have worked.
- A name that matches **two or more** things, which is refused rather than guessed at. An ambiguous `--folder` is answered with the full paths that would disambiguate it; duplicate collection or flow names get no such escape hatch, and the message asks you to rename one.
- An `--iterations`, `--delay` or `--timeout` that is not a whole number at or above its floor — text, a fraction, and a value below the minimum are all rejected, quoting back what you passed. The floors are `--iterations 1`, `--delay 0` and `--timeout 1`, so `--iterations 0` and `--timeout 0` are errors while `--delay 0` is the default.

## Exit codes

Three codes, and the difference between the last two is the point of the command:

| Code | Meaning |
|---|---|
| `0` | Every request ran and every assertion passed. |
| `1` | The run finished with assertion, test or request failures. There is a report describing them. |
| `2` | Configuration or runtime error — bad flags, an unreadable or invalid bundle, an unknown collection/folder/flow/environment, a report directory that couldn't be written. |

`1` means *your API is broken*; `2` means *your pipeline is broken*. A build step can treat them differently. Most exit-`2` cases — a bad flag, a bundle that could not be read or parsed, a name that matched nothing — come with no report at all, because nothing ran. The one exception is a report that could not be written: there the requests did run, and the files that had already been written before the failure are still on disk. See [Reports](#reports).

## Reports

```bash
beacon run api.beacon.json --report json,junit,html --report-dir reports
```

That writes three files with **fixed** names:

| Format | File | What it's for |
|---|---|---|
| `json` | `reports/beacon-report.json` | The machine-readable run — metadata, totals, one entry per request per iteration. |
| `junit` | `reports/beacon-report.xml` | CI test reporting. Each assertion is a `<testcase>`, so Jenkins, GitLab or GitHub Actions show your assertions as tests. |
| `html` | `reports/beacon-report.html` | A single self-contained page to open or attach to a ticket. |

The names never change with the collection or flow — a CI step that collects `reports/beacon-report.xml` keeps working after somebody renames a collection.

The contents are exactly the reports the app exports, including the redaction: credential headers, your API key wherever it is carried, and every value you marked **secret** are masked before anything is written. Bodies are left out unless you pass `--include-bodies`. The full description of what is and isn't masked is in [Collection runner → What is masked](12-collection-runner.md#what-is-masked), and it applies to a collection run here as well — including to the lines printed on the console, which are redacted the same way, because a build log is usually more public than the report beside it.

**A `--flow` run masks the same way**, including the two axes that depend on knowing your API key's *name*. A flow's steps can span collections, so there is no single effective auth for the run — each step is instead masked against the auth *that step* resolved, so a key sent under a name you invented (`X-Company-Token`, or `?api_key=…` in the URL) is blanked, and so is one a request set for itself in place of its collection's. The known credential headers, every secret-flagged value, and a `user:password@` in a URL are masked exactly as in a collection run. The one gap a flow still has — a collection variable a script rewrites mid-run — is described under [Flows → Exporting a run report](13-flows.md#exporting-a-run-report).

If a report can't be written, the run exits `2` whatever the requests did — a `2` replaces the `1` a failing run would have exited with just as readily as the `0` a passing one would. The report is the deliverable, and a step that produced no artifact proved nothing either way.

## Variables and secrets

**Choosing an environment.** `--environment staging` activates the environment of that name in the bundle. If the bundle has exactly one environment, it is used automatically. If it has several and you name none, the run uses *no* environment rather than guessing — picking the first would eventually mean sending prod traffic because prod happened to be exported first.

**Overriding values.** `--env-var` wins over everything in the file, and can be repeated:

```bash
beacon run api.beacon.json \
  --environment staging \
  --env-var HOST=staging.internal \
  --env-var TOKEN="$CI_API_TOKEN"
```

A key the environment doesn't have is added, so `--env-var` works even with no `--environment` at all. The value is everything after the **first** `=`, so base64 padding and JWTs survive intact. An override also switches the variable on, in case the row was disabled in the bundle.

**Keep credentials out of the file.** Export with **Include secret values** off, then inject the real values with `--env-var` from your CI secret store. If a bundle *does* carry a value for a variable you marked secret — in any environment, in your globals, or in a collection's variables — the run prints one warning line to stderr:

```
Warning: this bundle carries a value for the secret variable TOKEN. Prefer --env-var KEY=VALUE so the credential lives in your CI secret store rather than in the file.
```

It names the keys and never the values, and it does not stop the run. A value you inject with `--env-var` over a secret-marked variable stays marked, so it is still masked in the reports.

## Scripts and trust

**Scripts in a bundle run.** Pre-request scripts, test scripts, and a flow's Script nodes all execute, with no trust prompt and no toggle — unlike a collection you import into the app, which arrives with its scripts switched off until you trust it.

That is deliberate, and it rests on one premise: *a CI bundle is repo-committed content executing on the committer's authority — the same trust model as `package.json` scripts.* You typed `beacon run ./api.beacon.json`, pointing at a file in your own repository; running its code is what the command is for. If bundles ever start arriving from somewhere you don't control, that premise no longer holds.

`--no-scripts` is the escape hatch, and it covers every kind of script the file can carry: collection-level and request-level pre-request and test scripts, a flow's **Script** nodes, and the scripts on a flow's inline requests. A flow's graph is left intact — a blanked Script node still passes the run along to whatever is wired after it, it just sets nothing.

## Running a flow

```bash
beacon run api.beacon.json --flow "Log in and order"
```

A flow brings its own requests, their order and their pacing, which is why `--flow` refuses to travel with `--collection`, `--folder`, `--iterations`, `--delay` or `--bail`. Everything else — `--environment`, `--env-var`, `--timeout`, `--insecure`, `--no-scripts`, the report flags, `--quiet`/`--verbose` — applies.

**Input nodes don't prompt.** There is nobody at the terminal in a build, and a prompt on a detached input doesn't fail, it hangs. So each field of an [Input node](13-flows.md#the-input-node) takes its value from, in order: a `--env-var` whose key matches the field's **Variable**, then the field's **Default value**, then an empty string. The run logs which of the three it used for each field — by field name, never the value.

The run ends `0` only if the flow reached its end *and* every assertion passed; a flow that failed, was cancelled, or never reached a request node exits `1`.

## Checking a bundle without running it

```bash
beacon validate api.beacon.json
```

Parses the file and describes what a run would find — the counts *and the names*, which is how you learn the spelling `--collection` and `--flow` expect without opening the JSON:

```
Valid Beacon bundle: Checkout workspace
  collections   2 (Checkout API, Admin API)
  requests      31
  environments  2 (staging, prod)
  globals       4
  flows         1 (Log in and order)
```

Anything the loader had to repair or drop on the way in is listed underneath. Those rows don't make the file invalid — but a global variable that quietly vanished turns every `{{use}}` of it into an empty string, and the resulting failure looks like the server's fault, so it is worth reading.

`validate` exits `0` for a file that loads and `2` for one that doesn't. It takes no run options.

## In a CI pipeline

A GitHub Actions step, for illustration:

```yaml
- name: API tests
  run: |
    node beacon-cli.js run api.beacon.json \
      --environment staging \
      --env-var TOKEN="${{ secrets.API_TOKEN }}" \
      --report junit,html --report-dir reports
- name: Upload report
  if: always()
  uses: actions/upload-artifact@v4
  with:
    name: beacon-report
    path: reports/
```

The pieces that matter in any CI system: inject credentials with `--env-var` rather than committing them, write the report to a fixed directory, collect that directory even when the step failed (the report is most useful exactly then), and let the exit code fail the build.

---

**See also:** [Collection runner](12-collection-runner.md) · [Flows](13-flows.md) · [Collections](11-collections.md#exporting) · [Variables and environments](07-variables-and-environments.md)

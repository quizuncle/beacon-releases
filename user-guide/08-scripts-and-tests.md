# Scripts and tests

*Pre-request scripts, the no-code assertion builder, the full `pm` API, schema validation, and script-free variable extraction.*

**In this chapter**
- [The Scripts panel](#the-scripts-panel)
- [Pre-request scripts](#pre-request-scripts)
- [Tests: the Builder](#tests-the-builder)
- [Tests: writing code](#tests-writing-code)
- [The pm API](#the-pm-api)
- [Schema validation](#schema-validation)
- [Post-response variable extraction](#post-response-variable-extraction)
- [The script trust gate](#the-script-trust-gate)

## The Scripts panel

The **Scripts** tab has four sub-tabs: **Pre-request Script**, **Tests**, **Schema**, and **Vars**. The Schema and Vars sub-tabs show a green dot when they contain something.

## Pre-request scripts

A JavaScript editor whose code runs **before** the request is sent. Use it to compute values, set variables, or mutate the outgoing request. The hint bar shows the most common use: `pm.environment.set("key", "value")`. The pre-request script can read and modify the request through `pm.request` (see below).

## Tests: the Builder

The **Tests** sub-tab has two views, toggled at the top: **Builder** and **Code**. The Builder is a no-code way to assemble assertions — click **+ Add assertion** and pick a target and operator:

| Target | Operators | Extra field |
|---|---|---|
| `Status code` | equals / not equals | — |
| `Response time` | is below / is above | numeric value |
| `Header` | exists / equals / not equals | header name |
| `JSON body path` | exists / equals / not equals | path, e.g. `data.id` |
| `Body text` | contains / matches regex | — |
| `Response is valid JSON` | — | — |

Builder rows compile into `pm.test(...)` blocks and are merged into the Tests **Code** between `// ---beacon:builder:begin---` and `// ---beacon:builder:end---` markers. This means hand-written test code and builder rows coexist in the same script — you can start in the Builder and drop into code for anything more complex.

## Tests: writing code

The **Code** view is a JavaScript editor that runs **after** the response returns. Write assertions with `pm.test` and `pm.expect`:

```javascript
pm.test("status is 200", () => {
  pm.expect(pm.response.code).to.equal(200);
});
```

Results appear in the response's **Tests** tab. See [Responses](09-responses.md#other-response-tabs).

## The pm API

Both the pre-request and test environments expose a `pm` object. The available members:

**Variables**
- `pm.environment.get/set/unset` — the active environment
- `pm.globals.get/set/unset` — global variables
- `pm.collectionVariables.get/set/unset` — collection variables (`set` persists to the collection)
- `pm.variables.get` / `pm.variables.set` — reads follow the resolution chain (data row / environment → collection → global)
- `pm.iterationData.get/has/toObject` — the current row in a [data-driven run](12-collection-runner.md)

**The request** (pre-request only) — `pm.request` is a mutable facade with `.method`, `.url` (which also carries a `.query` array), `.body` (`{mode, raw}`), and `.headers` with `.add/.upsert/.remove/.get/.has/.all/.each`. Changes are applied to the outgoing request.

**The response** (tests only) — `pm.response` exposes `.code`, `.status`, `.responseTime`, `.json()`, `.text()`, and `.headers.get(name)`. `pm.response.json()` throws a clear error if the body isn't JSON.

**Assertions** — `pm.test(name, fn)` records a pass/fail. `pm.expect(actual)` is a Chai-style BDD interface:
- Chain words: `.to`, `.be`, `.been`, `.is`, `.that`, `.which`, `.and`, `.has`, `.have`, `.with`, `.of`, `.same`, and `.not`
- Matchers: `equal` / `equals` / `eql` / `eq`, `a` / `an`, `include` / `contain` / `contains`, `property`, `above` / `greaterThan` / `least`, `below` / `lessThan` / `most`, `within`, `match`, `lengthOf`, `oneOf`
- Getters: `ok`, `true`, `false`, `null`, `undefined`, `exist`, `empty`
- Response-aware: `status(code)`, `.json`, `jsonBody(path?, value?)`, `header(name, value?)`, `jsonSchema(schema)`

**Flow control** — `pm.setNextRequest(name)` jumps to another request in a [Collection runner](12-collection-runner.md) run (`null` ends the iteration).

**Crypto** — `pm.crypto` and a `CryptoJS` global provide `hmacSHA256/SHA1/SHA512/MD5` and `sha256/sha1/sha512/md5`; results support `.toString('hex')` or `.toString('base64')`.

**Logging** — `console.log` output is captured and shown in the runner's Console output.

> **Note:** A collection's own pre-request and test scripts run around each request's — the collection's pre-request script first, then the request's; the request's test script first, then the collection's. They share one `pm` object. See [Collections](11-collections.md#collection-settings).

## Schema validation

The **Schema** sub-tab holds a JSON Schema. After every send, Beacon validates the response against it and shows the result in the response's **Schema** tab. See [Responses](09-responses.md#other-response-tabs).

## Post-response variable extraction

The **Vars** sub-tab extracts values from the response into variables **without writing a script**. Each row has:

- an enable checkbox,
- a **Source** (`Body`, `Header`, or `Status`),
- a conditional field — a JSON path like `data.token` for Body, or a header name for Header,
- a target scope (`Environment` or `Global`),
- and a **Variable name**.

Click **+ Add variable** to add a row. Extraction runs after every send — including inside the runner and flows — so extracted values chain across a run and persist alongside anything your test scripts set. Header lookups are case-insensitive.

## The script trust gate

Scripts can read your secrets — environment and global variables, tokens — so Beacon won't auto-run scripts from a collection you didn't create. Collections that arrive by **import** or **share** land **untrusted**: their pre-request and test scripts are skipped until you explicitly enable them. Turn scripts on from the collection's `⋯` menu (`Enable scripts…`) after reviewing them. See [Collections](11-collections.md#the-script-trust-gate).

---

**See also:** [Variables and environments](07-variables-and-environments.md) · [Responses](09-responses.md) · [Collection runner](12-collection-runner.md) · [Collections](11-collections.md)

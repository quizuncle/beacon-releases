# Variables and environments

*`{{variables}}`, their resolution order, environments and globals, secret values, and dynamic tokens.*

**In this chapter**
- [How variables work](#how-variables-work)
- [Resolution order](#resolution-order)
- [Environments](#environments)
- [Global variables](#global-variables)
- [Collection variables](#collection-variables)
- [Secret variables](#secret-variables)
- [Importing variables](#importing-variables)
- [Dynamic variables](#dynamic-variables)

## How variables work

Write `{{variableName}}` anywhere in a request and Beacon substitutes its value at send time. Variables work in the URL, query and path parameters, header keys and values, all auth text fields (except masked password fields), request bodies (JSON, raw, urlencoded, form-data, GraphQL), and inside scripts. In variable-aware fields, tokens render as colored accent pills. An unknown variable is left untouched as the literal `{{name}}`.

## Resolution order

When the same variable name exists in more than one place, Beacon resolves it in this order, first match wins:

1. **Environment** (the active one)
2. **Collection**
3. **Global**

Then dynamic `$`-tokens are resolved. Only **enabled** variables participate. During a [data-driven run](12-collection-runner.md), the current data row overrides everything for the keys it defines.

The Omnibox shows a live `↳` preview of the fully-resolved URL whenever it differs from what you typed, so you can confirm a variable resolves the way you expect.

## Environments

An environment is a named set of variables you switch between — for example `Local`, `Staging`, and `Production`, each with its own `baseUrl` and tokens. Open the **Environments** panel from the Activity Rail (`⌘3`).

- **Create** — click the **+** (`Create a new empty environment.`). A new environment named `New Environment` opens as a tab.
- **Activate** — hover an environment and click **Set active**, or use the Toolbar's environment selector (`⌘E`). Only one environment is active at a time. The active one shows a green `Active` label.
- **Rename** — in the environment's tab, click the pencil, type, and press Enter.
- **Delete** — click the trash icon and confirm. Requests that used it fall back to globals.

**The variable table.** Each row has an enable checkbox, a **Variable** name, an **Initial value**, a **Current value**, a secret toggle, and a delete button. Initial and current values are stored separately — a common pattern is a shared initial value with a per-session current value. Click **Add Variable** to add a row. Edits save automatically; there is no Save button.

## Global variables

Globals are variables available in every environment, used as a fallback when a key isn't set in the active environment. Open the **Globals** row at the top of the Environments panel. The globals table is simpler than an environment's — a single **Value** column instead of separate initial/current values. Globals also auto-save.

## Collection variables

A collection can carry its own variables, applied to every request inside it and sitting between environment and global in the [resolution order](#resolution-order). Edit them in the collection's settings tab — see [Collections](11-collections.md#collection-settings).

## Secret variables

Environment, global, and collection variables can each be marked **secret** with the lock toggle. A secret variable is:

- **Masked in the UI** — shown as dots until you reveal it with the eye toggle.
- **Excluded from exports and from Cloud Sync** by default (its value is encrypted if synced; blanked if shared). See [Cloud accounts](16-cloud-accounts.md).

Secrets still resolve to their real value at send time — masking is only about what's shown and shared.

> **Warning:** If your operating system's keychain is unavailable, a yellow banner warns `OS keychain unavailable — secret values are stored unencrypted.` On such a machine, secret values sit in the local database in plain text.

## Importing variables

The **Import** button in the Environments panel reads a Postman export (`.json`) and auto-detects its kind:

- A Postman **environment** file creates a new environment.
- A Postman **globals** file **merges** into your existing globals — matching keys update, new keys are appended.

A toast confirms how many variables were imported.

## Dynamic variables

Dynamic tokens generate a fresh value each time they appear, resolved at send time. Write them like any variable, for example `{{$guid}}` or `{{$timestamp}}`.

| Token | Produces |
|---|---|
| `{{$guid}}`, `{{$randomUUID}}` | A UUID |
| `{{$timestamp}}` | A Unix timestamp |
| `{{$isoTimestamp}}` | An ISO 8601 timestamp |
| `{{$randomDatePast}}`, `{{$randomDateFuture}}` | A random past / future date |
| `{{$randomInt}}` | A random integer |
| `{{$randomBoolean}}` | `true` or `false` |
| `{{$randomFirstName}}`, `{{$randomLastName}}`, `{{$randomFullName}}` | A random name |
| `{{$randomUserName}}`, `{{$randomEmail}}` | A random username / email |
| `{{$randomPhoneNumber}}` | A random phone number |
| `{{$randomUrl}}`, `{{$randomIP}}`, `{{$randomIPV6}}` | A random URL / IP address |
| `{{$randomColor}}`, `{{$randomHexColor}}` | A random color / hex color |
| `{{$randomWord}}`, `{{$randomWords}}` | A random word / words |
| `{{$randomCompanyName}}` | A random company name |

---

**See also:** [Scripts and tests](08-scripts-and-tests.md) · [Collections](11-collections.md) · [Cloud accounts](16-cloud-accounts.md) · [Sending requests](03-sending-requests.md)

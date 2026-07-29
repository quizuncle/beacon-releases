# Beacon User Guide

Beacon is a keyboard-first, local-first desktop API client — a Postman alternative for composing, sending, and testing HTTP and WebSocket requests. Everything you create lives in a local SQLite database on your machine; nothing leaves your computer unless you turn on Cloud Sync. This guide covers the app end to end, from your first request to advanced flows, load tests, and cloud accounts.

## Feature map

### Getting oriented
| Chapter | What it covers |
|---|---|
| [Getting started](01-getting-started.md) | Installing Beacon, first launch, and your first request |
| [Interface tour](02-interface-tour.md) | The window anatomy: Toolbar, Omnibox, Activity Rail, Peek panel, tabs, and Status strip |

### Building requests
| Chapter | What it covers |
|---|---|
| [Sending requests](03-sending-requests.md) | The Omnibox, methods, and sending a request |
| [Request body](04-request-body.md) | JSON, form-data, urlencoded, and raw bodies |
| [Params and headers](05-params-and-headers.md) | Query parameters and request headers |
| [Authorization](06-authorization.md) | Bearer, Basic, API Key, and other auth types |
| [Variables and environments](07-variables-and-environments.md) | `{{variables}}`, environments, and globals |
| [Scripts and tests](08-scripts-and-tests.md) | Pre-request scripts, test scripts, and the `pm` object |

### Working with responses
| Chapter | What it covers |
|---|---|
| [Responses](09-responses.md) | Reading status, body, headers, cookies, and tests |
| [Living Response](10-living-response.md) | The live, evolving response view |

### Organizing
| Chapter | What it covers |
|---|---|
| [Collections](11-collections.md) | Grouping saved requests into collections and folders |
| [History and cookies](17-history-and-cookies.md) | Request history and the cookie jar |

### Advanced
| Chapter | What it covers |
|---|---|
| [Collection runner](12-collection-runner.md) | Running a whole collection in sequence |
| [Flows](13-flows.md) | Chaining requests visually on a canvas |
| [Load testing](14-load-testing.md) | Firing a request concurrently to measure latency and throughput |
| [Mock, WebSocket, and monitors](15-mock-websocket-monitors.md) | Local mock server, WebSocket client, and scheduled monitors |

### Cloud
| Chapter | What it covers |
|---|---|
| [Cloud accounts](16-cloud-accounts.md) | Signing in, Cloud Sync, and encryption passphrases |

### Reference
| Chapter | What it covers |
|---|---|
| [Settings](18-settings.md) | Every setting across all six tabs, plus the in-app updater |
| [Keyboard shortcuts](19-keyboard-shortcuts.md) | The complete shortcut reference |

## Find it fast

| I want to… | Go to |
|---|---|
| Install Beacon and send my first request | [Getting started](01-getting-started.md) |
| Learn what every part of the window does | [Interface tour](02-interface-tour.md) |
| Send a POST request with a JSON body | [Request body](04-request-body.md) |
| Add an auth token to a request | [Authorization](06-authorization.md) |
| Reuse a base URL or token across requests | [Variables and environments](07-variables-and-environments.md) |
| Write a test that checks the response | [Scripts and tests](08-scripts-and-tests.md) |
| Find a request I sent earlier | [History and cookies](17-history-and-cookies.md) |
| Run every request in a collection at once | [Collection runner](12-collection-runner.md) |
| Chain one request's output into the next | [Flows](13-flows.md) |
| Sync my work across machines | [Cloud accounts](16-cloud-accounts.md) |
| Change the timeout, proxy, or theme | [Settings](18-settings.md) |
| See every keyboard shortcut | [Keyboard shortcuts](19-keyboard-shortcuts.md) |

## Conventions used in this guide

- Keyboard shortcuts are written with `⌘` (for example `⌘↵`). On Windows and Linux, use `Ctrl` wherever you see `⌘`.
- Exact UI labels — button text, tooltips, menu items, field placeholders, and setting names — are shown in `code font`.
- This guide is text-only. The UI evolves, so layouts are described in words rather than screenshots.

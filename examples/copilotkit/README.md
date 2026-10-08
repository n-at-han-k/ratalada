# copilotkit

A [CopilotKit](https://github.com/CopilotKit/CopilotKit) copilot in a ratalada
app, with **no Node runtime**. CopilotKit ships its runtime as a Node service,
but the protocol between it and the React client — [AG-UI](https://github.com/ag-ui-protocol):
an SSE event stream plus client-tool round-trips — has a Ruby server
implementation in the [`ag-ui`](https://rubygems.org/gems/ag-ui) gem. So this
app *is* the runtime: one process, one deploy.

```bash
nix develop
export OPENROUTER_API_KEY=sk-or-...   # no key: the launcher stays hidden
bin/dev                               # falcon on :9292, vite on :3037
```

Then open the chat and ask it to *"add buy cement, then mark it done"*.

## The two halves

**`copilot.rb`** — the server. `Copilot::Mount` is the first middleware in
`server.rb`: it hands `/api/copilotkit` to the AG-UI rack app (which serves
`/info`, `/agent/:id/run`, `/connect`, `/stop`) and lets everything else fall
through to the router. A run's SSE stream passes through untouched, because
this is one rack app in front of another. One turn is a plain
[brute](https://rubygems.org/gems/brute) pipeline: system prompt + the page's
context, the tool loop, a step cap, and an OpenRouter terminal at the bottom --
the house one, vendored at `lib/ag_ui/terminals/open_router.rb` from
`~/agents`, rather than the `ruby_llm` terminal the gem ships.

**`app/index.rb`** — the page. An ordinary ratalada page (a server-rendered
list, a form posting to `app/items.rb`, buttons patching `app/items/[id].rb`)
plus two hooks:

- `useAgentContext` shares the page's state with the model. It is the only
  thing the agent knows — it cannot see the DOM.
- `useFrontendTool` gives the model something to do. **The handler runs in the
  browser**, so it makes the same `router.post` / `router.patch` request a
  click makes, with the user's own session. There is no agent-only endpoint and
  no second copy of the rules on the server: anything the agent can do is
  something the UI could already do.

Both are scoped to the React tree, so the agent's toolset is always exactly
what the mounted page can do — which is why the provider is mounted at the
**Inertia root**, around `<App />` in `frontend/entrypoints/application.tsx`
(`frontend/components/copilot-chat.tsx`). Mount it inside a layout or a shell
component instead and no page can register anything: only what renders inside
the provider may call the hooks. Register from a page for page-scoped tools,
from the shell for app-wide ones.

The provider renders whether or not a key is set — a hook cannot be skipped,
so dropping it would break every page that registers a tool, not just the chat.
Only the launcher is conditional.

## WebMCP

Every tool here also carries `webmcp`, which mirrors it onto
`document.modelContext` — the browser's own tool registry. A browser agent or
extension that is **not** our chat can then discover the tool by name and
schema and call the same handler, instead of driving the DOM and hoping. It
needs nothing on the server; the handler already runs in the page.

```ts
useFrontendTool({
  name: "listItems",
  description: "List the items, with their ids and whether each is done.",
  parameters: z.object({}),
  webmcp: { annotations: { readOnlyHint: true } },   // or just `webmcp: true`
  handler: async () => JSON.stringify(items),
})
```

`annotations` is what such an agent reads before deciding to call:
`readOnlyHint` for a tool that only looks, `untrustedContentHint` when the
result carries user-generated or external content. Getting `readOnlyHint`
wrong is the one that bites — an agent may treat a read as safe to try
unprompted.

`listItems` exists for exactly this reason: our own chat reads the list from
`useAgentContext`, but a WebMCP agent gets the tools and nothing else, so
without it that agent could change the list without ever being able to read
it.

## Config

| env | default | |
|---|---|---|
| `OPENROUTER_API_KEY` | — | required; absent, the mount answers 503 and the page hides the launcher |
| `COPILOT_MODEL` | `anthropic/claude-sonnet-4.5` | an OpenRouter model id |
| `COPILOT_DB` | `config/database.sqlite` | the list's SQLite file |

`bin/test` covers both halves: the item routes the tools drive, the `/info`
descriptor the client boots from, the 503 when no key is set, and that a
lookalike path (`/api/copilotkitten`) still belongs to the router.

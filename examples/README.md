# Examples

Each example is a complete server. From the repo root:

```bash
bundle install
bundle exec ruby examples/puma.rb      # built-in router on puma
bundle exec ruby examples/falcon.rb    # built-in router on falcon
```

The Sinatra and Grape DSLs live in separate adapter gems whose dependencies
conflict, so each has its own bundle under `gemfiles/`. Run those examples
through the matching gemfile:

```bash
BUNDLE_GEMFILE=gemfiles/sinatra.gemfile bundle exec ruby examples/sinatra.rb   # sinatra DSL on falcon
BUNDLE_GEMFILE=gemfiles/grape.gemfile   bundle exec ruby examples/grape.rb     # grape DSL on falcon
```

Some examples bring their own dependencies (via an inline gemfile) instead of
the repo bundle — run them with plain `ruby`:

```bash
ruby examples/brute.rb                 # a brute coding agent served over HTTP
ruby examples/mcp.rb                   # an MCP server over Streamable HTTP on falcon
```

It expects a [brute](https://github.com/general-intelligence-systems/brute) checkout at
`~/brute/brute` (override with `BRUTE_PATH`) and an LLM — a local Ollama by
default (`BRUTE_PROVIDER` / `BRUTE_MODEL` to change). Ask it things:

```bash
curl -d 'What files are in the current directory?' http://localhost:9292/ask
```

All of them listen on `http://127.0.0.1:9292` (override with `HOST`/`PORT`
env vars, or `Server.run(host:, port:)`).

## How it works

`require "ratalada/puma"` or `require "ratalada/falcon"` picks the server
backend and defines the top-level `Server` constant.

With the built-in router, the `Server.run` block receives each request and
returns a handler for it. A request pattern-matches as `[verb, path]`, and a
handler can be:

- a `String` — sent as a `200 text/plain` response
- a callable — called with the request, its result handled the same way
- a `[status, headers, body]` triplet — used as-is
- nothing (`nil` or a fall-through `case ... in`) — a `404`

```ruby
require "ratalada/puma"

Server.run do |request|
  case request
  in ["GET", "/"] then "ok"
  end
end
```

`require "ratalada/sinatra"` swaps the block DSL for Sinatra, and
`require "ratalada/grape"` for Grape: the block is class-evaluated into an
anonymous Sinatra app or Grape::API, running on whichever backend you required.

Those two frontends ship as separate gems — `ratalada-sinatra` and
`ratalada-grape` — because their dependencies conflict (Grape needs
`mustermann` 4, Sinatra needs `mustermann` 3). You install the adapter gem but
still `require "ratalada/sinatra"` / `require "ratalada/grape"`: each ships its
file under the shared `ratalada/` namespace on the load path, so the require
path never names the gem.

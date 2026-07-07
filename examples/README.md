# Examples

Each example is a complete server. From the repo root:

```bash
bundle install
bundle exec ruby examples/puma.rb      # built-in router on puma
bundle exec ruby examples/falcon.rb    # built-in router on falcon
bundle exec ruby examples/sinatra.rb   # sinatra DSL on falcon
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

`require "ratalada/sinatra"` swaps the block DSL for Sinatra: the block is
class-evaluated into an anonymous Sinatra app, running on whichever backend
you required.

# ratalada

![ratalada](media/character.png)

A DSL for running Rack servers as easily as you can in JavaScript.

```ruby
require "ratalada/puma"

Server.run do |request|
  case request
  in ["GET", "/"] then "hello\n"
  end
end
```

That's a whole app. Run the file, and it's listening on `http://127.0.0.1:9292`.

## Installation

```bash
gem install ratalada puma      # core + a server to run on
```

The core `ratalada` gem is the router, the backends, and the DSL. It has no
runtime dependencies of its own — install whichever server you run on (`puma`
or `falcon`).

The Sinatra and Grape DSLs are optional add-ons, each its own gem:

```bash
gem install ratalada-sinatra   # enables require "ratalada/sinatra"
gem install ratalada-grape     # enables require "ratalada/grape"
```

They ship separately because their dependencies conflict (Grape needs
`mustermann` 4, Sinatra needs `mustermann` 3), so bundling both into `ratalada`
would force you to pick one. **The require path is the same either way**:
install `ratalada-grape`, then `require "ratalada/grape"`. The adapter file
lives under the shared `ratalada/` namespace on the load path, so the `require`
never names the gem — only the file you want.

## Usage

Requiring a backend picks the server and defines the top-level `Server`
constant:

```ruby
require "ratalada/puma"    # or
require "ratalada/falcon"
```

The `Server.run` block is a router: it receives each request and returns a
handler for it. A request pattern-matches as `[verb, path]` (or by keys:
`in {verb:, path:, query:}`), and a handler can be:

- a `String` — sent as a `200 text/plain` response
- a callable — called with the request, its result handled the same way
- a `[status, headers, body]` triplet — used as-is
- nothing (`nil` or a fall-through `case ... in`) — a `404`

```ruby
require "ratalada/falcon"

Server.run do |request|
  case request
  in ["GET", "/"]      then "hello\n"
  in ["GET", "/up"]    then "ok\n"
  in ["POST", "/echo"] then ->(req) { [200, { "content-type" => "text/plain" }, req.body] }
  end
end
```

Prefer Sinatra's routing? Install `ratalada-sinatra`, then swap the frontend
and keep whichever backend you required:

```ruby
require "ratalada/falcon"
require "ratalada/sinatra"

Server.run do
  get "/" do
    "hello\n"
  end
end
```

Or Grape, from `ratalada-grape`:

```ruby
require "ratalada/falcon"
require "ratalada/grape"

Server.run do
  format :txt

  get "/" do
    "hello\n"
  end
end
```

Requiring a frontend only changes how the block builds the app, not which
server runs it. Each of these adapters is a separate gem (`ratalada-sinatra`,
`ratalada-grape`), but the `require "ratalada/<name>"` line is all your code
ever sees.

The host and port default to `127.0.0.1:9292`, configurable via the `HOST` and
`PORT` environment variables or explicitly:

```ruby
Server.run(host: "0.0.0.0", port: 3000) do |request|
  # ...
end
```

Like node, one process is one event loop: plenty for IO-bound work, but only
one core of Ruby. To use more cores, `count:` (or the `COUNT` environment
variable) runs that many forked workers accepting from a shared socket — the
equivalent of node's `cluster` module, and with the same contract: each worker
has its own state, so anything shared between requests (sessions, caches)
needs an external store or `count: 1` (the default).

```ruby
Server.run(count: 4) do |request|
  # ...
end
```

Currently only the falcon backend forks workers; the puma backend warns and
ignores `count:`.

See [examples/](examples/) for complete runnable servers.

## Development

```bash
bin/setup     # install dependencies
bin/test      # run the tests
bin/console   # interactive prompt
```

## License

[MIT](LICENSE)

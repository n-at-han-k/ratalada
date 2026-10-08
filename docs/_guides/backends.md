---
layout: default
title: Backends
nav_order: 2
description: Pick a server with a require, and configure host and port.
---

# Backends

A backend is the server that runs your app. Requiring one selects it and defines the top-level `Server` constant:

```ruby
require "ratalada/puma"     # threaded — Puma
require "ratalada/falcon"   # fiber-based — Falcon, supervised workers
require "ratalada/async"    # fiber-based — a bare Async::HTTP::Server
require "ratalada/webrick"  # stdlib WEBrick, via rackup's handler
```

`falcon` and `async` are the same server; `ratalada/falcon` adds the process
container `falcon host` runs (`count:` workers, restarts, signal handling),
`ratalada/async` is one server in this process and ignores `count:`. WEBrick
is single process too — handy for development, not for production.

The `Server.run` block is identical either way; swapping servers is a one-line change. If you require both, the last require wins.

## The async backend routes in Protocol::HTTP

`Async::HTTP::Server` does not speak rack — falcon reaches it through
`Protocol::Rack::Adapter`. On `ratalada/async` there is nothing to reach
through, so requiring it also swaps the default router for
`Ratalada::Frontends::ProtocolRoutes`, which talks to the server directly:

```ruby
require "ratalada/async"

Server.run do |request|
  case request
  in ["GET", "/"]      then "hello\n"
  in ["GET", "/hi"]    then ->(req) { "hi #{req.params["name"]}\n" }
  in ["POST", "/echo"] then ->(req) { req.body }
  end
end
```

`request` here *is* the server's `Protocol::HTTP::Request` — there is no
wrapper standing in for it. `ratalada/protocol_http_ext` teaches that class
the patterns, so the ones [Routing](routing.html) documents work unchanged.
Three things to know:

- `request.body` is the body as it arrived, a
  `Protocol::HTTP::Body::Readable`. Return it and it becomes the response body
  — an echo or a proxy with nothing buffered in between. `request.body.join`
  reads it whole as a String.
- `request.path` is the raw target, `"/users/1?a=b"`, as Protocol::HTTP means
  it. The patterns match the path with the query split off, so `"/hi"` matches
  a request for `"/hi?name=x"`, and the query is `request.query` /
  `request.params`.
- there is no `Rack::Request` underneath, so no cookies, no session, no
  form-body params and no `Rack::Utils` helpers in block scope.

`Server.use` works, and here it is Protocol::HTTP middleware — `new(delegate)`
answering `call(request)`:

```ruby
class Timer < Protocol::HTTP::Middleware
  def call(request)
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    super.tap do |response|
      response.headers["x-ms"] = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started) * 1000).round(2).to_s
    end
  end
end

Server.use(Timer).run do |request|
  # ...
end
```

It is the same `new(delegate)` chain `Server.use` builds everywhere else, so
there is no adapter between your middleware and the server. Rack middleware
belongs to a rack frontend — to use it, and to get the rack request sugar
back, put the rack router in and the backend wraps the lot in the adapter as
before:

```ruby
require "ratalada/async"
Ratalada.config.frontend = Ratalada::Frontends::Routes
```

Requiring a frontend does this for you — only the *default* is replaced, so
`require "ratalada/sinatra"` either side of `require "ratalada/async"` keeps
Sinatra, adapter and all.

The backend gems themselves are not dependencies of ratalada — add `puma`, `falcon`, `async-http` or `webrick` + `rackup` to your own Gemfile.

## Host and port

Everything defaults to `127.0.0.1:9292`. Override with keyword arguments:

```ruby
Server.run(host: "0.0.0.0", port: 3000) do |request|
  # ...
end
```

or with environment variables, which set the defaults:

```bash
HOST=0.0.0.0 PORT=3000 ruby server.rb
```

## No backend?

Calling `Server.run` with only `require "ratalada"` raises `Ratalada::NoBackendError` telling you to require one — the core gem never guesses which server you meant.

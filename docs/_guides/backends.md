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

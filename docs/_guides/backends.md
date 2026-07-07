---
layout: default
title: Backends
nav_order: 2
description: Pick puma or falcon with a require, and configure host and port.
---

# Backends

A backend is the server that runs your app. Requiring one selects it and defines the top-level `Server` constant:

```ruby
require "ratalada/puma"    # threaded — Puma
require "ratalada/falcon"  # fiber-based — Falcon
```

The `Server.run` block is identical either way; swapping servers is a one-line change. If you require both, the last require wins.

The backend gems themselves are not dependencies of ratalada — add `puma` or `falcon` to your own Gemfile.

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

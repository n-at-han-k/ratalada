---
layout: default
title: Routing
nav_order: 1
description: The Server.run block is a router — pattern-match requests and return handlers.
---

# Routing

With the default frontend, the `Server.run` block is a router: it is called with each request and returns a handler for it.

```ruby
require "ratalada/puma"

Server.run do |request|
  case request
  in ["GET", "/"]      then "hello\n"
  in ["GET", "/up"]    then "ok\n"
  in ["POST", "/echo"] then ->(req) { [200, { "content-type" => "text/plain" }, req.body] }
  end
end
```

## Pattern matching requests

A `Ratalada::Request` deconstructs two ways for `case ... in`:

```ruby
# As an array — [verb, path]:
in ["GET", "/"]
in ["POST", _]
in [_, "/health"]

# By keys — verb, path, query, env:
in { verb: "GET", path: "/users", query: }
```

The request also exposes the underlying Rack env (`request.env`), the request body (`request.body`), and the raw query string (`request.query`).

## What a handler can be

The router's return value is handled by type:

| Handler | Response |
|---|---|
| `String` | `200 text/plain` with the string as body |
| callable (`Proc`, `Method`) | called with the request; its result handled the same way |
| `[status, headers, body]` | used as-is (a `String` body is wrapped for Rack) |
| `nil` / no match | `404 not found` |

A fall-through `case ... in` normally raises `NoMatchingPatternError`; ratalada rescues it and answers `404`, so you don't need an `else` branch.

## Callables as handlers

Because a handler can be any callable, routes can point at lambdas, method references, or anything else that responds to `call`:

```ruby
HEALTH = ->(req) { "ok\n" }

def greet(req)
  "hello #{req.query.delete_prefix("name=")}\n"
end

Server.run do |request|
  case request
  in ["GET", "/up"]    then HEALTH
  in ["GET", "/greet"] then method(:greet)
  in ["GET", "/"]      then "hello\n"
  end
end
```

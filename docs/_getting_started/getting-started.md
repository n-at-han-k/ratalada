---
layout: default
title: Getting Started
nav_order: 1
description: Install ratalada, pick a server, and run your first app.
---

# Getting Started

## Installation

Ratalada has no runtime dependencies of its own — install it alongside whichever server you want to run on:

```ruby
# Gemfile
gem "ratalada"
gem "puma"     # or "falcon"
```

```bash
bundle install
```

Or without bundler:

```bash
gem install ratalada puma
```

## Your first server

```ruby
# server.rb
require "ratalada/puma"

Server.run do |request|
  case request
  in ["GET", "/"] then "hello\n"
  end
end
```

```bash
ruby server.rb
# ratalada: puma listening on http://127.0.0.1:9292
```

```bash
curl http://localhost:9292/
# hello
```

Requiring `ratalada/puma` did two things: picked puma as the backend and defined the top-level `Server` constant. The block is your router — it receives every request and returns a handler for it. Anything the block doesn't match is a `404`, including a fall-through `case ... in`.

## Where next

- The [Routing guide]({% link _guides/routing.md %}) covers everything a handler can be and how requests pattern-match.
- The [Backends guide]({% link _guides/backends.md %}) covers puma vs falcon and host/port configuration.
- Prefer Sinatra's `get "/" do ... end`? See the [Sinatra frontend]({% link _guides/sinatra.md %}).

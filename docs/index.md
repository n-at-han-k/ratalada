---
layout: default
title: ratalada
nav_order: 1
description: 'A DSL for running Rack servers as easily as you can in JavaScript. Pattern-match routes, pick a backend with a require, and run.'
permalink: /
---

# ratalada

A DSL for running Rack servers as easily as you can in JavaScript — pattern-match your routes, pick a backend with a `require`, and run.
{: .fs-6 .fw-300 }

<div class="hero-actions">
  <a href="{% link _getting_started/getting-started.md %}" class="btn btn-primary fs-5 mb-4 mb-md-0 mr-2">Get started</a>
  <a href="https://github.com/n-at-han-k/ratalada" class="btn fs-5 mb-4 mb-md-0 mr-2">GitHub</a>
</div>

In Node you can stand up a server in three lines. In Ruby the same thing usually means a framework, a config file, and a `rackup` invocation. Ratalada closes that gap:

```ruby
require "ratalada/puma"

Server.run do |request|
  case request
  in ["GET", "/"] then "hello\n"
  end
end
```

That's a whole app. Run the file, and it's listening on `http://127.0.0.1:9292`.

## How it fits together

Ratalada is two small, swappable pieces:

- **Backends** run the Rack app. `require "ratalada/puma"` or `require "ratalada/falcon"` picks the server and defines the top-level `Server` constant.
- **Frontends** turn your `Server.run` block into a Rack app. The default is a [pattern-matching router]({% link _guides/routing.md %}); `require "ratalada/sinatra"` or `require "ratalada/grape"` swaps in [Sinatra's]({% link _guides/sinatra.md %}) or [Grape's]({% link _guides/grape.md %}) DSL on whichever backend you chose.

The core gem has no runtime dependencies of its own — install whichever server you actually run on. The Sinatra and Grape adapters are separate gems (`ratalada-sinatra`, `ratalada-grape`), but you install the gem and still `require "ratalada/sinatra"` — see [require semantics]({% link _guides/frontends.md %}).

## What's here

- **Start Here** — [install ratalada and run your first server]({% link _getting_started/getting-started.md %}).
- **Guides** — the [router DSL]({% link _guides/routing.md %}) and its handler forms, [backends and configuration]({% link _guides/backends.md %}), how [frontends are packaged]({% link _guides/frontends.md %}), and the [Sinatra]({% link _guides/sinatra.md %}) and [Grape]({% link _guides/grape.md %}) frontends.
- **Examples** — [complete runnable servers]({% link _examples/examples.md %}) straight from the repo.

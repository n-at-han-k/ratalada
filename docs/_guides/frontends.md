---
layout: default
title: Frontends & require semantics
nav_order: 3
description: How the router, Sinatra, and Grape frontends are packaged, and why the require path never names the gem.
---

# Frontends & require semantics

A **frontend** turns your `Server.run` block into a Rack app. Ratalada ships three:

| Frontend | Require | Gem |
| --- | --- | --- |
| Pattern-matching router (default) | *(none — built in)* | `ratalada` |
| Sinatra DSL | `require "ratalada/sinatra"` | `ratalada-sinatra` |
| Grape DSL | `require "ratalada/grape"` | `ratalada-grape` |

The router is part of the core gem, so it's there as soon as you require a backend. The Sinatra and Grape adapters are separate gems you install when you want them.

## Install the gem, require the path

The one thing to internalise: **the gem you install and the path you require are not the same string.**

```ruby
# Gemfile
gem "ratalada"
gem "ratalada-grape"   # install the adapter gem
gem "falcon"
```

```ruby
# your app
require "ratalada/falcon"
require "ratalada/grape"   # require the file, not the gem
```

`ratalada-grape` ships a single file, `lib/ratalada/grape.rb`. Because it uses the same `lib/` layout as the core gem, that file lands under the shared `ratalada/` namespace on the load path — so `require "ratalada/grape"` finds it no matter which gem provided it. Your code only ever names files under `ratalada/`; it never mentions `ratalada-grape`.

## Why the adapters are separate gems

Grape depends on `mustermann` 4; Sinatra depends on `mustermann` 3. Those can't coexist in one dependency graph, so they can't both be dependencies of `ratalada`. Splitting each adapter into its own gem keeps its framework — and that framework's version pins — out of the core gem and out of the other adapter's way. You install only the ones you use, and each brings exactly the dependencies it needs.

The core `ratalada` gem therefore stays dependency-free: it's the DSL, the router, and the backends, nothing more.

## Frontends and backends are independent

Requiring a frontend changes how the block builds the app; requiring a backend changes which server runs it. They compose freely:

```ruby
require "ratalada/puma"     # or falcon
require "ratalada/sinatra"  # or grape, or nothing for the router
```

See the [Sinatra frontend]({% link _guides/sinatra.md %}) and [Grape frontend]({% link _guides/grape.md %}) guides for each DSL.

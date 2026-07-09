---
layout: default
title: Grape frontend
nav_order: 5
description: Swap the router DSL for Grape's, on whichever backend you required.
---

# Grape frontend

If you'd rather build a Grape API than pattern-match, swap the frontend:

```ruby
require "ratalada/falcon"   # any backend
require "ratalada/grape"    # swap the DSL

Server.run do
  format :txt

  get "/" do
    "hello\n"
  end

  get "/greet/:name" do
    "hello #{params[:name]}\n"
  end
end
```

The `Server.run` block is class-evaluated into an anonymous `Grape::API`, so the whole Grape DSL works — `get`/`post`/`put`/`delete`, `resource`, `params`, `route_param`, mounting, all of it. A `Grape::API` subclass is itself the Rack app, and ratalada hands it straight to the backend you required.

The Grape frontend is its own gem, `ratalada-grape` (it pulls in `grape` for you):

```ruby
gem "ratalada"
gem "ratalada-grape"
gem "falcon"
```

Note the require path doesn't change: you install `ratalada-grape`, but you still `require "ratalada/grape"`. The adapter ships under the shared `ratalada/` namespace on the load path, so your code never names the gem — see [require semantics]({% link _guides/frontends.md %}) for why the adapters are split out this way.

Backends and frontends are independent: requiring `ratalada/grape` changes how the block builds the app, not which server runs it.

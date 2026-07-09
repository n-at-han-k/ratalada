---
layout: default
title: Sinatra frontend
nav_order: 4
description: Swap the router DSL for Sinatra's, on whichever backend you required.
---

# Sinatra frontend

If you'd rather write Sinatra routes than pattern-match, swap the frontend:

```ruby
require "ratalada/falcon"   # any backend
require "ratalada/sinatra"  # swap the DSL

Server.run do
  get "/" do
    "hello\n"
  end

  get "/greet/:name" do
    "hello #{params[:name]}\n"
  end
end
```

The `Server.run` block is class-evaluated into an anonymous `Sinatra::Base` application, so the whole Sinatra DSL works — `get`/`post`/`put`/`delete`, `params`, `halt`, filters, helpers, all of it. Ratalada just runs the resulting app on the backend you required.

The Sinatra frontend is its own gem, `ratalada-sinatra` (it pulls in `sinatra` for you):

```ruby
gem "ratalada"
gem "ratalada-sinatra"
gem "falcon"
```

Note the require path doesn't change: you install `ratalada-sinatra`, but you still `require "ratalada/sinatra"`. The adapter ships under the shared `ratalada/` namespace on the load path, so your code never names the gem — see [require semantics]({% link _guides/frontends.md %}) for why the adapters are split out this way.

Backends and frontends are independent: requiring `ratalada/sinatra` changes how the block builds the app, not which server runs it.

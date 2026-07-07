---
layout: default
title: Sinatra frontend
nav_order: 3
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

Add `sinatra` to your Gemfile alongside your server:

```ruby
gem "ratalada"
gem "falcon"
gem "sinatra"
```

Backends and frontends are independent: requiring `ratalada/sinatra` changes how the block builds the app, not which server runs it.

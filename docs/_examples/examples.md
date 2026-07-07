---
layout: default
title: Examples
nav_order: 1
description: Complete runnable servers from the repo.
---

# Examples

Complete servers live in [examples/](https://github.com/n-at-han-k/ratalada/tree/main/examples) in the repo. From a checkout:

```bash
bundle install
bundle exec ruby examples/puma.rb
bundle exec ruby examples/falcon.rb
bundle exec ruby examples/sinatra.rb
```

All of them listen on `http://127.0.0.1:9292`.

## Router on puma

```ruby
require "ratalada/puma"

Server.run do |request|
  case request
  in ["GET", "/"]      then "hello from puma\n"
  in ["GET", "/up"]    then "ok\n"
  in ["POST", "/echo"] then ->(req) { [200, { "content-type" => "text/plain" }, req.body] }
  end
end
```

```bash
curl http://localhost:9292/
curl -d "hello" http://localhost:9292/echo
```

## Router on falcon

```ruby
require "ratalada/falcon"

Server.run do |request|
  case request
  in ["GET", "/"]      then "hello from falcon\n"
  in ["GET", "/up"]    then "ok\n"
  in ["GET", "/greet"] then ->(req) { "hello #{req.query.delete_prefix("name=")}\n" }
  end
end
```

```bash
curl "http://localhost:9292/greet?name=world"
```

## Sinatra on falcon

```ruby
require "ratalada/falcon"
require "ratalada/sinatra"

Server.run do
  get "/" do
    "hello from sinatra on falcon\n"
  end

  get "/greet/:name" do
    "hello #{params[:name]}\n"
  end
end
```

```bash
curl http://localhost:9292/greet/world
```

# frozen_string_literal: true

require "ratalada/falcon"
require "ratalada/builder"
require "ratalada/contrib/vite"
require "ratalada/contrib/inertia"
require "ratalada/contrib/router/file_based/sinatra_adapter"

# app/ is the routing table: app/index.rb serves GET /, app/settings.rb serves
# GET /settings, app/teams/[team]/index.rb serves GET /teams/:team. The adapter
# builds each file into its own Sinatra app, `app/_layout.rb` first — which is
# where `enable :sessions` and the Vite and Inertia helpers are set up, so every
# route file has them.
Server
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  .use(Ratalada::Contrib::Inertia::Middleware)
  .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
  .run do
    run Ratalada::Contrib::Router::FileBased::SinatraAdapter.build(
      File.expand_path("app", __dir__),
    )
  end

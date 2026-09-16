# frozen_string_literal: true

require "ratalada/falcon"
require "ratalada/contrib/vite"
require "ratalada/contrib/inertia"
require "ratalada/contrib/router/file_based/sinatra_adapter"

Server
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  .use(Ratalada::Contrib::Inertia::Middleware)
  .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
  .run do
    Ratalada::Contrib::Router::FileBased.mount(self, File.expand_path("app", __dir__))
  end

# frozen_string_literal: true

require "ratalada/falcon"
require "ratalada/builder"
require "ratalada/contrib/vite"
require "ratalada/contrib/inertia"

Server
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  .use(Ratalada::Contrib::Inertia::Middleware)
  .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
  .run do
    # should run the file based router
  end

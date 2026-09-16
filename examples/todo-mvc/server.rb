# frozen_string_literal: true

require "ratalada/falcon"
require "ratalada/sinatra"
require "ratalada/contrib/vite"
require "ratalada/contrib/inertia"

Server
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  .use(Ratalada::Contrib::Inertia::Middleware)
  .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
  .run do
    # session[:_inertia_errors] is where the render helpers keep validation
    # errors between the redirect and the page that shows them.
    enable :sessions

    helpers Ratalada::Contrib::Vite::TagHelpers
    helpers Ratalada::Contrib::Inertia::Helpers
  end

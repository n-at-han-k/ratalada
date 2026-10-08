# frozen_string_literal: true

require "extralite"

require_relative "copilot"

require "ratalada/falcon"
require "ratalada/contrib/vite"
require "ratalada/contrib/inertia"
require "ratalada/contrib/router/file_based/sinatra_adapter"

DB = Extralite::Database.new(
  File.expand_path(ENV.fetch("COPILOT_DB", "config/database.sqlite"), __dir__)
)

DB.execute(<<~SQL)
  create table if not exists items (
    id integer primary key,
    title text not null,
    done integer not null default 0
  )
SQL

# Every page carries it, so the copilot's launcher is present exactly when the
# server can actually answer (see frontend/components/copilot-chat.tsx).
Ratalada::Contrib::Inertia.share { { copilot: Copilot.enabled? } }

Server
  # /api/copilotkit -> the in-process AG-UI runtime (copilot.rb). FIRST in the
  # stack: a run is a long-lived SSE stream, not a page, so none of the Inertia
  # middleware below should touch it.
  .use(Copilot::Mount)
  .use(Ratalada::Contrib::Inertia::JsonParamsMiddleware)
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  .use(Ratalada::Contrib::Inertia::Middleware)
  .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
  .run do
    Ratalada::Contrib::Router::FileBased
      .mount(self, File.expand_path("app", __dir__))
  end

# frozen_string_literal: true

require "extralite"

require "ratalada/falcon"
require "ratalada/contrib/vite"
require "ratalada/contrib/inertia"
require "ratalada/contrib/router/file_based/sinatra_adapter"

DB = Extralite::Database.new(
  File.expand_path("config/database.sqlite", __dir__)
)

DB.execute(<<~SQL)
  create table if not exists tasks (
    id integer primary key,
    title text not null,
    done integer not null default 0
  )
SQL

Server
  .use(Ratalada::Contrib::Inertia::JsonParamsMiddleware)
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  .use(Ratalada::Contrib::Inertia::Middleware)
  .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
  .run do
    Ratalada::Contrib::Router::FileBased
      .mount(self, File.expand_path("app", __dir__))
  end

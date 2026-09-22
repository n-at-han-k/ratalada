# frozen_string_literal: true

# Swagger UI as a ratalada app. There is no API here and nothing generated:
# the document is read off disk and handed to the page, and the page is the
# fork under frontend/.

require "ratalada/falcon"
require "ratalada/contrib/vite"
require "ratalada/contrib/router/file_based/sinatra_adapter"

# The document this serves. Any OpenAPI or Swagger file will do -- the fork
# renders what it is given.
SCHEMA = ENV.fetch("SCHEMA") { File.expand_path("../forgejo.json", __dir__) }

unless File.exist?(SCHEMA)
  abort("no document at #{SCHEMA} -- point SCHEMA at one")
end

Server
  # Fronts the app with vite's dev server while `bin/vite dev` runs, and is a
  # pass-through otherwise.
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  .run do
    Ratalada::Contrib::Router::FileBased
      .mount(self, File.expand_path("app", __dir__))
  end

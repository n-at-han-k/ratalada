# frozen_string_literal: true

# Serves whatever generate.rb last wrote. Nothing here knows the API: the
# routing table is the file tree under app/, so regenerating from a changed
# document changes the routes without touching this file.

require "json"
require "yaml"

require "ratalada/falcon"
require "ratalada/contrib/vite"
require "ratalada/contrib/router/file_based/sinatra_adapter"

require_relative "config/rom"
require_relative "config/openapi_ruby"

APP = File.expand_path("app", __dir__)

unless Dir.exist?(APP)
  abort("nothing generated yet: ruby generate.rb forgejo.json .")
end

# The specs validate themselves against their own declarations; the running app
# validates against the document those declarations produced, which only exists
# once `rake openapi_ruby:generate` has written it. Installer is a no-op until
# then, and `Server` responds to #use like any other rack stack.
OpenapiRuby.configure do |config|
  config.request_validation = :enabled
  config.response_validation = :warn_only
end

# The Stack, not `Server` itself: `Server.use` RETURNS the chain it starts, so
# installing onto `Server` builds a stack nothing then runs -- and the
# middleware is silently absent.
stack = Ratalada::Server::Stack.new

# Fronts the app with vite's dev server while `bin/vite dev` runs, and is a
# pass-through otherwise. It goes on before the validator: the assets the index
# page loads are not in the document.
stack = stack.use(Ratalada::Contrib::Vite::DevServerProxy)

OpenapiRuby::Middleware::Installer.install!(stack, root: __dir__)

stack.run do
  Ratalada::Contrib::Router::FileBased.mount(self, APP)
end

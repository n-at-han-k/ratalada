# frozen_string_literal: true

# Sinatra only relaxes host authorization outside development, and rack-test
# sends `Host: example.org`.
ENV["APP_ENV"] ||= "test"

require "ratalada/sinatra"
require "ratalada/contrib/router/file_based/sinatra_adapter"

# The relations the pages read and write.
require_relative "../config/rom"

require_relative "../config/openapi_ruby"
require_relative "factories"
require "openapi_ruby/rspec"
require_relative "../lib/openapi_ruby_patches"

# The components, up front: a spec names `Schemas::Repository` while it is
# being loaded, so the class has to exist before RSpec reads the file.
OpenapiRuby::Components::Loader.new.load!

# The routes are the file tree, so the app under test is built from it --
# no server, no backend, just the rack app rack-test drives.
APP = Ratalada::Contrib::Router::FileBased.build(File.expand_path("../app", __dir__))

module AppUnderTest
  def app = APP
end

RSpec.configure do |config|
  config.include AppUnderTest, type: :openapi

  # Every example runs inside a transaction that is rolled back, so what a
  # factory builds is gone before the next one asks the same question.
  config.around do |example|
    ROM_CONFIG.gateways[:default].connection.transaction(rollback: :always) { example.run }
  end
end

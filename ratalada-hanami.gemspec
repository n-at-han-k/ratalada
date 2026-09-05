# frozen_string_literal: true

require_relative "lib/ratalada/hanami/version"

Gem::Specification.new do |spec|
  spec.name = "ratalada-hanami"
  spec.version = Ratalada::Hanami::VERSION
  spec.authors = ["Nathan K"]
  spec.email = ["nathankidd@hey.com"]

  spec.summary = "Hanami::API frontend adapter for ratalada."

  spec.description = <<~DESC
    Swaps ratalada's built-in router for the Hanami::API DSL: require this and
    the Server.run block is class-evaluated into an anonymous Hanami::API
    application.
  DESC

  spec.homepage = "https://github.com/n-at-han-k/ratalada"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  # Shares the lib/ tree with ratalada and the other adapters; ships only the
  # Hanami adapter file.
  spec.files = %w[
    lib/ratalada/hanami.rb
    lib/ratalada/hanami/version.rb
    LICENSE
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency "ratalada", "~> 1.0"
  spec.add_dependency "hanami-api"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "lefthook", "~> 2.1"
end

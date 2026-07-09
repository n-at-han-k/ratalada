# frozen_string_literal: true

require_relative "lib/ratalada/version"

Gem::Specification.new do |spec|
  spec.name = "ratalada-sinatra"
  spec.version = Ratalada::VERSION
  spec.authors = ["Nathan K"]
  spec.email = ["nathankidd@hey.com"]

  spec.summary = "Sinatra frontend adapter for ratalada."

  spec.description = <<~DESC
    Swaps ratalada's built-in router for a Sinatra DSL: require this and the
    Server.run block is class-evaluated into an anonymous Sinatra application.
  DESC

  spec.homepage = "https://github.com/n-at-han-k/ratalada"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  # Shares the lib/ tree with ratalada and ratalada-grape; ships only the
  # Sinatra adapter file.
  spec.files = %w[
    lib/ratalada/sinatra.rb
    LICENSE
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency "ratalada", Ratalada::VERSION
  spec.add_dependency "sinatra"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end

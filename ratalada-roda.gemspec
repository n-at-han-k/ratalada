# frozen_string_literal: true

require_relative "lib/ratalada/roda/version"

Gem::Specification.new do |spec|
  spec.name = "ratalada-roda"
  spec.version = Ratalada::Roda::VERSION
  spec.authors = ["Nathan K"]
  spec.email = ["nathankidd@hey.com"]

  spec.summary = "Roda frontend adapter for ratalada."

  spec.description = <<~DESC
    Swaps ratalada's built-in router for Roda's routing tree: require this and
    the Server.run block is class-evaluated into an anonymous Roda application.
  DESC

  spec.homepage = "https://github.com/n-at-han-k/ratalada"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  # Shares the lib/ tree with ratalada and the other adapters; ships only the
  # Roda adapter file.
  spec.files = %w[
    lib/ratalada/roda.rb
    lib/ratalada/roda/version.rb
    LICENSE
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency "ratalada", "~> 1.0"
  spec.add_dependency "roda"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "lefthook", "~> 2.1"
end

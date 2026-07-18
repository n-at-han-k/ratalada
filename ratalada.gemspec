# frozen_string_literal: true

require_relative "lib/ratalada/version"

Gem::Specification.new do |spec|
  spec.name = "ratalada"
  spec.version = Ratalada::VERSION
  spec.authors = ["Nathan K"]
  spec.email = ["nathankidd@hey.com"]

  spec.summary = "DSL for running rack servers as easily as you can in javascript."

  spec.description = <<~DESC
    DSL for running rack servers as easily as you can in javasript.
  DESC

  spec.homepage = "https://github.com/n-at-han-k/ratalada"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  # The frontend adapters live in sibling gems (ratalada-sinatra,
  # ratalada-grape) that share this lib/ tree, so this core gem ships only its
  # own files: the DSL, the version, and the backends.
  spec.files = %w[
    lib/ratalada.rb
    lib/ratalada/version.rb
    lib/ratalada/falcon.rb
    lib/ratalada/puma.rb
    exe/ratalada
    README.md
    LICENSE
  ]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.60"

  # Servers the backends wrap; users install whichever they require.
  spec.add_development_dependency "falcon"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "lefthook", "~> 2.1"
end

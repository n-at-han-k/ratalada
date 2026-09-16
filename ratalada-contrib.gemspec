# frozen_string_literal: true

require_relative "lib/ratalada/contrib/version"
require_relative "lib/ratalada/version"

Gem::Specification.new do |spec|
  spec.name = "ratalada-contrib"
  spec.version = Ratalada::Contrib::VERSION
  spec.authors = ["Nathan K"]
  spec.email = ["nathankidd@hey.com"]

  spec.summary = "Contrib add-ons for ratalada."

  spec.description = <<~DESC
    Optional add-on modules for ratalada that do not belong in the core gem.
    Require only the ones you use; each pulls its own framework (the
    file-based routing module expects Sinatra, supplied by your app).
  DESC

  spec.homepage = "https://github.com/n-at-han-k/ratalada"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/ratalada/contrib/**/*.rb"] + %w[LICENSE]
  spec.require_paths = ["lib"]

  spec.add_dependency "ratalada", "~> #{Ratalada::VERSION.split(".").first}.0"
  spec.add_dependency "mustermann", "> 2"
end

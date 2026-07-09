# frozen_string_literal: true

source "https://rubygems.org"

# Three gems share this repo and this lib/ tree:
#   ratalada          - core DSL + backends (falcon, puma)
#   ratalada-sinatra  - Sinatra frontend adapter (needs mustermann 3)
#   ratalada-grape    - Grape frontend adapter   (needs mustermann 4)
#
# The two adapters' dependencies are mutually exclusive, so each gets its own
# gemfile under gemfiles/ with its own lockfile. This root Gemfile develops the
# core gem (and runs its test suite).
gemspec name: "ratalada"

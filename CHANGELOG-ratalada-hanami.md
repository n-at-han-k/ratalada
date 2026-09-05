# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-09-06

### Added

- **The `ratalada-hanami` gem.** `require "ratalada/hanami"` class-evaluates the
  `Server.run` block into an anonymous Hanami::API application, the same way the
  Sinatra and Grape adapters do for their frameworks. Split out as its own gem
  so its dependencies stay out of everyone else's bundle.

- `Hanami::API.new` builds and deep-freezes the rack app, so this happens once,
  at boot. Hanami::API's own `scope` and `use` work as documented, including
  path-scoped middleware.

- Starts at 2.0.0 rather than 1.0.0: it depends on `ratalada` as `~> 2.0`, and
  the adapters track the core's major so the version tells you which core you
  need.

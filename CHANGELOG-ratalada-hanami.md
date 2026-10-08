# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [4.0.0] - 2026-10-08

### Changed

- **Depends on `ratalada` as `~> 4.0`,** where 3.x depended on `~> 3.0`. The
  adapters track the core's major; upgrade the two together. Nothing in this
  adapter changed — `require "ratalada/hanami"` still sets
  `Ratalada.config.frontend = Ratalada::Frontends::Hanami` and `.build` still
  class-evals the `Server.run` block into an anonymous `Hanami::API` subclass.

- One thing to know about the 4.0 core if you run on `ratalada/async`: that
  backend now installs a Protocol::HTTP router by default, but a frontend
  require wins, so `require "ratalada/hanami"` keeps Hanami::API and the
  backend wraps it in `Protocol::Rack::Adapter` as before. Order does not
  matter.

## [3.0.1] - 2026-09-25

### Changed

- Released alongside the current `ratalada` core. No adapter changes; the
  `~> 3.0` dependency already covers the 3.1.x core, so an existing 3.0.0
  install picks up the new backends without needing this bump.

## [3.0.0] - 2026-09-16

### Changed

- **Depends on `ratalada` as `~> 3.0`,** where 2.x depended on `~> 2.0`. This
  adapter needs the core's `Ratalada.config`, so it will not install against a
  2.x core; upgrade the two together.

- **Registers itself through `Ratalada.config.frontend`** instead of the
  removed `Ratalada.frontend=`. Requiring `ratalada/hanami` still selects
  `Ratalada::Frontends::Hanami` for you and `.build` is unchanged, but the
  frontend is now an ordinary setting: select it explicitly with
  `Server.run(frontend: Ratalada::Frontends::Hanami) { ... }` or from a
  `Ratalada.configure` block. If you were setting `Ratalada.frontend =
  Ratalada::Frontends::Hanami` by hand, write through the config instead.

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

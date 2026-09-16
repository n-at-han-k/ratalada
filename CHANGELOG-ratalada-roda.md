# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2026-09-16

### Changed

- **Requires `ratalada` `~> 3.0`.** The adapters track the core's major, and
  nothing here works against a 2.x core: `require "ratalada/roda"` now selects
  the frontend with `Ratalada.config.frontend = Ratalada::Frontends::Roda`,
  and `Ratalada.frontend=` — which 2.0.0 used — is gone from the core.

- **Selecting the frontend goes through the config**, so it follows the
  config's rules: the require still picks Roda for you, but because the config
  is finalized on first read, requiring `ratalada/roda` after the server has
  booted now raises instead of silently swapping the frontend. To choose it
  explicitly, pass it to `Server.run` — `Server.run(frontend:
  Ratalada::Frontends::Roda) { ... }` — or set it in a `Ratalada.configure`
  block.

- `Ratalada::Frontends::Roda.build` is unchanged: the `Server.run` block is
  still class-evaled into an anonymous `Roda` subclass and built with
  `.freeze.app`.

## [2.0.0] - 2026-09-06

### Added

- **The `ratalada-roda` gem.** `require "ratalada/roda"` class-evaluates the
  `Server.run` block into an anonymous Roda application, the same way the
  Sinatra and Grape adapters do for their frameworks. Split out as its own gem
  so its dependencies stay out of everyone else's bundle.

- The block is Roda's class body, so `plugin` and `use` are available alongside
  `route`. The app is built with `.freeze.app` — Roda's recommended production
  setup — so mutating the app after boot raises instead of racing.

- Starts at 2.0.0 rather than 1.0.0: it depends on `ratalada` as `~> 2.0`, and
  the adapters track the core's major so the version tells you which core you
  need.

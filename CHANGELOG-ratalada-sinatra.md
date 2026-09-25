# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
  removed `Ratalada.frontend=`. Requiring `ratalada/sinatra` still selects
  `Ratalada::Frontends::Sinatra` for you and `.build` is unchanged, but the
  frontend is now an ordinary setting: select it explicitly with
  `Server.run(frontend: Ratalada::Frontends::Sinatra) { ... }` or from a
  `Ratalada.configure` block. If you were setting `Ratalada.frontend =
  Ratalada::Frontends::Sinatra` by hand, write through the config instead.

## [2.0.0] - 2026-09-06

### Changed

- **This gem now carries its own version,** `Ratalada::Sinatra::VERSION` in
  `lib/ratalada/sinatra/version.rb`, instead of reusing `Ratalada::VERSION`. It
  is released on its own schedule and tagged `ratalada-sinatra-v2.0.0`, so an
  adapter fix no longer waits for a core release.

- **Depends on `ratalada` as `~> 2.0`,** where 1.x pinned the core's exact
  version. Install this gem with any 2.x core; if you pinned the two to the
  same version in your Gemfile, drop the pin.

## [1.0.1] - 2026-08-25

### Changed

- Released alongside `ratalada` 1.0.1. No adapter changes; the gems shared one
  version at the time, so this entry records the release, not a difference.

## [1.0.0] - 2026-07-09

### Added

- **The `ratalada-sinatra` gem.** `require "ratalada/sinatra"` class-evaluates the
  `Server.run` block into an anonymous Sinatra application. Split out of the core
  `ratalada` gem so its dependencies stay out of everyone else's bundle; the
  require path is unchanged.

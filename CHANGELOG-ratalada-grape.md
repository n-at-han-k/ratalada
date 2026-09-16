# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2026-09-16

### Changed

- **Depends on `ratalada` as `~> 3.0`,** where 2.x depended on `~> 2.0`. This
  adapter needs the core's `Ratalada.config`, so it will not install against a
  2.x core; upgrade the two together.

- **Registers itself through `Ratalada.config.frontend`** instead of the
  removed `Ratalada.frontend=`. Requiring `ratalada/grape` still selects
  `Ratalada::Frontends::Grape` for you and `.build` is unchanged, but the
  frontend is now an ordinary setting: select it explicitly with
  `Server.run(frontend: Ratalada::Frontends::Grape) { ... }` or from a
  `Ratalada.configure` block. If you were setting `Ratalada.frontend =
  Ratalada::Frontends::Grape` by hand, write through the config instead.

## [2.0.0] - 2026-09-06

### Changed

- **This gem now carries its own version,** `Ratalada::Grape::VERSION` in
  `lib/ratalada/grape/version.rb`, instead of reusing `Ratalada::VERSION`. It
  is released on its own schedule and tagged `ratalada-grape-v2.0.0`, so an
  adapter fix no longer waits for a core release.

- **Depends on `ratalada` as `~> 2.0`,** where 1.x pinned the core's exact
  version. Install this gem with any 2.x core; if you pinned the two to the
  same version in your Gemfile, drop the pin.

- **Depends on `grape` as `~> 3.2`,** where 1.x pinned `grape` to exactly
  3.3.2. Grape patch and minor releases no longer need a release of this gem
  to become installable.

## [1.0.1] - 2026-08-25

### Changed

- Released alongside `ratalada` 1.0.1. No adapter changes; the gems shared one
  version at the time, so this entry records the release, not a difference.

## [1.0.0] - 2026-07-09

### Added

- **The `ratalada-grape` gem.** `require "ratalada/grape"` class-evaluates the
  `Server.run` block into an anonymous Grape application. Split out of the core
  `ratalada` gem so its dependencies stay out of everyone else's bundle; the
  require path is unchanged.

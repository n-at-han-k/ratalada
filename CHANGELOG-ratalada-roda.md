# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

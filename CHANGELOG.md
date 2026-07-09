# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-09

### Added

- **Grape frontend.** `require "ratalada/grape"` class-evaluates the
  `Server.run` block into an anonymous `Grape::API`, the same way the Sinatra
  frontend does for `Sinatra::Base`. Ships as the new `ratalada-grape` gem.

### Changed

- **Frontend adapters are now separate gems.** The Sinatra and Grape adapters
  live in `ratalada-sinatra` and `ratalada-grape`; the core `ratalada` gem ships
  only the pattern-matching router, the backends (`puma`, `falcon`), and the
  DSL. Each adapter keeps its framework's dependencies out of the core gem — and
  out of each other's: Grape needs `mustermann` 4, Sinatra needs `mustermann` 3,
  so the two could not otherwise share a bundle.

  The **require path is unchanged**: install the adapter gem, then
  `require "ratalada/sinatra"` or `require "ratalada/grape"` exactly as before.
  The adapter file lives under the shared `ratalada/` namespace on the load path,
  so the require does not name the gem.

### Migration

- If you relied on `require "ratalada/sinatra"` being available from the
  `ratalada` gem, add `gem "ratalada-sinatra"` (or `gem "ratalada-grape"`) to
  your Gemfile. No code changes — the `require` line stays the same.

[1.0.0]: https://github.com/n-at-han-k/ratalada/releases/tag/v1.0.0

# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-09-06

### Added

- **Middleware, via `Server.use`.** `Server.use` starts a chain that `run`
  ends, so `Server.use(Rack::CommonLogger).use(Rack::Deflater).run { ... }`
  wraps the app the frontend built. These are plain rack middleware — they are
  handed the `env`, so every middleware gem works unchanged — instantiated once
  at boot, not per request. The first `use` in the chain is the outermost, as in
  `Rack::Builder`. It works with every frontend, including Sinatra, Grape,
  Hanami::API and Roda. `Server.use` returns a `Ratalada::Server::Stack`;
  `Server.run` builds one internally, so calling `run` on its own is unchanged.

- **Rack::Builder frontend.** `require "ratalada/builder"` makes the
  `Server.run` block a `Rack::Builder` block, so `use`, `map` and `run` are
  rack's own, built once at boot. There is no `Request` sugar on this frontend:
  `run` hands you the raw `env` and you return a full rack triplet yourself. It
  ships in the core gem — rack is already there via whichever backend you run —
  so there is no separate gem to install.

- **Hanami::API and Roda frontends,** as the new `ratalada-hanami` and
  `ratalada-roda` gems: `require "ratalada/hanami"` or `require "ratalada/roda"`
  class-evaluates the `Server.run` block into an anonymous `Hanami::API` or
  `Roda` subclass, the same way the Sinatra and Grape frontends do. The Roda app
  is built with `.freeze.app`, Roda's recommended production setup, so mutating
  the app after boot raises instead of racing.

### Changed

- **Each gem now carries its own version.** `Ratalada::VERSION` covers the core
  gem only; the adapters have `Ratalada::Sinatra::VERSION`,
  `Ratalada::Grape::VERSION`, `Ratalada::Hanami::VERSION` and
  `Ratalada::Roda::VERSION` in `lib/ratalada/<name>/version.rb`. They are
  released on their own schedules, so an adapter fix no longer needs a core
  release to carry it. Release tags are per gem — `ratalada-v2.0.0`,
  `ratalada-roda-v2.0.0` — where 1.x tagged the repository `v1.0.1`.

  Nothing to do at the call site: the five gems all ship 2.0.0 together, and
  `require "ratalada/sinatra"` and friends are unchanged. If you pinned an
  adapter to the core's exact version, drop the pin — adapters now depend on
  `ratalada` as `~> 2.0`, so any 2.x core satisfies them.

## [1.0.1] - 2026-08-25

### Fixed

- **Falcon backend boots against async-service 0.25.** `Managed::Service#preload!`
  now reads `@evaluator.root` on every start — the default `preload` is `[]`,
  which is truthy — so the environment built by `Ratalada::Backends::Falcon.run`
  raised `NoMethodError: undefined method 'root'` before the server came up.
  The environment now sets `root: Dir.pwd`. `ratalada` 1.0.0 with
  `falcon` 0.57.0 / `async-service` 0.25.0 was broken for every user; earlier
  versions are unaffected and accept `root:` unchanged.

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

- If you relied on `require "ratalada/sinatra"` being available from the
  `ratalada` gem, add `gem "ratalada-sinatra"` (or `gem "ratalada-grape"`) to
  your Gemfile. No code changes — the `require` line stays the same.

[2.0.0]: https://github.com/n-at-han-k/ratalada/releases/tag/ratalada-v2.0.0
[1.0.0]: https://github.com/n-at-han-k/ratalada/releases/tag/v1.0.0

# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2026-09-16

### Changed

- **The backend and the frontend are `Ratalada.config` settings.**
  `Ratalada.config.backend` and `Ratalada.config.frontend` hold what
  `self.backend =` and `self.frontend =` used to, so they can be set in a
  `Ratalada.configure` block or passed to `Server.run` like any other setting:
  `Server.run(frontend: Ratalada::Frontends::Builder) { ... }`. Requiring
  `ratalada/puma`, `ratalada/falcon`, `ratalada/sinatra` and friends still
  selects them for you, and the readers `Ratalada.backend` (still raising
  `NoBackendError` when none is set) and `Ratalada.frontend` (still defaulting
  to `Ratalada::Frontends::Routes`) are unchanged.

### Removed

- **`Ratalada.backend=` and `Ratalada.frontend=`.** Write through the config
  instead — `Ratalada.config.backend = ...` / `Ratalada.config.frontend = ...`,
  a `Ratalada.configure` block, or the matching `Server.run` option. Note that
  the config is finalized on first read, so an assignment after the server has
  booted now raises rather than silently swapping the frontend.

## [2.2.0] - 2026-09-16

### Added

- **`Ratalada.config`, for server-wide settings.** `Ratalada.setting`
  declares a setting and `Ratalada.configure { |c| c.host = ... }` writes it;
  the core gem ships `host`, `port` and `count`, and contrib gems register
  their own the same way. `port` and `count` are coerced with `Integer(...)`,
  so a `PORT="3000"` in the environment still resolves. `Server.run` now
  takes `**options` and writes each through to `Ratalada.config` before boot,
  so `Server.run(port: 3000) { ... }` is shorthand for a `configure` block,
  and a bare `Server.run { ... }` on an already-finalized config is fine.
  `DEFAULT_HOST`, `DEFAULT_PORT` and `DEFAULT_COUNT` remain as the defaults
  behind the settings.

### Changed

- **`dry-configurable` is a runtime dependency**, pinned to `~> 1.4`. It
  backs `Ratalada.config`; it was not previously in the bundle.

## [2.1.0] - 2026-09-10

### Added

- **`Request` is a `Rack::Request`.** `params`, `cookies`, `headers`, `host`,
  `ip`, `session` and the rest come along for free; `verb`, `path`, `query`
  and the pattern-matching sugar are unchanged. Two deliberate differences
  from rack: `#path` stays `PATH_INFO` (so an app under a `map` routes within
  itself) and `#body` stays the body as a `String`, not the input stream.

- **`Request#read`, for streaming request bodies.** `request.read(5)` chunks
  through `rack.input` and returns `nil` at EOF. Rack 3 input reads once and
  does not rewind, so use `#read` or `#body` on a request, never both.

- **`Rack::Utils` helpers unqualified in a `Server.run` block** — no prefix,
  no `include`. They go on the singleton of the object the block was written
  in, as private methods, so nothing else is touched and your own `escape` or
  `status_code` still wins. Default router only: the other frontends run the
  block in their library's scope, so prefix with `Rack::Utils.` there.

### Changed

- **`rack` is now a runtime dependency**, pinned to `~> 3.0`. It was already
  there via whichever backend you ran; an app pinned to rack 2 will not
  resolve.

## [2.0.1] - 2026-09-06

### Security

- **The falcon backend no longer caches responses.**
  `Ratalada::Backends::Falcon.run` built its middleware with
  `Falcon::Server.middleware(app)`, whose `cache:` defaults to true, so every
  app started through `require "ratalada/falcon"` ran behind
  `Async::HTTP::Cache::General`. That store keys entries on
  `[authority, method, path]` alone: a lookup skips the `Cookie` check that
  insertion applies, and an entry without `max-age` never expires, so one
  anonymous response could be replayed to logged-in requests. It is now off,
  matching `falcon host`, which builds its middleware through
  `Environment::Rackup` and only enables the cache for `falcon serve --cache`.
  Every 2.0.0 and 1.x app on the falcon backend was affected; the puma backend
  never had a cache.

### Added

- **`cache:` on the falcon backend.** `Ratalada::Backends::Falcon.run` takes
  `cache: true` to put `Async::HTTP::Cache::General` back in front of the app —
  the old behaviour, now opt-in and worth reading the note above first. It is a
  backend-level option: `Server.run` does not accept it, so call
  `Ratalada::Backends::Falcon.run` yourself if you want it.

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

[3.0.0]: https://github.com/n-at-han-k/ratalada/releases/tag/ratalada-v3.0.0
[2.2.0]: https://github.com/n-at-han-k/ratalada/releases/tag/ratalada-v2.2.0
[2.1.0]: https://github.com/n-at-han-k/ratalada/releases/tag/ratalada-v2.1.0
[2.0.1]: https://github.com/n-at-han-k/ratalada/releases/tag/ratalada-v2.0.1
[2.0.0]: https://github.com/n-at-han-k/ratalada/releases/tag/ratalada-v2.0.0
[1.0.0]: https://github.com/n-at-han-k/ratalada/releases/tag/v1.0.0

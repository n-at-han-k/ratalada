# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2026-09-16

### Added

- **`Mustermann::Expo`,** an expo-router pattern type for mustermann, registered
  as `:expo`: `Mustermann.new("/[foo]", type: :expo) === "/bar"`. `[name]` is a
  capture and `[...rest]` a named splat that converts to an array of segments.
  `Mustermann::Expo.route(path)` is the file-path-to-route half on its own — it
  drops the `.rb` and `+api` suffixes, reads `_layout.rb` as its directory, a
  trailing `index` as its directory, `(group)` segments as invisible, and
  `+not-found` as `[...unmatched]` — mirroring expo-router's own
  `getContextKey`/`stripInvisibleSegmentsFromPath`. `mustermann` (`> 2`) is now
  a dependency of the gem.

- **`route_prefix` on each frontend's app class.** Requiring an adapter
  (`ratalada/contrib/router/file_based/sinatra_adapter` and friends) adds
  `route_prefix` to `Sinatra::Base`, `Grape::API::Instance` and `Hanami::API`:
  every route defined while it is set hangs off it. That is what puts a route
  file's own `get "/members"` under the prefix its path spells, and it works
  outside file-based routing too.

### Changed

- **Building a file-based router is `Ratalada::Contrib::Router::FileBased.build(directory)`,**
  one entry point for all three frontends, in place of the per-adapter
  `SinatraAdapter.build` / `GrapeAdapter.build` / `HanamiAdapter.build`. It
  builds through `Ratalada.frontend`, so the adapter you require and the
  frontend you select have to agree:

      require "ratalada/sinatra"
      require "ratalada/contrib/router/file_based/sinatra_adapter"

      Server.run { run Ratalada::Contrib::Router::FileBased.build("app") }

  The conventions, the ordering and `build_map` are unchanged.

- **The Sinatra adapter builds one app, not one app per file.** Where 2.1.0
  built each route file into its own `Sinatra::Base` subclass and chained them
  as rack middleware, every file is now evaluated into the one class under its
  `route_prefix`. Routes still answer most-specific-first, but a file no longer
  gets its own middleware stack or its own settings — `use`, `set` and
  `helpers` in any file now apply to the whole app, so put them in `_layout.rb`
  where that is what you meant. The Grape adapter likewise no longer `mount`s a
  separate `Grape::API` per file.

- **The adapters require their ratalada frontend,** `ratalada/sinatra`,
  `ratalada/grape` or `ratalada/hanami`, rather than the bare framework. Add
  the matching gem to your Gemfile if you were relying on the adapter to pull
  in `sinatra`, `grape` or `hanami-api` by itself.

- **Depends on `ratalada` as `~> 3.0`,** where 2.x depended on `~> 2.0`.
  `FileBased.build` reads the frontend from `Ratalada.config`, so this will not
  install against a 2.x core; upgrade the two together.

### Removed

- **`SinatraAdapter.build`, `GrapeAdapter.build` and `HanamiAdapter.build`.**
  Use `FileBased.build(directory)` with the matching frontend selected. The
  adapter modules remain, but only as the mixins that teach a frontend
  `route_prefix`.

- **`FileBased.pattern`, `FileBased.route_segments` and `FileBased::NOT_FOUND`.**
  `Mustermann::Expo.route` does the file-path-to-route translation now, and the
  fallback file's name is `Mustermann::Expo::NOT_FOUND`. `FileBased.spell`
  replaces `pattern` as the step that puts a route in an adapter's own spelling;
  `build_map` still takes `placeholder:` and `catch_all:` and still returns
  prefixes spelled that way.

## [2.1.0] - 2026-09-16

### Added

- **File-based routing,** via `Ratalada::Contrib::Router::FileBased`. Turns an
  expo-router style directory of route files into an ordered map of
  `prefix => files`: `FileBased.build_map("app")` walks the tree and each
  file's path spells the prefix its own routes hang off, so a file stays
  ordinary DSL for its frontend. The conventions are expo-router's —
  `index.rb` is the directory itself, `[slug].rb` a dynamic segment,
  `[...rest].rb` a catch-all, `(group)/` groups without adding a segment,
  `+not-found.rb` the fallback, and `_layout.rb` is not a route of its own but
  is evaluated into every route file below it, outermost first (any other `_`
  file or directory is ignored). The map is ordered most specific first —
  static before dynamic, dynamic before catch-all, `+not-found` last — so an
  adapter can define routes in iteration order under a first-match-wins
  router. `FileBased.join(prefix, route)` hangs one of a file's own routes off
  its prefix; `build_map` takes `placeholder:` and `catch_all:` for frontends
  that spell parameters differently.

- **Three frontend adapters for it,** each requiring its own frontend, which
  your app supplies. Require
  `ratalada/contrib/router/file_based/sinatra_adapter` and call
  `SinatraAdapter.build("app")`: every file is
  class_eval'd into a `Sinatra::Base` subclass the way a `Server.run` block
  is, its compiled Mustermann patterns get the prefix prepended, and the apps
  are chained as rack middleware so the first file that spells the path
  answers. `GrapeAdapter.build("app")` returns a `Grape::API` subclass with
  each file built into its own API and `mount`ed under its prefix.
  `HanamiAdapter.build("app")` returns a `Hanami::API` instance with each file
  evaluated inside `router.scope(prefix)`. All three return a rack app, ready
  for `Server.run`.

## [2.0.1] - 2026-09-16

### Fixed

- **`vite_client_tag` emits well-formed HTML.**
  `Ratalada::Contrib::Vite::TagHelpers#vite_client_tag` was closing its
  `<script>` with `</script` (no `>`), leaving the rest of the page inside the
  script element and preventing the vite dev client from loading. The closing
  tag is now `</script>`.

## [2.0.0] - 2026-09-16

### Added

- **The `ratalada-contrib` gem.** Optional add-ons for ratalada that do not
  belong in the core gem. `require "ratalada/contrib/inertia"` and
  `require "ratalada/contrib/vite"` pull only the module you use; each brings
  its own dependency (`inertia_rails`, `vite_ruby`) so the core bundle stays
  clean. Starts at 2.0.0 rather than 1.0.0: it depends on `ratalada` as
  `~> 2.0`, and the contrib version tracks the core's major so the version
  tells you which core you need.

- **Inertia protocol support,** via `Ratalada::Contrib::Inertia`. Prop
  factories — `always`, `defer`, `optional`, `lazy`, `merge`, `deep_merge`,
  `once`, `cache`, `scroll` — delegate to `InertiaRails`' prop classes so
  partial reloads, deferred/optional props, and infinite-scroll metadata
  work as the JS side expects. `Ratalada::Contrib::Inertia.share` registers a
  shared-prop block that runs in the request context on every render and is
  deep-merged under the page props. The module is also aliased to the
  top-level `::Inertia` constant when nothing else defines it, so
  `Inertia.share { ... }` at boot works unchanged.

- **`Ratalada::Contrib::Inertia::Middleware`,** rack middleware for the
  Inertia protocol. Rewrites 301/302 on POST/PUT/PATCH/DELETE to 303, turns a
  cross-origin redirect on an Inertia request into `409 + X-Inertia-Location`,
  and forces a full-page refresh (`409 + x-inertia-location`) when the
  client's asset version is stale. Also copies `X-XSRF-TOKEN` to
  `X-CSRF-TOKEN` on the way in so downstream CSRF checks see the same header.

- **`Ratalada::Contrib::Inertia::CSRFMiddleware`,** the double-submit CSRF
  half of the pair. Reads/writes an `XSRF-TOKEN` cookie (`SameSite=Lax` by
  default; pass `same_site:` to change it) and rejects unsafe methods whose
  `X-XSRF-TOKEN` header does not match with a `403`. `env` exposes the token
  at `ratalada.inertia.csrf_token` for the render helpers.

- **`Ratalada::Contrib::Inertia::Helpers`,** a mixin for the request context.
  `inertia(component, props:, layout:)` builds and renders the page (JSON on
  an Inertia request, layout ERB otherwise), and `render` is overloaded so
  `render inertia: "Component", props: {...}` and
  `render "Component", foo: 1` both go through it without shadowing the
  framework's own `render`. Adds `render_modal`, `inertia_request?`,
  `csrf_token`, `inertia_errors` / `page_errors` (session-backed error
  payload, swept on read), `inertia_clear_history!` and
  `inertia_encrypt_history!` for the matching page-object flags, and the
  same prop factories on the request context so views can call them
  unqualified.

- **Contrib settings on `Ratalada.config`.** `inertia_version` (asset version
  string or callable, sent with every page and used by the middleware for
  stale-check), `inertia_layout` (ERB template name, defaults to `:layout`),
  `inertia_encrypt_history` (default `false`), `inertia_csrf_protection`
  (default `true`), and `inertia_share_blocks` (the array `share` appends
  to). `Ratalada::Contrib::Inertia.current_version` reads `page_version`
  first if the host app defined it, falling back to `inertia_version`.

- **`Ratalada::Contrib::Vite::DevServerProxy`,** rack middleware that fronts
  the app with vite's dev-server proxy while `bin/vite dev` is running and is
  a pass-through otherwise. The decision is `ViteRuby.run_proxy?`, read once
  at boot — the same lifetime as any other `Server.use` argument — so
  `Server.use(Ratalada::Contrib::Vite::DevServerProxy).run { ... }` is all
  the wiring. `ssl_verify_none:` defaults to `true` and is forwarded to
  `ViteRuby::DevServerProxy`.

- **`Ratalada::Contrib::Vite::TagHelpers`,** a mixin for the request context.
  `vite_client_tag`, `vite_react_refresh_tag`, `vite_asset_path`,
  `vite_javascript_tag(*names, type:, crossorigin:)` and `vite_styleshee_tag`
  read `ViteRuby.instance.manifest` and emit the `<script>` / `<link>` tags
  the vite manifest resolves to, including modulepreloads for imported
  chunks.

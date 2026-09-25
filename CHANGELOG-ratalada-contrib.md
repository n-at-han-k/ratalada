# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.1.3] - 2026-09-25

### Added

- **`mount_files` on a file-based router adapter,** an optional hook read by
  `Ratalada::Contrib::Router::FileBased.mount`. An adapter that defines it is
  handed the app and the whole `build_map` result
  (`mount_files(app, map)`) and decides for itself how the files become
  routes; an adapter that does not keeps the previous behaviour, where every
  file is `class_eval`'d into the one app under its `route_prefix`, which is
  what the hanami and grape adapters do. Only matters if you wrote your own
  adapter.

### Changed

- **The Sinatra adapter builds one app per route file again,** so that a
  `_layout.rb` only reaches the files below it. `use`, `set`, `before`,
  `error` and `helpers` are class-level Sinatra DSL, and 3.0.0 evaluated the
  whole tree into a single `Sinatra::Base`, which made a nested layout apply
  app-wide: an `app/(api)/_layout.rb` with `before { content_type(:json) }`
  relabelled every HTML page in the tree. Each route file, with the layouts
  above it, now gets its own subclass, and the subclasses are chained as rack
  middleware — a Sinatra app used as middleware forwards the request on when
  none of its own routes matched, so the first file that spells the path
  answers, in `build_map`'s most-specific-first order.

  If you followed 3.0.0's advice and put a `use`, `set` or `helpers` in a root
  `_layout.rb` to reach the whole app, that still works, because the root
  layout is evaluated into every route file. One in a *nested* layout, or in a
  route file, now applies only to that file — move it up to the root
  `_layout.rb` if you meant the whole app. Routes, `route_prefix` and
  `params` are unchanged.

## [3.1.1] - 2026-09-22

### Added

- **`route_spelling` on a file-based router adapter,** an optional hook read by
  `Ratalada::Contrib::Router::FileBased.mount`. An adapter that defines it
  returns the `placeholder:`/`catch_all:` pair `build_map` should use for that
  frontend; an adapter that does not keeps the `":%s"` / `"*%s"` defaults,
  which is what the hanami and grape adapters read. Only matters if you wrote
  your own adapter — the ones shipped here are already updated.

- **`Ratalada::Contrib::Router::FileBased::SinatraAdapter::SPELLING`,** the
  expo spelling (`"[%s]"` / `"[...%s]"`) the sinatra adapter now returns from
  `route_spelling`.

### Fixed

- **A hyphenated parameter now routes under sinatra.** The sinatra adapter
  used to translate an expo path into sinatra's own pattern syntax, which has
  no way to spell `[user-id]`: `:user-id` reads as the capture `user` followed
  by the literal `-id`, so `app/[user-id]/index.rb` matched nothing and
  `params["user-id"]` was never set. The adapter now keeps the expo spelling
  and hands `Server.route` a `Mustermann.new(path, type: :expo)` pattern
  instead of a string, so the pattern is the one the file path already is.
  Routes without hyphens are unaffected, and `params` keys are unchanged for
  them.

- **A route segment that spells a literal now beats the bare capture.**
  `FileBased.build_map` ordered `[index].[diffType]` and `[index]` as equally
  specific, so `/pulls/7.diff` could land on whichever sorted first. Segments
  that are partly literal now rank between a literal segment and a bare
  capture, and `[index].[diffType]` is matched ahead of `[index]`. The
  relative order of literal, capture and splat segments is otherwise the
  same.

## [3.1.0] - 2026-09-16

### Added

- **`Ratalada::Contrib::Inertia::JsonParamsMiddleware`,** rack middleware that
  reads a JSON request body into `params`. The inertia client posts
  `application/json`, which Sinatra does not parse, so `params` came back empty
  for anything the client sent that way; this parses the body and hands the
  hash to `Rack::Request` (`rack.request.form_hash`), leaving the input stream
  rewound for anything downstream that reads it. A non-JSON content type, a
  body that is not valid JSON, or one that parses to something other than a
  hash all pass straight through. It is not wired in for you — put it in front
  of the inertia middleware:

      Server
        .use(Ratalada::Contrib::Inertia::JsonParamsMiddleware)
        .use(Ratalada::Contrib::Inertia::Middleware)
        .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
        .run { ... }

  `require "ratalada/contrib/inertia"` loads it.

## [3.0.1] - 2026-09-16

### Added

- **`Ratalada::Contrib::Router::FileBased.mount(app, directory)`,** which
  evaluates a directory of route files into an app class you already have,
  rather than building one for you. Inside a `Server.run` block `self` is that
  class, so mounting a file-based router no longer needs `build` and a `run`:

      require "ratalada/falcon"
      require "ratalada/contrib/router/file_based/sinatra_adapter"

      Server.run { Ratalada::Contrib::Router::FileBased.mount(self, "app") }

  `FileBased.build(directory)` is unchanged and still the way to build a
  standalone app to mount somewhere else; it is now `mount` run inside
  `Ratalada.frontend.build`. The conventions, the ordering and `build_map` are
  the same for both.

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

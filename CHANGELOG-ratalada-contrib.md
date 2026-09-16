# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

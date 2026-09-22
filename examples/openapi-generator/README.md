# openapi-generator

An OpenAPI document in, a Ratalada route tree out.

```bash
nix develop
ruby generate.rb forgejo.json .     # writes everything below
bundle exec rspec                   # 512 examples against the scaffold
bin/schema                          # the document, back out of the specs
ruby server.rb                      # serves it on 127.0.0.1:9292

curl http://127.0.0.1:9292/api/v1/version
curl http://127.0.0.1:9292/api/v1/repos/nathan/infra
curl http://127.0.0.1:9292/api/v1/topics/search   # 400: q is required
```

Three tools, one pass: this script annotates the document with what each route
answers, **openapi-generator-expo** (our patched generator) writes the route
half of every page, and **openapi_ruby**'s DSL is appended to the same file
under `__END__`.

| generated | what it is |
|---|---|
| `app/**/*.rb` | the route, and its spec below `__END__` |
| `lib/schemas/*.rb` | openapi_ruby component classes, one per definition |
| `db/schema.sql` | `-g postgresql-schema`'s own DDL, verbatim |
| `db/migrate/001_schema.rb` | that DDL as a Sequel migration |
| `db/migrate/002_route_keys.rb` | the keys the routes need, which the document cannot declare |
| `lib/models/*.rb` | ROM relations over those tables |
| `lib/entities/*.rb` | what those relations map to |
| `spec/factories/*.rb` | a rom-factory per relation |
| `config/rom.rb` | the container, and the migrator that runs before it |
| `config/openapi_ruby.rb` | the schema config the specs and the server share |
| `lib/openapi_ruby_patches.rb` | what the gem gets wrong, reopened |
| `spec/pages_spec.rb` | evaluates every page's `__END__` half |
| `spec/spec_helper.rb`, `bin/schema` | the wiring |
| `openapi/public_api.yaml` | written by `bin/schema`, out of the specs |

All of it is generated and gitignored. `forgejo.json` is the source of truth: the
real Forgejo API document (Swagger 2.0, 331 paths, 512 operations, 248
definitions, 850KB), copied verbatim so the example is measured against a spec
nobody wrote for it.

## What it writes

The file path IS the route, so generating the tree is most of the job:

| document path | file | route |
|---|---|---|
| document path | file | route |
|---|---|---|
| `/version` | `app/api/v1/version.rb` | `/api/v1/version` |
| `/repos/{owner}/{repo}` | `app/api/v1/repos/[owner]/[repo]/index.rb` | `/api/v1/repos/:owner/:repo` |
| `/repos/{owner}/{repo}/pulls` | `app/api/v1/repos/[owner]/[repo]/pulls/index.rb` | `…/pulls` |
| `/repos/{owner}/{repo}/pulls/{index}.{diffType}` | `…/pulls/[index].[diffType].rb` | `…/pulls/:index.:diffType` |

`{param}` becomes `[param]` — several per segment where the document has them —
`basePath` prefixes the tree, and a path that is the prefix of another becomes a
directory with its own page as the `index.rb` inside it: `/repos/{owner}/{repo}`
and `/repos/{owner}/{repo}/pulls` cannot both be `[repo].rb`.

Each page declares only the verbs of its own path, at `"/"`: the prefix is
already spelled by where the file sits, and `SinatraAdapter#route` joins the two.
Response bodies are scaffolded from the response schema (`$ref`s resolved), so
the contract is visible in the page before anyone writes a query behind it.

Every file is spelled back through `Mustermann::Expo.route` before it is
written, and a disagreement aborts the run — the generator cannot emit a file
whose path means a different route than the document asked for.

## The patched generator

`generator/` is the patch: `ExpoCodegen.java` and `templates/page.mustache`.

openapi-generator writes **one file per tag group**; a file-based router needs
**one file per path**, with the path in the filename. Both are Java-side
decisions — `addOperationToGroup` keys the group map, `toApiFilename` spells
the output path — and `-t templates/` reaches neither. So the class overrides
exactly those two, plus `preprocessOpenAPI` to learn which paths are
directories (a path that prefixes another cannot also be a leaf file) and where
the servers' prefix starts.

It builds without Maven and without a checkout of the generator: `javac`
against the packaged CLI's own jar, an SPI entry naming the class, and a
wrapper that puts both jars on the classpath (the packaged CLI runs `java
-jar`, which ignores `-cp`). `nix build .#expo-codegen` is the whole build.

What a route *answers* is a schema walk no template can do, so it travels in
the document: `generate.rb` annotates each operation with `x-status`, `x-body`
and `x-params`, and `page.mustache` prints them. The generator stays about
structure.

Both halves name the file independently — the Java from `toApiFilename`, the
Ruby from `file_for` — and a disagreement aborts the run rather than putting a
spec on the wrong route.

## Which openapi-generator for the client half

The server side is above; a **client** gem is what upstream is genuinely good at,
and neither GitHub repo is what to reach for in a flake:

- `openapi-generator-cli` (npm) is a Node wrapper that downloads the jar from
  Maven at runtime — unpinnable, and offline it does nothing.
- `openapi-generator` (the Java repo) is the real thing, but building it means
  Maven in the loop.

nixpkgs packages the jar already, so `flake.nix` takes that and the client is one
command:

```bash
openapi-generator-cli generate -i forgejo.json -g ruby -o client
```

See `docs/generators/ruby.md` upstream for its options.

## openapi_ruby is the other half

[openapi_ruby](https://github.com/openapi-ruby/openapi-ruby) runs the opposite
way round: specs DECLARE the document, and `rake openapi_ruby:generate` writes
it out. Generating those specs from a document closes the loop — the document
comes back.

Specs are Style 2 (`api_path` + `assert_api_response`), one `api_path` per file.
That is not a stylistic choice: Style 2 resolves a request to a declaration by
verb, params and status, and Forgejo has sibling paths that agree on all three
(`pulls/{base}/{head}` and `pulls/{index}`), which raises
`OpenapiRuby::AmbiguousApiPath`. One path per file is the documented way out,
and the file-per-route layout gives it for free.

Definitions become component classes under `lib/schemas/` — `class
Schemas::Repository`, `skip_key_transformation true` — and the specs reference
those **classes**, not `$ref` strings: 1,401 of them, so a typo is a `NameError`
rather than a dangling reference in the document. Inside a component the refs
stay strings, because the 248 classes reference each other in both directions
and a class reference has to resolve while the file naming it loads.

`spec_helper.rb` calls `Components::Loader#load!` up front for the same reason:
a spec names `Schemas::Repository` as RSpec reads the file.

`bin/schema` calls `Generator::SchemaWriter.generate_all!` directly. The rake
task only shells out to a subprocess that does this much with none of it in
reach — so the two things that subprocess does are done here instead:
`AutorunSuppressor.install!` (requiring a spec file must not also run it) and
`rspec/core` before `openapi_ruby/rspec`, which configures `::RSpec` on require.

`lib/openapi_ruby_patches.rb` reopens `Adapters::RSpec::ExampleHelpers` and
prepends a substitution that accepts any name a document can spell. Upstream
fills path parameters with `/\{(\w+)\}/`, and `\w` excludes the hyphen, so
Forgejo's `{user-id}` went out unfilled and raised `URI::InvalidURIError`. A
document is not ours to rename; where the gem cannot read one, the gem moves.

`server.rb` installs the runtime validation middleware onto a
`Ratalada::Server::Stack` — not onto `Server`, since `Server.use` *returns* the
chain it starts and installing onto `Server` leaves the middleware on a stack
nothing runs.

## Persistence

Routes read and write through ROM relations on SQLite, not placeholder literals.

Two sources, one each:

- **`db/schema.sql` → the migrations.** A second generator pass, `-g
  postgresql-schema`, writes the DDL for this document: 236 tables, typed
  columns, `id` as a real key wherever the document declares one. That file is
  copied verbatim, and `001_schema.rb` is it translated statement by statement
  into Sequel's migration DSL. Nothing else reads the SQL.
- **`models.json` → the models, the entities and the factories.** A model
  (`Models::ActionRun < ROM::Relation[:sql]`) declares the document's own
  properties, with the types and the json-ness they carry, and maps to an
  entity (`Entities::ActionRun < ROM::Struct`) — which is where behaviour over
  that data goes.

They meet at the names, and there is one rule: **a column is a property the
document declares, and a table name is ours.** A column is a JSON key the API
promises, so nothing may rename one — hence `identifierNamingConvention=original`
on the SQL pass, which otherwise snake_cases 25 of Forgejo's 562 properties
(`ScheduleID`, `PackageFile.Size`, `@context`, `_links`…) and would have the API
answering keys the document never mentions. A table name is promised to nobody,
so the DDL's `ActionRun` becomes `action_run` — snake_cased once, while the
migration is written, and nowhere else.

- A collection GET lists the relation, a member GET looks one up, POST creates,
  PATCH/PUT updates, DELETE deletes. A route whose success response is not a
  model keeps the schema-derived literal, with its TODO.
- A member route is keyed by its own last path parameter: `/repos/{owner}/{repo}`
  looks up `repo`. When the model does not declare such a column, the table
  grows one — a route that takes a key needs somewhere to keep it.
- A column holding another model, a list or a map is TEXT holding JSON, read
  back parsed, so what leaves the API is the shape the response schema promised.
- `Sequel::Migrator` applies both migrations at boot and is idempotent: 230
  tables, `schema_info` at version 2, and nothing re-run on the next boot.
- Table names are the SQL generator's: singular `repository`, `access_token`,
  `api_error` — so `snake` here is openapi-generator's own `underscore`, or the
  two would disagree about what a table is called.

### Factories, not fixtures

The tables ship empty. Each example builds the record it is about to ask for,
with [rom-factory](https://rom-rb.org/learn/factories/):

```ruby
it "GET /api/v1/repos/{owner}/{repo} answers 200" do
  Factory[:repository, repo: "repo"]
  assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
end
```

A factory writes through its relation, so it stores what the columns hold and
reads back what the API answers. The key column is a `sequence` — two examples
in one run must not collide on it — and the member examples override it with
exactly the value they are about to request, which is the same value the spec
sends, decided once by the generator.

Every example runs inside a transaction that is rolled back, so nothing a
factory builds outlives the example that built it.

## Measured

Against `forgejo.json`, all of it in 2.3s:

| | |
|---|---|
| route files | 331 / 331 paths, all round-trip checked |
| handlers | 512 / 512 operations |
| response bodies | 352, of the 362 operations that declare a schema |
| spec files | 331, declaring 512 operations and 1,529 responses |
| components | 248 / 248 definitions |
| specs passing | 512 / 512, against real rows their factories built |
| document round trip | 331 paths, 512 operations, 248 components, Swagger 2.0 → OpenAPI 3.1.0, no validation errors |

150 operations declare a 2xx with no body, so `{}` is the honest answer there.

Getting there took two fixes in `lib/`, both found by running this document
through the router:

- `FileBased.spell` respelled `[user-id]` as Sinatra's `:user-id`, which
  Mustermann reads as the capture `user` followed by the literal `-id` — so
  every hyphenated parameter routed nowhere. The Sinatra adapter now keeps the
  Expo spelling and hands Sinatra a `Mustermann::Expo` pattern, which is what
  the file path already is.
- `FileBased.specificity` ranked `[index].[diffType]` as a bare capture (its
  `/\A\[.+\]\z/` matched the whole segment), so `[index]` sorted first and
  answered `/pulls/7.diff` with a PullRequest. The patterns are now anchored to
  a single capture, and a partly-literal segment outranks a bare one.

Both have regression tests in `test/`.

## Formatting

Nothing generated here is a hash on one line. `pretty` lays a literal out one
entry per line, indented to its nesting, and leaves anything under 60
characters inline. What is left long is a single long string — a description the
document wrote — and that is not ours to reflow.

## What it does not generate yet

- A 2xx with no body still gets `content_type(:json)` and `{}` rather than a
  bare `status(204)`.
- `{filepath}` in Forgejo matches slashes, so it wants `[...filepath]` — the
  document cannot say so, and nothing here guesses.
- Two sibling paths that name the same position differently
  (`pulls/{base}/{head}` and `pulls/{index}/...`) become two files matching the
  same shape of URL, and `FileBased`'s specificity sort picks the winner. That
  is a decision for a person, not a generator.
- Ignored entirely: `parameters` and `requestBody`, `security`, error responses,
  `produces` (non-JSON media types), `operationId`, `tags`, and
  `oneOf`/`allOf`/`anyOf` — a union walks to `{}`.

# swagger

Swagger UI as a Ratalada app, with no generator in it. One route, one page,
and the document read off disk.

```bash
nix develop
bin/dev                      # vite on 3039, the app on 9295
```

Then <http://127.0.0.1:9295>.

The document is `../forgejo.json` unless `SCHEMA` says otherwise, and any
OpenAPI or Swagger file will do -- the fork renders what it is given:

```bash
SCHEMA=/path/to/openapi.yaml bin/serve
```

JSON is YAML, so `.json`, `.yaml` and `.yml` all read the same way.

## What is here

| | |
|---|---|
| `server.rb` | the vite dev-server proxy, and the file-based router over `app/` |
| `app/index.rb` | the only route: the page, with the document embedded in it |
| `app/_layout.rb` | the vite tag helpers |
| `frontend/` | the swagger-ui fork -- see `frontend/FORK.md` |

The document is embedded in the page rather than fetched. swagger-ui will take
a `url:` and go and get one, but then the document is a second route this app
would have to serve, and it is already on disk.

## Where it came from

`../template/frontend` is the same fork, carried into every project
`bin/generate` writes. This copies it out so it can be run on its own, without
the generated API around it.

Because it is a copy, the two can drift. Sync with:

```bash
rm -rf frontend && cp -r ../template/frontend frontend
```

## What it does not have

No ROM, no migrations, no openapi_ruby, no specs, no `generators/` -- that is
all the generated project's, in `../template`. The Gemfile is the template's
as it stands, so it carries gems this project never loads; trimming it means a
`bundix -l` round, which is the only reason it has not been.

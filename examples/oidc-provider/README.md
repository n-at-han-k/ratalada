# oidc-provider

An OpenID Connect provider ([doorkeeper] + [doorkeeper-openid_connect]) and a
relying party that logs in against it ([omniauth_openid_connect]), both running
as ratalada servers.

- `app.rb` — the provider, on `http://localhost:9292`
- `client.rb` — the relying party, on `http://localhost:9293`

Doorkeeper is a Rails engine, so `app.rb` boots a Rails application to hold its
routes and controllers, and the ratalada router hands `/oauth/*` and
`/.well-known/*` to it. Login lives outside the engine, in the ratalada router,
and the signed-in user is carried in one signed cookie rather than a session —
a rack session in the env would fight the Rails app for `rack.session`.

```sh
nix develop      # or: bundle install
SESSION_SECRET=$(openssl rand -hex 32) bundle exec ruby app.rb &
SESSION_SECRET=$(openssl rand -hex 32) bundle exec ruby client.rb &
```

Then open <http://localhost:9293> and sign in as `a@b.c` / `hunter22`.

The demo user and the demo client (`demo-client` / `demo-secret`) are seeded on
first boot; `ISSUER`, `CLIENT_ID`, `CLIENT_SECRET`, `REDIRECT_URI`,
`DEMO_EMAIL`, `DEMO_PASSWORD` and `PORT` all override.

## The flow by hand, with `curl`

```sh
# discovery — everything the client needs is here
curl -s http://localhost:9292/.well-known/openid-configuration

# 1. sign in to the provider
curl -sc jar -o /dev/null -d 'email=a@b.c&password=hunter22' http://localhost:9292/login

# 2. authorize (skip_authorization is on, so there is no consent screen)
curl -sb jar -o /dev/null -w '%{redirect_url}\n' \
  'http://localhost:9292/oauth/authorize?client_id=demo-client&redirect_uri=http%3A%2F%2Flocalhost%3A9293%2Fauth%2Fprovider%2Fcallback&response_type=code&scope=openid+email&nonce=abc123'

# 3. exchange the code for an id_token
curl -s -d 'grant_type=authorization_code&client_id=demo-client&client_secret=demo-secret&redirect_uri=http%3A%2F%2Flocalhost%3A9293%2Fauth%2Fprovider%2Fcallback&code=<code>' \
  http://localhost:9292/oauth/token

# 4. the claims behind it
curl -s -H 'Authorization: Bearer <access_token>' http://localhost:9292/oauth/userinfo
```

## Not production

`skip_authorization` is on (no consent screen), the client secret is a literal
in the seed, and the demo user is created at boot. The RSA signing key is
generated once into `signing_key.pem` and never rotated.

[doorkeeper]: https://github.com/doorkeeper-gem/doorkeeper
[doorkeeper-openid_connect]: https://github.com/doorkeeper-gem/doorkeeper-openid_connect
[omniauth_openid_connect]: https://github.com/omniauth/omniauth_openid_connect

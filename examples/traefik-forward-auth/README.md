# traefik-forward-auth

```sh
docker compose up -d
```

## Test with `xh`

```sh
# 1. unauthenticated -> bounced to the login form
xh get http://localhost:80 --session=./cookie-jar.json 

# 2. register
xh post http://localhost:80/auth/identity/register --session=./cookie-jar.json \
  --form email=a@b.c password=hunter22 password_confirmation=hunter22

# 3. log in
xh get http://localhost:80/auth/identity/callback --session=./cookie-jar.json \
  auth_key==a@b.c password==hunter22

# 4. the protected page, showing the whole redirect chain
xh get http://localhost:80 --session=./cookie-jar.json --follow --all
```

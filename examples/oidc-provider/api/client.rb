# frozen_string_literal: true

# The relying party: a second ratalada server that logs in against app.rb over
# OpenID Connect. Nothing here knows anything about the provider beyond its
# issuer URL — the endpoints all come from /.well-known/openid-configuration.

require "ratalada/falcon"
require "rack/session/cookie"
require "rack/protection"
require "omniauth_openid_connect"

ISSUER = ENV.fetch("ISSUER", "http://localhost:9292")
PORT = Integer(ENV.fetch("PORT", "9293"))
CALLBACK = ENV.fetch("REDIRECT_URI", "http://localhost:#{PORT}/auth/provider/callback")

# The discovery gem builds the .well-known URL with URI::HTTPS unless told
# otherwise, and this example runs on plain http.
case URI.parse(ISSUER).scheme
when "http"
  SWD.url_builder = URI::HTTP
end

# Templates live after __END__, one per "@@ name" section.
TEMPLATES = DATA.read.scan(/^@@ *(\w+)\n(.*?)(?=^@@|\z)/m).to_h.freeze

def page(session)
  case session["auth"]
  in nil
    format(TEMPLATES.fetch("signed_out"), token: Rack::Protection::AuthenticityToken.token(session))
  in auth
    format(
      TEMPLATES.fetch("signed_in"),
      email: Rack::Utils.escape_html(auth["email"].to_s),
      sub:   Rack::Utils.escape_html(auth["sub"].to_s),
    )
  end
end

def html(body)
  [200, { "content-type" => "text/html", "cache-control" => "no-store" }, [body]]
end

Server
  .use(Rack::Session::Cookie, secret: ENV.fetch("SESSION_SECRET"), key: "ratalada.rp")
  .use(OmniAuth::Builder) do
    provider(
      :openid_connect,
      name:           :provider,
      issuer:         ISSUER,
      discovery:      true,
      scope:          %i[openid email],
      client_options: {
        identifier:   ENV.fetch("CLIENT_ID", "demo-client"),
        secret:       ENV.fetch("CLIENT_SECRET", "demo-secret"),
        redirect_uri: CALLBACK,
      },
    )
  end
  .run(host: ENV.fetch("HOST", "127.0.0.1"), port: PORT) do |request|
    case request
    in ["GET", "/"]
      html(page(request.env["rack.session"]))
    in [_, "/auth/provider/callback"]
      case request.env["omniauth.auth"]
      in nil
        [401, { "content-type" => "text/plain" }, ["unauthorized"]]
      in auth
        request.env["rack.session"]["auth"] = { "sub" => auth["uid"], "email" => auth["info"]["email"] }
        [302, { "location" => "/" }, []]
      end
    in ["GET", "/auth/failure"]
      [401, { "content-type" => "text/plain" }, ["#{Rack::Utils.parse_query(request.query)["message"]}\n"]]
    in ["GET", "/logout"]
      request.env["rack.session"].clear
      [302, { "location" => "/" }, []]
    end
  end

__END__
@@ signed_out
<!doctype html><meta charset=utf-8><title>relying party</title>
<form method=post action="/auth/provider">
  <input type=hidden name=authenticity_token value="%{token}">
  <button>sign in with the provider</button>
</form>

@@ signed_in
<!doctype html><meta charset=utf-8><title>relying party</title>
<p>signed in as %{email} (sub %{sub})</p>
<p><a href="/logout">sign out</a></p>

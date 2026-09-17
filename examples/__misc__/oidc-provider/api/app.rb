# frozen_string_literal: true

require "ratalada/falcon"
require "action_controller/railtie"
require "active_record"
require "bcrypt"
require "doorkeeper"
require "doorkeeper/openid_connect"
require "openssl"

ISSUER = ENV.fetch("ISSUER", "http://localhost:9292")
CLIENT_ID = ENV.fetch("CLIENT_ID", "demo-client")
CLIENT_SECRET = ENV.fetch("CLIENT_SECRET", "demo-secret")
REDIRECT_URI = ENV.fetch("REDIRECT_URI", "http://localhost:9293/auth/provider/callback")
NATIVE_CLIENT_ID = ENV.fetch("NATIVE_CLIENT_ID", "demo-native")
NATIVE_REDIRECT_URI = ENV.fetch("NATIVE_REDIRECT_URI", "acme://redirect")
# Doorkeeper takes a whitespace-separated list, so the Expo app gets both legs:
# its URI scheme on a device, the dev server origin on web.
WEB_REDIRECT_URI = ENV.fetch("WEB_REDIRECT_URI", "http://localhost:8081/redirect")

# Who is logged in, in one signed cookie. Doorkeeper only ever asks "which user
# is this request?", so a session store would be a store for one integer — and
# a rack session in the env would collide with the Rails app's own idea of
# `session` once the request crosses into the engine.
VERIFIER = ActiveSupport::MessageVerifier.new(ENV.fetch("SESSION_SECRET"), digest: "SHA256")
COOKIE = "ratalada.uid"

# One RSA key, kept on disk so the JWKS at /oauth/discovery/keys survives a
# restart and tokens issued before it still verify.
SIGNING_KEY_PATH = ENV.fetch("SIGNING_KEY_PATH", "signing_key.pem")
unless File.exist?(SIGNING_KEY_PATH)
  File.write(SIGNING_KEY_PATH, OpenSSL::PKey::RSA.new(2048).to_pem)
end
SIGNING_KEY = File.read(SIGNING_KEY_PATH)

ActiveRecord::Base.establish_connection(
  adapter:  "sqlite3",
  database: ENV.fetch("DATABASE", "provider.db"),
)
ActiveRecord::Schema.verbose = false

# Doorkeeper's own migration templates, minus the foreign keys, and idempotent
# so the example needs no migration step.
ActiveRecord::Schema.define do
  create_table :users, if_not_exists: true do |t|
    t.string :email, null: false, index: { unique: true }
    t.string :password_digest, null: false
  end

  create_table :oauth_applications, if_not_exists: true do |t|
    t.string :name, null: false
    t.string :uid, null: false, index: { unique: true }
    t.string :secret
    t.text :redirect_uri, null: false
    t.string :scopes, null: false, default: ""
    t.boolean :confidential, null: false, default: true
    t.timestamps null: false
  end

  create_table :oauth_access_grants, if_not_exists: true do |t|
    t.references :resource_owner, null: false
    t.references :application, null: false
    t.string :token, null: false, index: { unique: true }
    t.integer :expires_in, null: false
    t.text :redirect_uri, null: false
    t.string :scopes, null: false, default: ""
    t.datetime :created_at, null: false
    t.datetime :revoked_at
    t.string :code_challenge
    t.string :code_challenge_method
  end

  create_table :oauth_access_tokens, if_not_exists: true do |t|
    t.references :resource_owner, index: true
    t.references :application, null: false
    t.string :token, null: false, index: { unique: true }
    t.string :refresh_token, index: { unique: true }
    t.integer :expires_in
    t.string :scopes
    t.datetime :created_at, null: false
    t.datetime :revoked_at
    t.string :previous_refresh_token, null: false, default: ""
  end

  create_table :oauth_openid_requests, if_not_exists: true do |t|
    t.references :access_grant, null: false, index: true
    t.string :nonce, null: false
  end
end

class User < ActiveRecord::Base
  has_secure_password
end

Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    User.find_by(id: VERIFIER.verified(request.cookies[COOKIE].to_s)) ||
      redirect_to("/login?return_to=#{CGI.escape(request.fullpath)}")
  end

  # First-party client, so there is no consent screen to render — which is also
  # why this app needs none of Doorkeeper's views or an asset pipeline.
  skip_authorization { true }

  default_scopes :openid
  optional_scopes :email
  grant_flows %w[authorization_code]
  force_ssl_in_redirect_uri false
  base_controller "ActionController::Base"
end

Doorkeeper::OpenidConnect.configure do
  issuer ISSUER
  signing_key SIGNING_KEY
  subject { |resource_owner, _application| resource_owner.id }
  expiration 600

  resource_owner_from_access_token do |access_token|
    User.find_by(id: access_token.resource_owner_id)
  end

  auth_time_from_resource_owner { |_resource_owner| nil }

  reauthenticate_resource_owner do |_resource_owner, return_to|
    cookies.delete(COOKIE)
    redirect_to("/login?return_to=#{CGI.escape(return_to)}")
  end

  select_account_for_resource_owner do |_resource_owner, return_to|
    cookies.delete(COOKIE)
    redirect_to("/login?return_to=#{CGI.escape(return_to)}")
  end

  claims do
    normal_claim(:email) { |resource_owner| resource_owner.email }
  end
end

# A Rails app is here for exactly one reason: Doorkeeper is a Rails engine, so
# its routes and controllers need a router and an ActionController to live in.
# It never sees a request that isn't /oauth or /.well-known.
class Provider < Rails::Application
  config.load_defaults 8.0
  config.root = __dir__
  config.eager_load = false
  config.secret_key_base = ENV.fetch("SESSION_SECRET")
  config.hosts.clear
  config.logger = ActiveSupport::Logger.new($stdout)
  config.middleware.delete ActionDispatch::Session::CookieStore
end

Provider.initialize!

Provider.routes.draw do
  use_doorkeeper
  use_doorkeeper_openid_connect
end

User.find_or_create_by!(email: ENV.fetch("DEMO_EMAIL", "a@b.c")) do |user|
  user.password = ENV.fetch("DEMO_PASSWORD", "hunter22")
end

Doorkeeper::Application.find_or_create_by!(uid: CLIENT_ID) do |application|
  application.name = "demo client"
  application.secret = CLIENT_SECRET
  application.redirect_uri = REDIRECT_URI
  application.scopes = "openid email"
end

# The Expo app can't keep a secret, so it gets a public client and proves itself
# with PKCE instead.
Doorkeeper::Application.find_or_create_by!(uid: NATIVE_CLIENT_ID) do |application|
  application.name = "demo native client"
  application.secret = nil
  application.confidential = false
  application.redirect_uri = "#{NATIVE_REDIRECT_URI}\n#{WEB_REDIRECT_URI}"
  application.scopes = "openid email"
end

# Templates live after __END__, one per "@@ name" section.
TEMPLATES = DATA.read.scan(/^@@ *(\w+)\n(.*?)(?=^@@|\z)/m).to_h.freeze

def login_page(return_to, error: nil)
  format(
    TEMPLATES.fetch("login"),
    return_to: Rack::Utils.escape_html(return_to),
    error:     error ? "<p>#{Rack::Utils.escape_html(error)}</p>" : "",
  )
end

def html(body)
  [200, { "content-type" => "text/html", "cache-control" => "no-store" }, [body]]
end

def uid_cookie(value, max_age)
  Rack::Utils.set_cookie_header(
    COOKIE,
    value:     value,
    path:      "/",
    httponly:  true,
    same_site: :lax,
    max_age:   max_age,
  )
end

Server.run(host: ENV.fetch("HOST", "127.0.0.1"), port: Integer(ENV.fetch("PORT", "9292"))) do |request|
  case request
  in ["GET", "/login"]
    html(login_page(request.GET["return_to"] || "/"))

  in ["POST", "/login"]
    params = request.POST
    return_to = params["return_to"]

    if return_to.to_s.empty?
      return_to = "/"
    end

    case User.find_by(email: params["email"])&.authenticate(params["password"].to_s)
    in User => user
      headers = {
        "location"   => return_to,
        "set-cookie" => uid_cookie(VERIFIER.generate(user.id), 86_400),
      }

      [302, headers, []]
    else
      html(login_page(return_to, error: "bad credentials"))
    end

  in ["GET", "/logout"]
    [302, { "location" => "/login", "set-cookie" => uid_cookie("", 0) }, []]

  in ["GET", "/"]
    user_id = VERIFIER.verified(request.cookies[COOKIE].to_s)

    User.find_by(id: user_id).then do |user|
      if user
        status = "signed in as #{Rack::Utils.escape_html(user.email)}"
      else
        status = "signed out"
      end

      html(format(TEMPLATES.fetch("home"), status: status))
    end
  else
    # /oauth/authorize, /oauth/token, /oauth/userinfo, /oauth/discovery/keys and
    # /.well-known/openid-configuration all live in the engine.
    #
    # On web the Expo app fetches discovery, token and userinfo from its own
    # origin, so they need CORS or the browser drops the response before the
    # app sees it. No allow-credentials: none of these read the login cookie,
    # they carry their own code or bearer token.
    ->(req) do
      cors = {
        "access-control-allow-origin"  => req.get_header("HTTP_ORIGIN") || "*",
        "access-control-allow-headers" => "authorization, content-type",
        "vary"                         => "origin",
      }

      if req.verb == "OPTIONS"
        [204, cors, []]
      else
        status, headers, body = Provider.call(req.env)
        [status, headers.merge(cors), body]
      end
    end
  end
end

__END__
@@ login
<!doctype html><meta charset=utf-8><title>sign in</title>
<form method=post action="/login">
  <input type=hidden name=return_to value="%{return_to}">
  <label>email <input name=email autofocus></label>
  <label>password <input name=password type=password></label>
  <button>sign in</button>
</form>
%{error}

@@ home
<!doctype html><meta charset=utf-8><p>%{status}</p>

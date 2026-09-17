# frozen_string_literal: true

require "sequel"
require "sqlite3"
require "bcrypt"
require "rack/session"
require "omniauth"
require "omniauth-identity"
# Defines OmniAuth::Strategies::GoogleOauth2. Nothing here calls
# Bundler.require, so declaring the gem in the Gemfile is not enough: without
# this require the provider block below raises at boot.
require "omniauth-google-oauth2"
require "cgi"

require "ratalada/falcon"
require "ratalada/contrib/vite"
require "ratalada/contrib/inertia"
require "ratalada/contrib/router/file_based/sinatra_adapter"

SECRET = ENV.fetch("SESSION_SECRET", "dev" * 22)

# Falcon serves every request in a fiber, and many fibers share one thread.
# Sequel's connection pool keys checkouts on `Sequel.current`, which defaults to
# Thread.current — so two concurrent requests are handed the SAME connection and
# read each other's results. It does not fail as a clean error: on sqlite it
# surfaces as "prepare called on a closed database" on whichever query lost the
# race. This extension keys the pool on Fiber.current instead, which is what
# makes the pool actually isolate concurrent requests under falcon.
Sequel.extension :fiber_concurrency

DB = Sequel.sqlite(File.expand_path("config/database.sqlite", __dir__))

DB.create_table?(:accounts) do
  primary_key :id
  String :email, null: false, unique: true
  String :password_digest, null: false
  Integer :last_login_at
end

# The account, as omniauth-identity wants it: `locate` finds one by the fields
# the strategy was configured with, `authenticate` answers self or false.
class Account < Sequel::Model(:accounts)
  include OmniAuth::Identity::Model
  plugin :validation_helpers
  auth_key :email

  # Sequel's own `create` answers `save`, which is nil when validation fails
  # under raise_on_save_failure = false. omniauth-identity's
  # on_failed_registration needs the object so it can read .errors, so this
  # answers the instance either way.
  self.raise_on_save_failure = false

  def self.create(values) = new(values).tap(&:save)

  # omniauth hands conditions over with string keys.
  def self.locate(conditions) = first(conditions.transform_keys(&:to_sym))

  attr_accessor :password_confirmation
  attr_reader :password

  def persisted? = !new?

  # Past bcrypt's limit the digest is left alone and `validate` reports it on
  # :password — otherwise the account fails on a missing digest, which is true
  # but useless to whoever typed the password.
  def password=(plaintext)
    @password = plaintext
    return if plaintext.to_s.bytesize > BCrypt::Engine::MAX_SECRET_BYTESIZE

    self.password_digest = BCrypt::Password.create(plaintext)
  end

  # Answers self, not true — omniauth-identity's contract.
  def authenticate(attempt)
    BCrypt::Password.new(password_digest) == attempt ? self : false
  end

  def validate
    super
    validates_presence(%i[email password_digest])
    validates_unique(:email)
    if @password.to_s.bytesize > BCrypt::Engine::MAX_SECRET_BYTESIZE
      errors.add(:password, "is longer than bcrypt's 72 bytes")
    end
    if password_confirmation && password != password_confirmation
      errors.add(:password, "does not match confirmation")
    end
  end
end

# OmniAuth's own request-phase check is rack-protection's session-based
# authenticity token, which this app never issues: CSRF here is the Inertia
# double-submit cookie. Turning it off is only safe because CSRFMiddleware is
# mounted ABOVE OmniAuth below, so every non-GET — the Google request phase and
# the registration path included — is checked before a strategy sees it. Move
# that middleware back down and this line becomes a hole.
OmniAuth.config.request_validation_phase = nil

# OmniAuth's own failure page is an exception in development; this app wants
# the login page with an error on it instead.
OmniAuth.config.failure_raise_out_environments = []
OmniAuth.config.on_failure = lambda do |env|
  message = env["omniauth.error.type"]
  [303, { "location" => "/auth/failure?message=#{CGI.escape(message.to_s)}" }, []]
end

# Falcon's container FORKS its worker, and sqlite3 closes any writable
# connection a child inherits rather than risk two processes writing through
# one handle — which leaves every query in the worker failing with "prepare
# called on a closed database". The schema above needed a connection; the
# parent needs none after it, so it gives it back here and the worker opens its
# own on first use.
DB.disconnect

# Every page gets the signed-in user, so no route has to pass it. Registered
# here rather than in app/_layout.rb, which the router evaluates once per route
# file — this list is global and would collect a copy of the block each time.
Ratalada::Contrib::Inertia.share do
  { auth: { user: current_user&.to_hash&.slice(:id, :email) } }
end

Server
  .use(Ratalada::Contrib::Inertia::JsonParamsMiddleware)
  # Above OmniAuth deliberately — see request_validation_phase above.
  .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  # OmniAuth needs a session before it runs, so this replaces Sinatra's own
  # `enable :sessions` (which would sit inside the app, below the strategies).
  .use(Rack::Session::Cookie,
    secret:    SECRET,
    key:       "user-auth.session",
    httponly:  true,
    same_site: :lax,)
  .use(OmniAuth::Builder) do
    provider(
      :identity,
      model:                  Account,
      fields:                 %i[email],
      # The app serves its own /login page, so the strategy's built-in HTML
      # login form stays off. Credentials go straight to the callback phase at
      # /auth/identity/callback, which is what the form below posts to.
      enable_login:           false,
      on_failed_registration: lambda { |env|
        errors = env["omniauth.identity"]&.errors&.to_hash&.transform_values(&:first)
        env["rack.session"][:_inertia_errors] = errors || { email: "invalid" }
        [303, { "location" => "/signup" }, []]
      },
    )

    # Sign in with Google, mounted ONLY when both credentials are present:
    # omniauth-google-oauth2 raises at boot on a nil client id, and an example
    # checkout has none, so an unconditional provider would stop the app
    # starting at all. Without it the page renders with the form alone.
    if ENV["GOOGLE_CLIENT_ID"] && ENV["GOOGLE_CLIENT_SECRET"]
      provider(
        :google_oauth2,
        ENV.fetch("GOOGLE_CLIENT_ID"),
        ENV.fetch("GOOGLE_CLIENT_SECRET"),
        scope:  "email profile",
        prompt: "select_account",
      )
    end
  end
  .use(Ratalada::Contrib::Inertia::Middleware)
  .run do
    Ratalada::Contrib::Router::FileBased
      .mount(self, File.expand_path("app", __dir__))
  end

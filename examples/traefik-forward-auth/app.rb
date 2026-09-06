# frozen_string_literal: true

require "ratalada/falcon"
require "rack/session/cookie"
require "sequel"
require "extralite"
require "omniauth-identity"
require "bcrypt"

DB = Sequel.connect("extralite://identities.db")
DB.create_table?(:identities) do
  primary_key :id
  String :email, null: false, unique: true
  String :password_digest, null: false
  DateTime :created_at
  DateTime :updated_at
end

class Identity < Sequel::Model(:identities)
  include OmniAuth::Identity::Model
  plugin :validation_helpers
  auth_key :email

  # Registration hands back an unsaved record on failure instead of raising, so
  # the strategy's persisted? check drives the "one or more fields were invalid"
  # response rather than a 500.
  self.raise_on_save_failure = false

  # Sequel's Model.create returns save's value, which is nil once save failures
  # stop raising. The strategy calls persisted? on it, so hand back the record.
  def self.create(values) = new(values).tap(&:save)

  attr_accessor :password_confirmation
  attr_reader :password

  # auth_key comes back as a String, and Sequel reads String hash keys as
  # literals rather than columns, so symbolize before querying.
  def self.locate(conditions) = first(conditions.transform_keys(&:to_sym))

  def persisted? = !new?

  def password=(plaintext)
    @password = plaintext
    self.password_digest = BCrypt::Password.create(plaintext)
  end

  def authenticate(attempt)
    if BCrypt::Password.new(password_digest) == attempt
      self
    else
      false
    end
  end

  def validate
    super
    validates_unique :email
    if password_confirmation && password != password_confirmation
      errors.add(:password, "does not match confirmation")
    end
  end
end

Server
  .use(Rack::Session::Cookie, secret: ENV.fetch("SESSION_SECRET"), key: "ratalada.session")
  .use(OmniAuth::Builder) do
    provider :identity, model: Identity, fields: [:email]
  end
  .run(host: "0.0.0.0", port: Integer(ENV.fetch("PORT", "4181"))) do |request|
    case request
    in ["GET", "/auth"]
      # Falcon's default middleware stack includes Async::HTTP::Cache, which
      # would otherwise serve one visitor's verdict to everyone.
      if request.env["rack.session"][:identity_id]
        [200, { "cache-control" => "no-store" }, ["ok"]]
      else
        # Traefik rewrites a relative location against the auth server's own
        # address, which would send the browser to app:4181. Build the public
        # URL from the forwarded headers instead.
        proto = request.env["HTTP_X_FORWARDED_PROTO"] || "http"
        host = request.env["HTTP_X_FORWARDED_HOST"] || request.env["HTTP_HOST"]
        [302, { "location" => "#{proto}://#{host}/auth/identity", "cache-control" => "no-store" }, []]
      end
    in [_, "/auth/identity/callback"]
      if (auth = request.env["omniauth.auth"])
        request.env["rack.session"][:identity_id] = auth["uid"].to_s
        [302, { "location" => "/" }, []]
      else
        [401, { "content-type" => "text/plain" }, ["unauthorized"]]
      end
    end
  end
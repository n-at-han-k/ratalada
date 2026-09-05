# frozen_string_literal: true

# Run:  bundle exec ruby examples/hanami.rb
# Try:  curl http://localhost:9292/
#       curl http://localhost:9292/up
#       curl http://localhost:9292/greet/world
#       curl http://localhost:9292/admin/       # X-Request-Id, scoped middleware
#       curl http://localhost:9292/             # no X-Request-Id

require "ratalada/falcon"
require "ratalada/hanami"

# Hanami::API scopes middleware by path: this only wraps /admin.
class RequestId
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    [status, headers.merge("x-request-id" => env["HTTP_X_REQUEST_ID"] || "generated"), body]
  end
end

Server.run do
  get "/" do
    "hello from hanami-api on falcon\n"
  end

  get "/up" do
    "ok\n"
  end

  get "/greet/:name" do
    "hello #{params[:name]}\n"
  end

  scope "admin" do
    use RequestId

    get "/" do
      json(admin: true)
    end
  end
end

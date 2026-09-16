# frozen_string_literal: true

Adapter.load("ratalada/hanami")

# The Hanami frontend class-evals the Server.run block into a Hanami::API
# subclass and serves an instance of it. Hanami::API exposes `use` (scoped by
# path, unlike rack's) and a block context with `status`, `headers`, `json` and
# `halt` — this spec proves those survive the frontend intact.
RSpec.describe "Hanami frontend", adapter: "ratalada/hanami" do
  def build(&block) = Ratalada::Frontends::Hanami.build(block)

  it "returns the block's value as the body" do
    app = build do
      get "/" do
        "ok"
      end
    end

    status, _, body = app.call(env_for("GET", "/"))

    expect(status).to eq(200)
    expect(body).to eq(["ok"])
  end

  it "hands path variables over as params" do
    app = build do
      get "/users/:id" do
        "user #{params[:id]}"
      end
    end

    expect(app.call(env_for("GET", "/users/42"))[2]).to eq(["user 42"])
  end

  it "404s on an unmatched path" do
    app = build do
      get "/" do
        "ok"
      end
    end

    expect(app.call(env_for("GET", "/nope")).first).to eq(404)
  end

  context "with middleware around the route" do
    let(:app) do
      middleware = header_tagging_middleware("hanami-ran")

      build do
        use middleware

        get "/" do
          "ok"
        end
      end
    end

    it_behaves_like "a frontend that runs middleware", tag: "hanami-ran"
  end

  # The reason to reach for hanami-api over hanami-router: `use` inside a
  # `scope` only wraps that prefix. Rack's `use` can't do this.
  it "scopes middleware to the prefix it was declared under" do
    middleware = header_tagging_middleware("hanami-ran")

    app = build do
      scope "admin" do
        use middleware

        get "/" do
          "admin"
        end
      end

      get "/" do
        "root"
      end
    end

    expect(app.call(env_for("GET", "/admin"))[1]["X-Middleware"]).to eq("hanami-ran")
    expect(app.call(env_for("GET", "/"))[1]["X-Middleware"]).to be_nil
  end

  it "exposes the block context helpers" do
    app = build do
      get "/secret" do
        halt(401)
      end

      get "/data" do
        json(ok: true)
      end
    end

    expect(app.call(env_for("GET", "/secret")).first).to eq(401)
    expect(app.call(env_for("GET", "/data"))[2]).to eq(['{"ok":true}'])
  end
end

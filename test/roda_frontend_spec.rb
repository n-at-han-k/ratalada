# frozen_string_literal: true

Adapter.load("ratalada/roda")

# The Roda frontend class-evals the Server.run block into a Roda subclass and
# serves the frozen rack app. Roda's own DSL — `route`, `plugin` and `use` —
# is what the block sees; this spec proves those survive the frontend intact.
RSpec.describe "Roda frontend", adapter: "ratalada/roda" do
  def build(&block) = Ratalada::Frontends::Roda.build(block)

  def root_app
    build do
      route do |r|
        r.root do
          "ok"
        end
      end
    end
  end

  it "returns the root block's value as the body" do
    status, _, body = root_app.call(env_for("GET", "/"))

    expect(status).to eq(200)
    expect(body).to eq(["ok"])
  end

  # The routing tree is the reason to pick Roda: branch first, act on the way
  # down, match the verb last.
  it "branches down the routing tree and yields segments" do
    app = build do
      route do |r|
        r.on "users", Integer do |id|
          @greeting = "user #{id}"

          r.get "posts" do
            "#{@greeting} posts"
          end

          r.is do
            @greeting
          end
        end
      end
    end

    expect(app.call(env_for("GET", "/users/42"))[2]).to eq(["user 42"])
    expect(app.call(env_for("GET", "/users/42/posts"))[2]).to eq(["user 42 posts"])
  end

  it "404s on an unmatched path" do
    expect(root_app.call(env_for("GET", "/nope")).first).to eq(404)
  end

  context "with middleware around the route" do
    let(:app) do
      middleware = header_tagging_middleware("roda-ran")

      build do
        use middleware

        route do |r|
          r.root do
            "ok"
          end
        end
      end
    end

    it_behaves_like "a frontend that runs middleware", tag: "roda-ran"
  end

  # Roda is built out of plugins, so the class body has to be the block's
  # scope for the frontend to be worth anything.
  it "makes plugins available in the block" do
    app = build do
      plugin :json

      route do |r|
        r.root do
          { ok: true }
        end
      end
    end

    expect(app.call(env_for("GET", "/"))[2]).to eq(['{"ok":true}'])
  end

  it "freezes the app" do
    expect(root_app).to be_frozen
  end
end

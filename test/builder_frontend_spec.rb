# frozen_string_literal: true

Adapter.load("ratalada/builder")

# The Rack::Builder frontend hands the Server.run block straight to
# Rack::Builder, so `use`, `map` and `run` are rack's own and the app is built
# once. No Request sugar: `run` gets the raw env, like any rack app.
RSpec.describe "Rack::Builder frontend", adapter: "ratalada/builder" do
  def build(&block) = Ratalada::Frontends::Builder.build(block)

  context "with middleware wrapping a run app" do
    let(:app) do
      middleware = header_tagging_middleware("builder-ran")

      build do
        use middleware

        run ->(_env) { [200, { "content-type" => "text/plain" }, ["ok"]] }
      end
    end

    it_behaves_like "a frontend that runs middleware", tag: "builder-ran"
  end

  it "mounts an app under a prefix with `map`" do
    app = build do
      map "/admin" do
        run ->(_env) { [200, { "content-type" => "text/plain" }, ["admin"]] }
      end

      run ->(_env) { [200, { "content-type" => "text/plain" }, ["root"]] }
    end

    expect(app.call(env_for("GET", "/admin"))[2]).to eq(["admin"])
    expect(app.call(env_for("GET", "/"))[2]).to eq(["root"])
  end

  it "builds middleware once, not per request" do
    counter = instantiation_counter
    middleware = counting_middleware(counter)

    app = build do
      use middleware

      run ->(_env) { [200, {}, ["ok"]] }
    end
    3.times { app.call(env_for("GET", "/")) }

    expect(counter.count).to eq(1)
  end
end

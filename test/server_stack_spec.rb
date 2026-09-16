# frozen_string_literal: true

# Server.use(A).use(B).run { ... } wraps the app the frontend built, once, at
# boot. The middleware is plain rack middleware — it sees the env — so any
# existing rack middleware works, whichever frontend is active.
RSpec.describe Ratalada::Server::Stack do
  let(:router) { ->(_request) { "ok" } }

  def stack_for(*middleware)
    middleware.inject(Ratalada::Server) { |chain, m| chain.use(m) }.to_app(router)
  end

  it "chains `use` and wraps the app outermost first" do
    app = stack_for(env_tagging_middleware("outer"), env_tagging_middleware("inner"))
    env = env_for("GET", "/")

    _, _, body = app.call(env)

    expect(env["tags"]).to eq(%w[outer inner])
    expect(body).to eq(["ok"])
  end

  it "instantiates middleware once, not per request" do
    counter = instantiation_counter
    app = stack_for(counting_middleware(counter))

    3.times { app.call(env_for("GET", "/")) }

    expect(counter.count).to eq(1)
  end

  it "lets middleware short-circuit before the router runs" do
    blocker = Class.new do
      def initialize(app) = @app = app
      def call(_env) = [403, { "content-type" => "text/plain" }, ["nope"]]
    end
    never_runs = ->(_request) { raise "router must not run" }

    status, = Ratalada::Server.use(blocker).to_app(never_runs).call(env_for("GET", "/"))

    expect(status).to eq(403)
  end

  it "builds a bare app without any `use`" do
    app = described_class.new.to_app(router)

    expect(app.call(env_for("GET", "/")))
      .to eq([200, { "content-type" => "text/plain" }, ["ok"]])
  end

  it "still rejects a missing block" do
    expect { Ratalada::Server.use(env_tagging_middleware("a")).run }.to raise_error(ArgumentError)
  end

  it "still rejects a bad count" do
    expect { Ratalada::Server.run(count: 0) { |_r| "ok" } }.to raise_error(ArgumentError)
  end
end

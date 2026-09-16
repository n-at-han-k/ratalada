# frozen_string_literal: true

Adapter.load("ratalada/sinatra")

# The Sinatra frontend class-evals the Server.run block into a Sinatra::Base
# subclass and serves an instance of it. Sinatra::Base exposes `use`, so the
# resulting rack app can be wrapped in middleware exactly like any other Rack
# builder — this spec proves that path survives the frontend intact.
RSpec.describe "Sinatra frontend", adapter: "ratalada/sinatra" do
  let(:app) do
    middleware = header_tagging_middleware("sinatra-ran")

    Ratalada::Frontends::Sinatra.build(
      proc do
            use middleware

            get "/" do
              "ok"
            end
          end,
    )
  end

  it_behaves_like "a frontend that runs middleware", tag: "sinatra-ran"
end

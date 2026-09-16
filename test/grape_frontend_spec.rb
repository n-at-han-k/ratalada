# frozen_string_literal: true

Adapter.load("ratalada/grape")

# The Grape frontend class-evals the Server.run block into a Grape::API
# subclass. Grape's DSL exposes `use`, so the resulting rack app can be wrapped
# in middleware exactly like any other Rack builder — this spec proves that
# path survives the frontend intact.
RSpec.describe "Grape frontend", adapter: "ratalada/grape" do
  let(:app) do
    middleware = header_tagging_middleware("grape-ran")

    Ratalada::Frontends::Grape.build(
      proc do
            use middleware
            format :txt

            get "/" do
              "ok"
            end
          end,
    )
  end

  it_behaves_like "a frontend that runs middleware", tag: "grape-ran", header: "x-middleware"
end

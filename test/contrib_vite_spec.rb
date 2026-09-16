# frozen_string_literal: true

Adapter.load("ratalada/contrib/vite")

RSpec.describe "Ratalada::Contrib::Vite::DevServerProxy", adapter: "ratalada/contrib/vite" do
  let(:inner) { ->(_env) { [200, {}, ["app"]] } }

  it "passes through when the dev server is not running" do
    allow(ViteRuby).to receive(:run_proxy?).and_return(false)

    middleware = Ratalada::Contrib::Vite::DevServerProxy.new(inner)

    expect(middleware.call({})).to eq([200, {}, ["app"]])
  end

  it "wraps the app in ViteRuby's proxy when the dev server is running" do
    allow(ViteRuby).to receive(:run_proxy?).and_return(true)

    middleware = Ratalada::Contrib::Vite::DevServerProxy.new(inner)

    expect(middleware.instance_variable_get(:@app)).to be_a(ViteRuby::DevServerProxy)
  end
end

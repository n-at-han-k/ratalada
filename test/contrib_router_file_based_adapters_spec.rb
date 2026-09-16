# frozen_string_literal: true

require "tmpdir"
require "fileutils"

Adapter.load("ratalada/contrib/router/file_based/sinatra_adapter")
Adapter.load("ratalada/contrib/router/file_based/grape_adapter")
Adapter.load("ratalada/contrib/router/file_based/hanami_adapter")

# One tree, three frontends. Every file is ordinary DSL for its frontend — the
# only thing the adapters add is where in the URL space the file's own routes
# land, which is what the path spells.
RSpec.shared_examples "a file-based router" do |builder|
  tree = {
    "index.rb"                       => %(get("/") { "home" }),
    # A layout is not a route file; its contents are evaluated into each route
    # file below it, so its routes exist once per file, under that file's prefix.
    "_layout.rb"                     => %(get("/ping") { "pong" }),
    "teams/_layout.rb"               => %(get("/whoami") { "team layout" }),
    "(marketing)/pricing.rb"         => %(get("/") { "pricing" }),
    "teams/[team]/settings/index.rb" => <<~SOURCE,
      get("/") { "settings for \#{params[:team]}" }
      get("/members") { "members of \#{params[:team]}" }
    SOURCE
  }

  around do |example|
    Dir.mktmpdir do |root|
      tree.each do |file, source|
        FileUtils.mkdir_p(File.join(root, File.dirname(file)))
        File.write(File.join(root, file), source)
      end

      @app = builder.call(root)
      example.run
    end
  end

  def get(path)
    status, _headers, body = @app.call(env_for("GET", path))

    [status, body.each.to_a.join]
  end

  it "serves a root index.rb at /" do
    expect(get("/")).to eq([200, "home"])
  end

  it "drops (group) directories from the path" do
    expect(get("/pricing")).to eq([200, "pricing"])
  end

  it "prepends the file's prefix, params included, to the routes inside it" do
    expect(get("/teams/acme/settings")).to eq([200, "settings for acme"])
    expect(get("/teams/acme/settings/members")).to eq([200, "members of acme"])
  end

  it "evaluates a root _layout.rb into every route file below it" do
    expect(get("/ping")).to eq([200, "pong"])
    expect(get("/teams/acme/settings/ping")).to eq([200, "pong"])
    expect(get("/pricing/ping")).to eq([200, "pong"])
  end

  it "evaluates a nested _layout.rb only into the files under it" do
    expect(get("/teams/acme/settings/whoami")).to eq([200, "team layout"])
    expect(get("/whoami").first).to eq(404)
  end

  it "404s a path no file spells" do
    expect(get("/teams/acme/nope").first).to eq(404)
  end
end

RSpec.describe "Ratalada::Contrib::Router::FileBased::SinatraAdapter", adapter: "ratalada/contrib/router/file_based/sinatra_adapter" do
  it_behaves_like "a file-based router", ->(root) { Ratalada::Contrib::Router::FileBased::SinatraAdapter.build(root) }
end

RSpec.describe "Ratalada::Contrib::Router::FileBased::GrapeAdapter", adapter: "ratalada/contrib/router/file_based/grape_adapter" do
  it_behaves_like "a file-based router", ->(root) { Ratalada::Contrib::Router::FileBased::GrapeAdapter.build(root) }
end

RSpec.describe "Ratalada::Contrib::Router::FileBased::HanamiAdapter", adapter: "ratalada/contrib/router/file_based/hanami_adapter" do
  it_behaves_like "a file-based router", ->(root) { Ratalada::Contrib::Router::FileBased::HanamiAdapter.build(root) }
end

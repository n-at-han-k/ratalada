# frozen_string_literal: true

require "tmpdir"
require "fileutils"

Adapter.load("ratalada/contrib/router/file_based/sinatra_adapter")
Adapter.load("ratalada/contrib/router/file_based/grape_adapter")
Adapter.load("ratalada/contrib/router/file_based/hanami_adapter")

# One tree, three frontends. Every file is ordinary DSL for its frontend — the
# only thing the adapters add is where in the URL space the file's own routes
# land, which is what the path spells.
RSpec.shared_examples "a file-based router" do |frontend|
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
    previous = Ratalada.frontend
    Ratalada.config.frontend = frontend

    Dir.mktmpdir do |root|
      tree.each do |file, source|
        FileUtils.mkdir_p(File.join(root, File.dirname(file)))
        File.write(File.join(root, file), source)
      end

      @app = Ratalada::Contrib::Router::FileBased.build(root)
      example.run
    end
  ensure
    Ratalada.config.frontend = previous
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
  it_behaves_like "a file-based router", Ratalada::Frontends::Sinatra
end

# Sinatra's own pattern syntax cannot spell a hyphenated parameter -- `:user-id`
# is the capture `user` then the literal `-id` -- so the adapter keeps the Expo
# pattern the file path already is.
RSpec.describe "Ratalada::Contrib::Router::FileBased::SinatraAdapter hyphens", adapter: "ratalada/contrib/router/file_based/sinatra_adapter" do
  around do |example|
    previous = Ratalada.frontend
    Ratalada.config.frontend = Ratalada::Frontends::Sinatra

    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.join(root, "activitypub/user-id/[user-id]"))
      File.write(
        File.join(root, "activitypub/user-id/[user-id]/index.rb"),
        %(get("/") { params["user-id"] }),
      )

      @app = Ratalada::Contrib::Router::FileBased.build(root)
      example.run
    end
  ensure
    Ratalada.config.frontend = previous
  end

  it "routes a hyphenated parameter and captures it under that name" do
    status, _headers, body = @app.call(env_for("GET", "/activitypub/user-id/7"))

    expect([status, body.each.to_a.join]).to eq([200, "7"])
  end
end

RSpec.describe "Ratalada::Contrib::Router::FileBased::GrapeAdapter", adapter: "ratalada/contrib/router/file_based/grape_adapter" do
  it_behaves_like "a file-based router", Ratalada::Frontends::Grape
end

RSpec.describe "Ratalada::Contrib::Router::FileBased::HanamiAdapter", adapter: "ratalada/contrib/router/file_based/hanami_adapter" do
  it_behaves_like "a file-based router", Ratalada::Frontends::Hanami
end

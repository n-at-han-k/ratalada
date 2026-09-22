# frozen_string_literal: true

require "tmpdir"
require "fileutils"

require_relative "../lib/ratalada/contrib/router/file_based"

RSpec.describe Ratalada::Contrib::Router::FileBased do
  def with_tree(*files)
    Dir.mktmpdir do |root|
      files.each do |file|
        FileUtils.mkdir_p(File.join(root, File.dirname(file)))
        FileUtils.touch(File.join(root, file))
      end

      yield described_class.build_map(root), root
    end
  end

  it "maps index, dynamic, catch-all and group files to patterns" do
    files = [
      "index.rb",
      "(marketing)/pricing.rb",
      "teams/index.rb",
      "teams/[team]/settings/index.rb",
      "docs/[...path].rb",
      "_metacontroller/sync.rb",
      "+not-found.rb",
    ]

    with_tree(*files) do |map, root|
      expect(map).to eq(
        ""                      => [File.join(root, "index.rb")],
        "/docs/*path"           => [File.join(root, "docs/[...path].rb")],
        "/pricing"              => [File.join(root, "(marketing)/pricing.rb")],
        "/teams"                => [File.join(root, "teams/index.rb")],
        "/teams/:team/settings" => [File.join(root, "teams/[team]/settings/index.rb")],
        "/*unmatched"           => [File.join(root, "+not-found.rb")],
      )
    end
  end

  it "puts the layouts above a route file in front of it, outermost first" do
    files = [
      "_layout.rb",
      "index.rb",
      "teams/_layout.rb",
      "teams/[team]/_layout.rb",
      "teams/[team]/settings/index.rb",
      "docs.rb",
    ]

    with_tree(*files) do |map, root|
      expect(map.fetch("/teams/:team/settings")).to eq(
        [
          File.join(root, "_layout.rb"),
          File.join(root, "teams/_layout.rb"),
          File.join(root, "teams/[team]/_layout.rb"),
          File.join(root, "teams/[team]/settings/index.rb"),
        ],
      )

      # A layout applies below itself only: /docs sees the root one, nothing else.
      expect(map.fetch("/docs")).to eq([File.join(root, "_layout.rb"), File.join(root, "docs.rb")])
    end
  end

  it "orders static segments ahead of dynamic ones and the fallback last" do
    with_tree(
      "+not-found.rb",
      "[slug].rb",
      "teams.rb",
      "[...rest].rb",
    ) do |map, _root|
      expect(map.keys).to eq(["/teams", "/:slug", "/*rest", "/*unmatched"])
    end
  end

  it "orders a segment that spells a literal ahead of the bare capture" do
    with_tree(
      "pulls/[index].rb",
      "pulls/[index].[diffType].rb",
    ) do |map, _root|
      # Both match "/pulls/7.diff"; the one that spells the dot means it.
      expect(map.keys).to eq(["/pulls/:index.:diffType", "/pulls/:index"])
    end
  end

  it "spells placeholders the way the adapter asks" do
    with_tree("teams/[team].rb") do |map, _root|
      expect(map.keys).to eq(["/teams/:team"])
    end

    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.join(root, "teams"))
      FileUtils.touch(File.join(root, "teams/[team].rb"))

      map = described_class.build_map(root, placeholder: "{%s}", catch_all: "{/%s*}")

      expect(map.keys).to eq(["/teams/{team}"])
    end
  end

  it "hangs a file's own routes off its prefix" do
    expect(described_class.join("/organizations/:slug", "/users")).to eq("/organizations/:slug/users")
    expect(described_class.join("/organizations/:slug", "/")).to eq("/organizations/:slug")
    expect(described_class.join("", "/")).to eq("/")
    expect(described_class.join("", "/login")).to eq("/login")
  end
end

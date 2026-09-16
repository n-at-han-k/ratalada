# frozen_string_literal: true

# Each gem in this repo carries its own version, changelog and tag, and is
# released on its own schedule with `gem kit release --gem <name>`. What still
# has to hold across all of them is smaller than it used to be, but it is the
# part that ships a broken gem when it drifts:
#
#   - every file a gemspec promises is actually there (the adapters share one
#     lib/ tree and name their files individually, so a new file is easy to
#     add and easy to forget)
#   - every adapter's requirement on the core gem is one the core satisfies
RSpec.describe "packaging" do
  ROOT = File.expand_path("..", __dir__)
  GEMS = %w[ratalada ratalada-sinatra ratalada-grape ratalada-hanami ratalada-roda
            ratalada-contrib
].freeze
  ADAPTERS = (GEMS - %w[ratalada]).freeze

  def gemspec(name)
    Gem::Specification.load(File.join(ROOT, "#{name}.gemspec")) or
      raise "could not load #{name}.gemspec"
  end

  def version_literal(relative_path)
    File.read(File.join(ROOT, relative_path))[/VERSION\s*=\s*["']([^"']+)["']/, 1]
  end

  GEMS.each do |name|
    describe "#{name}.gemspec" do
      it "ships only files that exist" do
        gemspec(name).files.each do |file|
          expect(File.exist?(File.join(ROOT, file)))
            .to be(true), "#{name}.gemspec ships #{file}, which is not in the repo"
        end
      end

      # `gem kit` derives the changelog path from the gem name whenever a repo
      # holds more than one gemspec. A missing one is only discovered at release.
      it "has its own changelog" do
        path = File.join(ROOT, "CHANGELOG-#{name}.md")

        expect(File.exist?(path))
          .to be(true), "#{name} has no CHANGELOG-#{name}.md (gem kit release reads it)"
      end
    end
  end

  ADAPTERS.each do |name|
    describe "#{name}.gemspec" do
      # The version file is the one `gem kit bump --gem <name>` rewrites, so a
      # gem whose gemspec does not ship it releases a version nobody can read
      # back.
      it "ships its own version file, agreeing with the gemspec" do
        expected = "lib/#{name.tr("-", "/")}/version.rb"

        expect(gemspec(name).files).to include(expected), "#{name}.gemspec must ship #{expected}"
        expect(gemspec(name).version.to_s)
          .to eq(version_literal(expected)), "#{name}.gemspec and #{expected} disagree"
      end

      # The versions drift now, so the adapters ask for a range rather than an
      # exact core — but a range the current core does not satisfy is a gem
      # that cannot be installed alongside the repo it lives in.
      it "requires a core version this repo satisfies" do
        core = gemspec("ratalada").version
        dep = gemspec(name).dependencies.find { |d| d.name == "ratalada" }

        expect(dep).not_to be_nil, "#{name} must depend on ratalada"
        expect(dep.requirement.satisfied_by?(core))
          .to be(true), "#{name} requires ratalada #{dep.requirement}, which #{core} does not satisfy"
      end
    end
  end
end

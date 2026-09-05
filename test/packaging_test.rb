# frozen_string_literal: true

require "test_helper"

# Each gem in this repo carries its own version, changelog and tag, and is
# released on its own schedule with `gem kit release --gem <name>`. What still
# has to hold across all of them is smaller than it used to be, but it is the
# part that ships a broken gem when it drifts:
#
#   - every file a gemspec promises is actually there (the adapters share one
#     lib/ tree and name their files individually, so a new file is easy to
#     add and easy to forget)
#   - every adapter's requirement on the core gem is one the core satisfies
class PackagingTest < Minitest::Test
  ROOT     = File.expand_path("..", __dir__)
  GEMS     = %w[ratalada ratalada-sinatra ratalada-grape ratalada-hanami ratalada-roda].freeze
  ADAPTERS = GEMS - %w[ratalada]

  def test_every_gemspec_ships_files_that_exist
    GEMS.each do |name|
      gemspec(name).files.each do |file|
        assert File.exist?(File.join(ROOT, file)),
               "#{name}.gemspec ships #{file}, which is not in the repo"
      end
    end
  end

  # The version file is the one `gem kit bump --gem <name>` rewrites, so a gem
  # whose gemspec does not ship it releases a version nobody can read back.
  def test_every_adapter_ships_its_own_version_file
    ADAPTERS.each do |name|
      expected = "lib/#{name.tr("-", "/")}/version.rb"
      assert_includes gemspec(name).files, expected,
                      "#{name}.gemspec must ship #{expected}"
      assert_equal gemspec(name).version.to_s, version_literal(expected),
                   "#{name}.gemspec and #{expected} disagree"
    end
  end

  # The versions drift now, so the adapters ask for a range rather than an
  # exact core — but a range the current core does not satisfy is a gem that
  # cannot be installed alongside the repo it lives in.
  def test_adapters_require_a_core_version_this_repo_satisfies
    core = gemspec("ratalada").version

    ADAPTERS.each do |name|
      dep = gemspec(name).dependencies.find { |d| d.name == "ratalada" }
      refute_nil dep, "#{name} must depend on ratalada"
      assert dep.requirement.satisfied_by?(core),
             "#{name} requires ratalada #{dep.requirement}, which #{core} does not satisfy"
    end
  end

  # `gem kit` derives the changelog path from the gem name whenever a repo
  # holds more than one gemspec. A missing one is only discovered at release.
  def test_every_gem_has_its_own_changelog
    GEMS.each do |name|
      path = File.join(ROOT, "CHANGELOG-#{name}.md")
      assert File.exist?(path), "#{name} has no CHANGELOG-#{name}.md (gem kit release reads it)"
    end
  end

  private

  def gemspec(name)
    Gem::Specification.load(File.join(ROOT, "#{name}.gemspec")) or
      raise "could not load #{name}.gemspec"
  end

  def version_literal(relative_path)
    File.read(File.join(ROOT, relative_path))[/VERSION\s*=\s*["']([^"']+)["']/, 1]
  end
end

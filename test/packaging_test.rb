# frozen_string_literal: true

require "test_helper"
require "bundler"

# The three gems (ratalada, ratalada-sinatra, ratalada-grape) share one version
# — Ratalada::VERSION — and one lib/ tree. Drift is the failure mode: a gemspec
# left on the old version, an adapter pinning the wrong core version, or a
# lockfile not regenerated after a bump. Any of those ships a broken release
# that resolves to the wrong thing. These tests are the guard rail; bump the
# version with bin/increment-version (which re-locks) and they stay green.
class PackagingTest < Minitest::Test
  ROOT     = File.expand_path("..", __dir__)
  GEMS     = %w[ratalada ratalada-sinatra ratalada-grape].freeze
  ADAPTERS = %w[ratalada-sinatra ratalada-grape].freeze

  # file -> the gems whose path specs it should pin at the current version
  LOCKFILES = {
    "Gemfile.lock"                  => %w[ratalada],
    "gemfiles/grape.gemfile.lock"   => %w[ratalada ratalada-grape],
    "gemfiles/sinatra.gemfile.lock" => %w[ratalada ratalada-sinatra],
  }.freeze

  def test_all_gemspecs_share_the_current_version
    GEMS.each do |name|
      assert_equal Ratalada::VERSION, gemspec(name).version.to_s,
                   "#{name}.gemspec version drifted from Ratalada::VERSION"
    end
  end

  def test_adapters_pin_core_to_the_exact_current_version
    ADAPTERS.each do |name|
      dep = gemspec(name).dependencies.find { |d| d.name == "ratalada" }
      refute_nil dep, "#{name} must depend on ratalada"
      assert_equal "= #{Ratalada::VERSION}", dep.requirement.to_s,
                   "#{name} must pin ratalada to exactly the current version"
    end
  end

  def test_lockfiles_are_in_sync_with_the_current_version
    LOCKFILES.each do |file, pinned_gems|
      path = File.join(ROOT, file)
      assert File.exist?(path), "#{file} is missing — run bin/increment-version to regenerate locks"

      specs = Bundler::LockfileParser.new(File.read(path)).specs.to_h { |s| [s.name, s.version.to_s] }
      pinned_gems.each do |g|
        assert_equal Ratalada::VERSION, specs[g],
                     "#{file} pins #{g} #{specs[g].inspect}; expected #{Ratalada::VERSION} — regenerate the lockfile"
      end
    end
  end

  private

  def gemspec(name)
    Gem::Specification.load(File.join(ROOT, "#{name}.gemspec")) or
      raise "could not load #{name}.gemspec"
  end
end

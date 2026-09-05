# frozen_string_literal: true

source "https://rubygems.org"

# The gems this repo develops — ratalada and its four frontend adapters — are
# deliberately absent. They are the repository, not dependencies of it: the
# devshell puts this lib/ on RUBYLIB, so `require "ratalada/roda"` finds the
# working tree. Nothing here records a gem's version, so a version bump has no
# lockfile to keep in step.
#
# Listing the dependencies outright rather than through `gemspec` is also what
# bundlerEnv needs, since it resolves against a store directory holding only a
# Gemfile and a lockfile, with no gemspec to read.

# Backends the core gem wraps
gem "falcon"
gem "puma"
gem "rack"

# Frontends the adapters wrap. Grape is held at 3.2 on purpose: 3.3.0 moved to
# `mustermann >= 4.0`, while sinatra and hanami-router both want `~> 3.0`, and
# one bundle resolves one mustermann for all of them. 3.2.1 asks for
# mustermann-grape, whose own requirement is open-ended, so everything lands on
# mustermann 3.1.1 together. ratalada-grape.gemspec is unaffected — users
# installing that gem alone can have any grape it allows.
gem "grape", "~> 3.2.0"
gem "hanami-api"
gem "roda"
gem "sinatra"

# Tooling. gem_kit-release registers the `gem kit` command RubyGems runs the
# release through; it is a tool this repo is released with, not something the
# library needs at runtime, so it belongs here and not in a gemspec.
gem "gem_kit-release", "~> 0.3"
gem "lefthook", "~> 2.1"
gem "minitest", "~> 5.0"
gem "rake", "~> 13.0"
gem "rubocop", "~> 1.60"

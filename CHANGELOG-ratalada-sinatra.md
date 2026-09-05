# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.1] - 2026-08-25

### Changed

- Released alongside `ratalada` 1.0.1. No adapter changes; the gems shared one
  version at the time, so this entry records the release, not a difference.

## [1.0.0] - 2026-07-09

### Added

- **The `ratalada-sinatra` gem.** `require "ratalada/sinatra"` class-evaluates the
  `Server.run` block into an anonymous Sinatra application. Split out of the core
  `ratalada` gem so its dependencies stay out of everyone else's bundle; the
  require path is unchanged.

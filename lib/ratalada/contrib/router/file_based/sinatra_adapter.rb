# frozen_string_literal: true

require "ratalada/sinatra"

require_relative "../file_based"

module Ratalada
  module Contrib
    module Router
      module FileBased
        # Teaches Sinatra `route_prefix`: every route defined while it is set
        # hangs off it, which is how a route file's own `get "/members"` lands
        # under the prefix its path spelled.
        module SinatraAdapter
          # Expo spelling, kept all the way to the pattern. Sinatra's own
          # syntax has no way to say `[user-id]`: `:user-id` reads as the
          # capture `user` followed by the literal `-id`, so a hyphenated
          # parameter silently routes nowhere. Mustermann::Expo is the pattern
          # the file path already is.
          SPELLING = {placeholder: "[%s]", catch_all: "[...%s]"}.freeze

          def route_spelling = SPELLING

          # ONE APP PER ROUTE FILE, NOT ONE FOR THE TREE. `use`, `set`, `before`,
          # `error` and `helpers` are all class-level Sinatra DSL, so evaluating
          # every file into a single Sinatra::Base makes a _layout.rb reach files
          # it does not sit above: an app/(api)/_layout.rb with
          # `before { content_type(:json) }` relabels every HTML page in the tree.
          # A layout is meant to scope those to its own subtree, which it can only
          # do if the files under it have a class of their own.
          #
          # So each route file (with the layouts above it) becomes its own
          # subclass, and they are chained: a Sinatra app used as rack middleware
          # forwards the request on when none of its own routes matched
          # (Base#route_missing), so the first file that spells the path answers
          # and the rest fall through. build_map already orders them
          # most-specific-first.
          #
          # ponytail: one middleware hop per route file, walked per request.
          # Collapse the leaves into one class if a fat tree ever shows up in a
          # profile -- the isolation is the point, not the chain.
          def mount_files(parent, map)
            map.each do |prefix, paths|
              child = Class.new(::Sinatra::Base)
              child.route_prefix = prefix
              paths.each { |path| child.class_eval(File.read(path), path, 1) }

              parent.use(child)
            end
          end

          def route(verb, path, options = {}, &block)
            unless route_prefix.to_s.empty?
              path = Mustermann.new(FileBased.join(route_prefix, path), type: :expo)
            end

            super(
              verb,
              path,
              options,
              &block
            )
          end
        end
      end
    end
  end
end

class Sinatra::Base # rubocop:disable Style/ClassAndModuleChildren
  set :route_prefix, ""

  class << self
    prepend Ratalada::Contrib::Router::FileBased::SinatraAdapter
  end
end

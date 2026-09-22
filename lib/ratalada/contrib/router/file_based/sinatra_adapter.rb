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

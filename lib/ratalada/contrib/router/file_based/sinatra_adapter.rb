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
          def route(verb, path, options = {}, &block)
            unless route_prefix.to_s.empty?
              path = FileBased.join(route_prefix, path)
            end

            super
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

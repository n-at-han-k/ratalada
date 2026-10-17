# frozen_string_literal: true

require "ratalada/grape"

require_relative "../file_based"

module Ratalada
  module Contrib
    module Router
      module FileBased
        # Teaches Grape `route_prefix`, as Sinatra does.
        module GrapeAdapter
          def route(methods, paths = ["/"], route_options = {}, &block)
            unless route_prefix.to_s.empty?
              paths = Array(paths).map { |path| FileBased.join(route_prefix, path.to_s) }
            end

            super
          end
        end
      end
    end
  end
end

class Grape::API::Instance # rubocop:disable Style/ClassAndModuleChildren
  class << self
    attr_accessor :route_prefix

    prepend Ratalada::Contrib::Router::FileBased::GrapeAdapter
  end
end

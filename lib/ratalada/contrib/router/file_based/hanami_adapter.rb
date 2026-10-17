# frozen_string_literal: true

require "ratalada/hanami"

require_relative "../file_based"

module Ratalada
  module Contrib
    module Router
      module FileBased
        # Teaches Hanami::API `route_prefix`, via its router's path prefix.
        module HanamiAdapter
          def route_prefix=(prefix)
            @router.instance_variable_set(:@path_prefix, ::Hanami::Router::Prefix.new("/").join(prefix.to_s))
          end
        end
      end
    end
  end
end

Hanami::API.extend(Ratalada::Contrib::Router::FileBased::HanamiAdapter)

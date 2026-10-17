# frozen_string_literal: true

require "rack"
require_relative "../ratalada"

module Ratalada
  module Frontends
    # Rack::Builder as the DSL; the run block is rack's.
    module Builder
      def self.build(block)
        ::Rack::Builder.new(&block).to_app
      end
    end
  end

  config.frontend = Frontends::Builder
end

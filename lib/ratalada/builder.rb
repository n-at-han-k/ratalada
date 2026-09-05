# frozen_string_literal: true

require "rack"
require_relative "../ratalada"

module Ratalada
  module Frontends
    # Rack::Builder as the DSL: the Server.run block is a rack builder block,
    # so `use`, `map` and `run` are rack's own, built once at boot. No Request
    # sugar here — `run` hands the app a raw env, like any rack app.
    module Builder
      def self.build(block)
        ::Rack::Builder.new(&block).to_app
      end
    end
  end

  self.frontend = Frontends::Builder
end

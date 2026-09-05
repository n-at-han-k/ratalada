# frozen_string_literal: true

require "roda"
require "ratalada"

module Ratalada
  module Frontends
    # Roda is a class-level DSL, so the Server.run block is class-evaled into an
    # anonymous subclass — which is what makes `plugin` and `use` available
    # alongside `route`. Freezing is Roda's recommended production setup (it
    # turns thread-unsafe app mutation into an error) and `.app` skips a couple
    # of method calls per request.
    module Roda
      def self.build(block)
        app = Class.new(::Roda)
        app.class_eval(&block)
        app.freeze.app
      end
    end
  end

  self.frontend = Frontends::Roda
end

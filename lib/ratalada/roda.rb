# frozen_string_literal: true

require "roda"
require "ratalada"

module Ratalada
  module Frontends
    # Roda as the DSL, class-evaled into a frozen anonymous subclass.
    module Roda
      def self.build(block)
        app = Class.new(::Roda)
        app.class_eval(&block)
        app.freeze.app
      end
    end
  end

  config.frontend = Frontends::Roda
end

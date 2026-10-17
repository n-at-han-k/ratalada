# frozen_string_literal: true

require "hanami/api"
require "ratalada"

module Ratalada
  module Frontends
    # Hanami::API as the DSL, class-evaled into an anonymous subclass.
    module Hanami
      def self.build(block)
        app = Class.new(::Hanami::API)
        app.class_eval(&block)
        app.new
      end
    end
  end

  config.frontend = Frontends::Hanami
end

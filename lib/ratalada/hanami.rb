# frozen_string_literal: true

require "hanami/api"
require "ratalada"

module Ratalada
  module Frontends
    # Hanami::API is a class-level DSL, so the Server.run block is class-evaled
    # into an anonymous subclass. Hanami::API.new builds the rack app and
    # deep-freezes it, so this happens once, at boot.
    module Hanami
      def self.build(block)
        app = Class.new(::Hanami::API)
        app.class_eval(&block)
        app.new
      end
    end
  end

  self.frontend = Frontends::Hanami
end

# frozen_string_literal: true

require "grape"
require "ratalada"

module Ratalada
  module Frontends
    module Grape
      def self.build(block)
        app = Class.new(::Grape::API)
        app.class_eval(&block)
        app
      end
    end
  end

  self.frontend = Frontends::Grape
end

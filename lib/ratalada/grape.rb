# frozen_string_literal: true

require "grape"
require "ratalada"

module Ratalada
  module Frontends
    module Grape
      def self.build(block)
        Class.new(::Grape::API).tap do |app|
          app.class_eval(&block)
        end
      end
    end
  end

  config.frontend = Frontends::Grape
end

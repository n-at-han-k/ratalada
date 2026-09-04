# frozen_string_literal: true

require "sinatra/base"
require "ratalada"

module Ratalada
  module Frontends
    module Sinatra
      def self.build(block)
        app = Class.new(::Sinatra::Base)
        app.class_eval(&block)
        app.new
      end
    end
  end

  self.frontend = Frontends::Sinatra
end

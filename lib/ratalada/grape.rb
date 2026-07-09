# frozen_string_literal: true

require "grape"
require "ratalada"

module Ratalada
  module Frontends
    # Grape-flavoured DSL: the Server.run block is class-evaluated into an
    # anonymous Grape::API, so `get "/" do ... end`, `resource`, `params`, etc.
    # all work. A Grape::API subclass is itself the rack app, so we hand the
    # class straight to the backend.
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

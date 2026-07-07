# frozen_string_literal: true

require "sinatra/base"
require_relative "../ratalada"

module Ratalada
  module Frontends
    # Sinatra-flavoured DSL: the Server.run block is class-evaluated into an
    # anonymous Sinatra application, so `get "/" do ... end` etc. all work.
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

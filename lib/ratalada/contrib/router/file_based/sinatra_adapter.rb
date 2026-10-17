# frozen_string_literal: true

require "ratalada/sinatra"

require_relative "../file_based"

module Ratalada
  module Contrib
    module Router
      module FileBased
        # Teaches Sinatra `route_prefix`.
        module SinatraAdapter
          # Expo spelling, kept all the way to the pattern. Sinatra's own syntax has no way to say `[user-id]`: `:user-id` reads as the capture `user` followed by the literal `-id`, so a hyphenated parameter silently routes nowhere. Mustermann::Expo is the pattern the file path already is.
          SPELLING = {placeholder: "[%s]", catch_all: "[...%s]"}.freeze

          def route_spelling = SPELLING

          # Gives each route file its own Sinatra subclass, chained as middleware.
          #
          # @parameter parent [Class] the app the subclasses mount on.
          # @parameter map [Hash] route prefix => the files under it.
          # @returns [void]
          def mount_files(parent, map)
            map.each do |prefix, paths|
              child = Class.new(::Sinatra::Base)
              child.route_prefix = prefix
              paths.each { |path| child.class_eval(File.read(path), path, 1) }

              parent.use(child)
            end
          end

          def route(verb, path, options = {}, &block)
            unless route_prefix.to_s.empty?
              path = Mustermann.new(FileBased.join(route_prefix, path), type: :expo)
            end

            super(
              verb,
              path,
              options,
              &block
            )
          end
        end
      end
    end
  end
end

class Sinatra::Base # rubocop:disable Style/ClassAndModuleChildren
  set :route_prefix, ""

  class << self
    prepend Ratalada::Contrib::Router::FileBased::SinatraAdapter
  end
end

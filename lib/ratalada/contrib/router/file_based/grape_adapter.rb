# frozen_string_literal: true

require "grape"

require_relative "../file_based"

module Ratalada
  module Contrib
    module Router
      module FileBased
        # The Grape half of file-based routing. Each route file is built the way
        # `Server.run`'s block is — class_eval'd into a Grape::API subclass, file
        # contents in place of the block — and Grape then re-hosts that built API
        # under the prefix its path spelled:
        #
        #   parent.mount(file_api => "/teams/:team/settings")
        #
        # `mount` is Grape's own (DSL::Routing#mount): it stores the mount path on
        # the child's settings and replays its endpoints into the parent, so the
        # file's `get "/members"` compiles as "/teams/:team/settings/members" with
        # :team in params. Nothing about Grape's path handling is reimplemented.
        module GrapeAdapter
          module_function

          # Returns the Grape::API subclass with every route file mounted.
          def build(directory)
            Class.new(::Grape::API).tap do |app|
              FileBased.build_map(directory).each do |prefix, paths|
                app.mount(build_file(paths) => mount_path(prefix))
              end
            end
          end

          # One route file and the layouts above it, built exactly like a
          # Server.run block: the layouts' `helpers`, `before` blocks and `use`
          # calls land in the same API as the file's own routes.
          def build_file(paths)
            Class.new(::Grape::API).tap do |api|
              paths.each { |path| api.class_eval(File.read(path), path, 1) }
            end
          end

          # A root file has no prefix; Grape spells that mount point "/".
          def mount_path(prefix)
            case prefix
            when "" then "/"
            else prefix
            end
          end
        end
      end
    end
  end
end

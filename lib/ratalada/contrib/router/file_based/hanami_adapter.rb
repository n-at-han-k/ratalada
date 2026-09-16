# frozen_string_literal: true

require "hanami/api"

require_relative "../file_based"

module Ratalada
  module Contrib
    module Router
      module FileBased
        # The Hanami half of file-based routing. Hanami::API compiles routes
        # straight into the router's trie, so there is no route list to rewrite
        # afterwards the way Sinatra's Mustermann patterns can be — what it has
        # instead is `scope`, the prefix its own router applies while routes are
        # being defined (Hanami::Router#scope). So the file is evaluated inside
        # the scope its path spells, which is the same result one step earlier:
        #
        #   # app/teams/[team]/settings/index.rb
        #   get "/members" do
        #     "members of #{params[:team]}"
        #   end
        #
        # becomes "/teams/:team/settings/members". The file's blocks still run in
        # the app's own Block::Context, so `params`, `halt` and any `helpers` are
        # the ones the app defines.
        module HanamiAdapter
          module_function

          # Returns the rack app: a Hanami::API subclass instance, as the Hanami
          # frontend builds it, with every route file evaluated into it.
          def build(directory)
            app = Class.new(::Hanami::API)

            FileBased.build_map(directory).each do |prefix, paths|
              mount_route_file(app, prefix, paths)
            end

            app.new
          end

          # The layouts above the file are evaluated in the same scope, ahead of
          # it, so what they add (`use`, extra routes) applies to that prefix.
          def mount_route_file(app, prefix, paths)
            sources = paths.map { |path| [File.read(path), path] }

            # `scope` instance_evals its block on the router, so the file's own
            # `get`/`post` calls are the router's, under the prefix.
            app.router.scope(prefix) do
              sources.each { |source, path| instance_eval(source, path, 1) }
            end
          end
        end
      end
    end
  end
end

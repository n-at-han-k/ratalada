# frozen_string_literal: true

require "mustermann"
require "rack"
require "sinatra/base"

require_relative "../file_based"

module Ratalada
  module Contrib
    module Router
      module FileBased
        # The Sinatra half of file-based routing: each route file is built the
        # same way `Server.run`'s block is — class_eval'd into a Sinatra::Base
        # subclass — with the file's contents as the input instead of a block. So
        # a file is ordinary Sinatra:
        #
        #   # app/teams/[team]/settings/index.rb
        #   get "/members" do
        #     "members of #{params[:team]}"
        #   end
        #
        # Building it yields an app object whose compiled routes are Mustermann
        # patterns, and those are what the prefix from FileBased gets prepended
        # to — Mustermann concatenates patterns itself, so "/teams/:team" +
        # "/members" stays one pattern with both captures.
        #
        # The rewritten apps are then chained: a Sinatra app used as rack
        # middleware forwards the request onward when none of its own routes
        # matched (Base#route_missing), so the first file that spells the path
        # answers and the last one falls through to a plain 404.
        module SinatraAdapter
          NOT_FOUND = lambda do |_env|
            [404, { "content-type" => "text/plain" }, ["Not Found"]]
          end

          module_function

          def build(directory)
            apps = FileBased.build_map(directory).map do |prefix, paths|
              prefix_routes(build_file(paths), prefix)
            end

            # ponytail: one Sinatra app (and its middleware stack) per file, walked
            # in order per request. Collapse into one app class if a fat tree ever
            # shows up in a profile.
            ::Rack::Builder.new.tap do |builder|
              apps.each { |app| builder.use(app) }
              builder.run(NOT_FOUND)
            end.to_app
          end

          # One route file and the layouts above it, built exactly like a
          # Server.run block: the layouts' `helpers`, `before` filters and `use`
          # calls land in the same class as the file's own routes.
          def build_file(paths)
            Class.new(::Sinatra::Base).tap do |app|
              paths.each { |path| app.class_eval(File.read(path), path, 1) }
            end
          end

          # Rewrites every route the built app holds to sit under `prefix`.
          def prefix_routes(app, prefix)
            pattern = ::Mustermann.new(prefix, type: :sinatra)

            app.routes.each_value do |signatures|
              signatures.map! do |(route, conditions, wrapper)|
                [nest(pattern, route), conditions, wrapper]
              end
            end

            app
          end

          # A file's own "/" is the prefix itself, not the prefix with a trailing
          # slash, so it is the one pattern that replaces rather than extends —
          # as is any route in a file that sits at the root, where the prefix is
          # empty.
          def nest(prefix, route)
            case [prefix.to_s, route.to_s]
            in ["", _] then route
            in [_, "/"] then prefix
            else prefix + route
            end
          end
        end
      end
    end
  end
end

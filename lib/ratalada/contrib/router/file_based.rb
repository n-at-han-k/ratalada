# frozen_string_literal: true

require "ratalada"

require_relative "file_based/expo"

module Ratalada
  module Contrib
    module Router
      module FileBased
        LAYOUT = "_layout.rb"

        module_function

        # Evaluates every route file under the directory into the app class.
        #
        # @example
        #   Server.run { Ratalada::Contrib::Router::FileBased.mount(self, "app") }
        #
        # @parameter app [Object] the frontend app class.
        # @parameter directory [String] the route file root.
        # @returns [void]
        def mount(app, directory)
          # The adapter says how its frontend spells a placeholder; the default is `:name`, which is what hanami and grape read.
          if app.respond_to?(:route_spelling)
            spelling = app.route_spelling
          else
            spelling = {}
          end

          map = build_map(directory, **spelling)

          # An adapter that can give each route file its own class does, so a _layout.rb's `use`, `set`, `before` and `error` reach only the files below it. Without that the whole tree shares one class and a nested layout's filter fires for every route in the app.
          if app.respond_to?(:mount_files)
            app.mount_files(app, map)
          else
            map.each do |prefix, paths|
              app.route_prefix = prefix
              paths.each { |path| app.class_eval(File.read(path), path, 1) }
            end
          end
        end

        # Builds a whole app from the directory, for mounting elsewhere.
        #
        # @parameter directory [String] the route file root.
        # @returns [Object] the built app.
        def build(directory)
          Ratalada.frontend.build(proc { FileBased.mount(self, directory) })
        end

        # A hash of route => the files that serve it, most specific first.
        #
        # @example
        #   {
        #     "/organisations/:id/edit" => ["./app/organisations/[id]/edit.rb"]
        #   }
        #
        # @parameter directory [String] the route file root.
        # @parameter placeholder [String] the adapter's placeholder spelling.
        # @parameter catch_all [String] the adapter's catch-all spelling.
        # @returns [Hash] route => files.
        def build_map(directory, placeholder: ":%s", catch_all: "*%s")
          root = File.expand_path(directory)

          Dir.glob("**/*.rb", base: root)
            .reject { |relative| relative.split("/").any? { |segment| segment.start_with?("_") } }
            .map { |relative| [Mustermann::Expo.route(relative), files(root, relative)] }
            .sort_by { |(route, _paths)| [specificity(route), route] }
            .to_h { |(route, paths)| [spell(route, placeholder, catch_all), paths] }
        end

        def files(root, relative)
          directories = relative.split("/")[0..-2]

          layouts = directories.each_index.map do |index|
            File.join(root, *directories[0..index], LAYOUT)
          end

          [File.join(root, LAYOUT), *layouts]
            .select { |path| File.file?(path) }
            .push(File.join(root, relative))
        end

        # An expo route in the adapter's own spelling.
        #
        # @parameter route [String] the expo route.
        # @parameter placeholder [String] the adapter's placeholder spelling.
        # @parameter catch_all [String] the adapter's catch-all spelling.
        # @returns [String] the adapter's route.
        def spell(route, placeholder, catch_all)
          route.delete_suffix("/").gsub(%r{\[(\.\.\.)?([^\[\]/]+)\]}) do
            format(Regexp.last_match(1) ? catch_all : placeholder, Regexp.last_match(2))
          end
        end

        def join(prefix, route)
          "#{prefix}#{route.delete_suffix("/")}".sub(/\A\z/, "/")
        end

        # How specific a route is, as a list of per-segment weights.
        #
        # @parameter route [String] the route path.
        # @returns [Array(Integer)] the segment weights, least specific last.
        def specificity(route)
          route.split("/").drop(1).map do |segment|
            case segment
            when "[...#{Mustermann::Expo::NOT_FOUND_CAPTURE}]" then 4
            when /\A\[\.\.\.[^\[\]]+\]\z/ then 3
            when /\A\[[^\[\]]+\]\z/ then 2
            when /\[.+\]/ then 1
            else 0
            end
          end
        end
      end
    end
  end
end

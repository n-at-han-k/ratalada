# frozen_string_literal: true

require "ratalada"

require_relative "file_based/expo"

module Ratalada
  module Contrib
    module Router
      module FileBased
        LAYOUT = "_layout.rb"

        module_function

        # The app, built by whichever Ratalada frontend is in use: every route
        # file is evaluated into the frontend's own class, under the prefix its
        # path spells. Requiring the frontend's adapter is what teaches that
        # class `route_prefix`.
        def build(directory)
          map = build_map(directory)

          routes = proc do
            map.each do |prefix, paths|
              self.route_prefix = prefix
              paths.each { |path| class_eval(File.read(path), path, 1) }
            end
          end

          Ratalada.frontend.build(routes)
        end

        # A hash of route => the files that serve it, ordered most specific
        # first. Mustermann::Expo does the file path => route translation; all
        # this adds is which files to evaluate and how the adapter spells a
        # placeholder.
        #
        # {
        #   "/organisations/:id/edit" => ["./app/organisations/[id]/edit.rb"]
        # }
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

        # An expo route in the adapter's own spelling: "/teams/[team]" => "/teams/:team".
        # The root route is "" — a prefix nothing hangs off, not a route of "/".
        def spell(route, placeholder, catch_all)
          route.delete_suffix("/").gsub(%r{\[(\.\.\.)?([^\[\]/]+)\]}) do
            format(Regexp.last_match(1) ? catch_all : placeholder, Regexp.last_match(2))
          end
        end

        def join(prefix, route)
          "#{prefix}#{route.delete_suffix("/")}".sub(/\A\z/, "/")
        end

        def specificity(route)
          route.split("/").drop(1).map do |segment|
            case segment
            when "[...#{Mustermann::Expo::NOT_FOUND_CAPTURE}]" then 3
            when /\A\[\.\.\..+\]\z/ then 2
            when /\A\[.+\]\z/ then 1
            else 0
            end
          end
        end
      end
    end
  end
end

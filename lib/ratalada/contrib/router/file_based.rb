# frozen_string_literal: true

require "ratalada"

require_relative "file_based/expo"

module Ratalada
  module Contrib
    module Router
      module FileBased
        LAYOUT = "_layout.rb"

        module_function

        # Evaluates every route file in the directory into an app class, under
        # the prefix its path spells. That class is the frontend's own, so this
        # is what a Server.run block calls: the block is already being evaluated
        # into it, and `self` is it. Requiring the frontend's adapter is what
        # teaches the class `route_prefix`.
        #
        #   Server.run { Ratalada::Contrib::Router::FileBased.mount(self, "app") }
        def mount(app, directory)
          build_map(directory).each do |prefix, paths|
            app.route_prefix = prefix
            paths.each { |path| app.class_eval(File.read(path), path, 1) }
          end
        end

        # The same, as a whole app built by whichever Ratalada frontend is in
        # use — for mounting a directory somewhere other than the server's own
        # run block.
        def build(directory)
          Ratalada.frontend.build(proc { FileBased.mount(self, directory) })
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

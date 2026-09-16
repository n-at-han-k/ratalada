# frozen_string_literal: true

module Ratalada
  module Contrib
    module Router
      # Turns an expo-router style directory of route files into an ordered map
      # of `prefix => path`. The prefix is what the file's own routes hang off:
      # a file says `get "/members" do ... end` and the adapter mounts that under
      # the prefix its path spells, so each adapter only has to decide how it
      # loads a file and how it spells a placeholder.
      #
      #   Ratalada::Contrib::Router::FileBased.build_map("app")
      #   # => { "" => "app/index.rb",
      #   #      "/organizations/:slug" => "app/organizations/[slug]/index.rb", ... }
      #
      #   FileBased.join("/organizations/:slug", "/users")  # => "/organizations/:slug/users"
      #   FileBased.join("/organizations/:slug", "/")       # => "/organizations/:slug"
      #   FileBased.join("", "/")                           # => "/"
      #
      # Conventions, all borrowed from expo-router:
      #
      #   index.rb          the directory itself           app/teams/index.rb => /teams
      #   [slug].rb         a single dynamic segment       => /:slug
      #   [...rest].rb      a catch-all                    => /*rest
      #   (group)/          grouping only, not a segment   app/(marketing)/docs.rb => /docs
      #   +not-found.rb     the fallback                   => /*
      #   _layout.rb        not a route of its own: its contents are evaluated
      #                     into every route file below it, outermost first, so
      #                     a layout is whatever the file could have written for
      #                     itself (helpers, filters, middleware, extra routes).
      #                     Any other `_` file or directory is ignored outright.
      #
      # A map value is the list of files to evaluate, in order: the `_layout.rb`
      # of each directory from the root down, then the route file itself.
      #
      # The map is ordered most specific first (static segments before dynamic,
      # dynamic before catch-all, +not-found last), so an adapter can define the
      # routes in iteration order under a first-match-wins router.
      module FileBased
        NOT_FOUND = "+not-found"
        LAYOUT = "_layout.rb"

        module_function

        def build_map(directory, placeholder: ":%s", catch_all: "*%s")
          root = File.expand_path(directory)

          entries = Dir.glob("**/*.rb", base: root).filter_map do |relative|
            segments = route_segments(relative)

            unless segments.nil?
              [pattern(segments, placeholder, catch_all), files(root, relative), segments]
            end
          end

          entries
            .sort_by { |(pattern, _files, segments)| [specificity(segments), pattern] }
            .to_h { |(pattern, paths, _segments)| [pattern, paths] }
        end

        # The route file, with the `_layout.rb` of every directory above it in
        # front — outermost first, so an inner layout is evaluated last and can
        # override what an outer one set up.
        def files(root, relative)
          directories = relative.split("/")[0..-2]

          layouts = directories.each_index.map do |index|
            File.join(root, *directories[0..index], LAYOUT)
          end

          [File.join(root, LAYOUT), *layouts].select { |path| File.file?(path) }
            .push(File.join(root, relative))
        end

        # The route segments of a file, or nil when the file is not a route.
        def route_segments(relative)
          unless relative.split("/").any? { |segment| segment.start_with?("_") }
            "/#{relative.delete_suffix(".rb")}"
              .delete_suffix("/index")
              .split("/")
              .drop(1)
              .reject { |segment| segment.match?(/\A\(.*\)\z/) }
          end
        end

        def pattern(segments, placeholder, catch_all)
          spelled = segments.map do |segment|
            case segment
            when /\A\[\.\.\.(.+)\]\z/ then format(catch_all, Regexp.last_match(1))
            when /\A\[(.+)\]\z/ then format(placeholder, Regexp.last_match(1))
            when NOT_FOUND then format(catch_all, "unmatched")
            else segment
            end
          end

          spelled.map { |segment| "/#{segment}" }.join
        end

        # Hangs one of a file's own routes off the prefix its path spelled.
        def join(prefix, route)
          "#{prefix}#{route.delete_suffix("/")}".sub(/\A\z/, "/")
        end

        # Sorts static segments ahead of dynamic ones at the same depth, and the
        # +not-found fallback behind everything.
        def specificity(segments)
          segments.map do |segment|
            case segment
            when NOT_FOUND then 3
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

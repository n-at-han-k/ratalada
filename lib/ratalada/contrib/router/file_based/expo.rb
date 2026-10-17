# frozen_string_literal: true

require "mustermann"
require "mustermann/ast/pattern"

module Mustermann
  # Expo Router style pattern implementation.
  #
  # @example
  #   Mustermann.new('/[foo]', type: :expo) === '/bar' # => true
  #
  # @see Mustermann::Pattern
  class Expo < AST::Pattern
    register :expo

    NOT_FOUND = "+not-found"
    NOT_FOUND_CAPTURE = "unmatched"

    # Turns an Expo Router file path into the route it serves.
    #
    # @parameter string [String] the file path, relative to the route root.
    # @returns [String] the route it serves.
    def self.route(string)
      string   = string.sub(%r{\A(?:\.\.?/|/)+}, "")
      string   = string.sub(/(\+api)?\.rb$/, "").sub(%r{/?_layout$}, "")
      segments = (?/ + string.delete_prefix(?/)).split(?/, -1)
      if segments.last == "index"
        segments.pop
      end
      segments.reject! { |s| s =~ /\A\(.+\)\z/ }
      if segments.last == NOT_FOUND
        segments[-1] = "[...#{NOT_FOUND_CAPTURE}]"
      end
      segments.join(?/).then { |route| route.empty? ? ?/ : route }
    end

    def initialize(string, **options)
      super(Expo.route(string), **options)
    end

    on(nil, ?]) { |c| unexpected(c) }

    on(?[) do |char|
      name = expect(%r{[^\[\]/]+}, char: char)
      expect(?])

      if name.start_with?("...")
        node(:named_splat, name[3..], constraint: ".+", convert: ->(e) { e.split(?/) })
      else
        node(:capture, name)
      end
    end
  end
end

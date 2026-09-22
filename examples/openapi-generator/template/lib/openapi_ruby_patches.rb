# frozen_string_literal: true

require "openapi_ruby"

module OpenapiRuby
  module Adapters
    module RSpec
      # Path parameters are substituted with /\{(\w+)\}/ upstream, and `\w`
      # excludes the hyphen -- so Forgejo's `{user-id}` is never filled and
      # the request goes out with the template still in the URI, which
      # raises URI::InvalidURIError. A path parameter's name is whatever the
      # document says it is; anything but a brace or a slash counts.
      module HyphenatedPathParams
        TEMPLATE = /\{([^{}\/]+)\}/

        def expand_path(template, params)
          template.gsub(TEMPLATE) do
            name = ::Regexp.last_match(1)

            params[name.to_sym] || params[name.to_s] || "{#{name}}"
          end
        end

        def resolve_path(metadata)
          super.gsub(TEMPLATE) do
            name = ::Regexp.last_match(1)

            resolve_let(name.to_sym) || "{#{name}}"
          end
        end
      end

      ExampleHelpers.prepend(HyphenatedPathParams)
    end
  end
end
